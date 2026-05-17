Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "lib\common.ps1")

$OpenAfterGenerate = $false

foreach ($arg in $args) {
  switch ($arg) {
    "--open" { $OpenAfterGenerate = $true }
    "-o" { $OpenAfterGenerate = $true }
    "--help" {
      Write-Line "用法：.\vibe-coding\vibe-starter\scripts\report.ps1 [--open]"
      exit 0
    }
    "-h" {
      Write-Line "用法：.\vibe-coding\vibe-starter\scripts\report.ps1 [--open]"
      exit 0
    }
    default {
      Fail "不支援的 report 參數：$arg"
    }
  }
}

function Ensure-ReportSourceFiles {
  Ensure-Dir $Script:ReportsDir
  Ensure-Dir $Script:ReportDataDir
  Ensure-Dir $Script:ReportHtmlDir

  $statePath = Join-Path $Script:ReportDataDir "project-state.yml"
  if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
    Copy-Item -LiteralPath (Join-Path $Script:StarterRoot "templates\reports\data\project-state.yml") -Destination $statePath -Force
  }

  $statusPath = Join-Path $Script:ReportsDir "current-status.md"
  if (-not (Test-Path -LiteralPath $statusPath -PathType Leaf)) {
    Copy-Item -LiteralPath (Join-Path $Script:StarterRoot "templates\reports\current-status.md") -Destination $statusPath -Force
  }
}

function ConvertTo-HtmlText {
  param([AllowNull()][string]$Value)

  return [System.Net.WebUtility]::HtmlEncode($Value)
}

function Get-FirstMatch {
  param(
    [string]$Pattern,
    [string]$Text
  )

  $match = [regex]::Match($Text, $Pattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
  if (-not $match.Success) {
    return ""
  }

  return $match.Groups[1].Value.Trim().Trim('"').Trim("'")
}

function Get-TopLevelBlock {
  param(
    [string]$Name,
    [string]$Text
  )

  $pattern = "(?m)^" + [regex]::Escape($Name) + ":\r?\n(?<body>(?:[ `t].*(?:\r?\n)|[ `t]*(?:\r?\n))*)"
  $match = [regex]::Match($Text, $pattern)
  if (-not $match.Success) {
    return ""
  }

  return $match.Groups["body"].Value.TrimEnd()
}

function Get-NestedScalar {
  param(
    [string]$Block,
    [string]$Key
  )

  return Get-FirstMatch -Pattern ("^[ `t]+" + [regex]::Escape($Key) + ":[ `t]*(.*)$") -Text $Block
}

function Get-MarkdownSnapshotTime {
  param([string]$Text)

  return Get-FirstMatch -Pattern "^(?:彙整時間|summarized_at)[ `t]*[：:][ `t]*(.*)$" -Text $Text
}

function Convert-MarkdownToHtml {
  param([string]$Text)

  $output = [System.Collections.Generic.List[string]]::new()
  $paragraph = [System.Collections.Generic.List[string]]::new()
  $listOpen = $false

  function Flush-Paragraph {
    if ($paragraph.Count -gt 0) {
      $joinedParagraph = $paragraph -join " "
      $output.Add("<p>$(ConvertTo-HtmlText $joinedParagraph)</p>")
      $paragraph.Clear()
    }
  }

  function Flush-List {
    if ($script:listOpen) {
      $output.Add("</ul>")
      $script:listOpen = $false
    }
  }

  $script:listOpen = $listOpen
  foreach ($rawLine in ($Text -split "\r?\n")) {
    $line = $rawLine.TrimEnd()
    if ([string]::IsNullOrWhiteSpace($line)) {
      Flush-Paragraph
      Flush-List
      continue
    }

    $heading = [regex]::Match($line, "^(#{1,6})\s+(.*)$")
    if ($heading.Success) {
      Flush-Paragraph
      Flush-List
      $level = [Math]::Min($heading.Groups[1].Value.Length + 1, 6)
      $output.Add("<h$level>$(ConvertTo-HtmlText $heading.Groups[2].Value)</h$level>")
      continue
    }

    $bullet = [regex]::Match($line, "^\s*[-*]\s+(.*)$")
    if ($bullet.Success) {
      Flush-Paragraph
      if (-not $script:listOpen) {
        $output.Add("<ul>")
        $script:listOpen = $true
      }
      $output.Add("<li>$(ConvertTo-HtmlText $bullet.Groups[1].Value)</li>")
      continue
    }

    $paragraph.Add($line.Trim())
  }

  Flush-Paragraph
  Flush-List
  return ($output -join "`n")
}

function New-ReportSection {
  param(
    [string]$Title,
    [string]$Body,
    [bool]$OpenSection = $false
  )

  $openAttr = if ($OpenSection) { " open" } else { "" }
  $id = ($Title.ToLowerInvariant() -replace "\s+", "-")
  $html = @"
      <details class="section" id="$(ConvertTo-HtmlText $id)"$openAttr>
        <summary>$(ConvertTo-HtmlText $Title)</summary>
        <div class="section-body">$Body</div>
      </details>
"@
  return $html
}

function New-YamlSection {
  param(
    [string]$Name,
    [string]$Title,
    [string]$StateText
  )

  $block = Get-TopLevelBlock -Name $Name -Text $StateText
  if ([string]::IsNullOrWhiteSpace($block)) {
    $block = "尚未記錄"
  }

  return New-ReportSection -Title $Title -Body "<pre>$(ConvertTo-HtmlText $block)</pre>"
}

function Invoke-OpenDashboard {
  param([string]$HtmlPath)

  try {
    Start-Process -FilePath $HtmlPath | Out-Null
    Write-Line "已嘗試使用系統預設程式開啟。"
  } catch {
    Write-Line "無法自動開啟，請手動開啟：$HtmlPath"
  }
}

function Render-Dashboard {
  $statePath = Join-Path $Script:ReportDataDir "project-state.yml"
  $statusPath = Join-Path $Script:ReportsDir "current-status.md"
  $htmlPath = Join-Path $Script:ReportHtmlDir "index.html"

  $stateText = [System.IO.File]::ReadAllText($statePath, [System.Text.UTF8Encoding]::new($false))
  $statusText = [System.IO.File]::ReadAllText($statusPath, [System.Text.UTF8Encoding]::new($false))

  $projectBlock = Get-TopLevelBlock -Name "project" -Text $stateText
  $sourceSummarizedAt = Get-FirstMatch -Pattern "^summarized_at:[ `t]*(.*)$" -Text $stateText
  if ([string]::IsNullOrWhiteSpace($sourceSummarizedAt)) {
    $sourceSummarizedAt = Get-MarkdownSnapshotTime -Text $statusText
  }
  if ([string]::IsNullOrWhiteSpace($sourceSummarizedAt)) {
    $sourceSummarizedAt = "未記錄"
  }

  $projectName = Get-NestedScalar -Block $projectBlock -Key "name"
  if ([string]::IsNullOrWhiteSpace($projectName)) { $projectName = "未命名專案" }
  $projectGoal = Get-NestedScalar -Block $projectBlock -Key "goal"
  if ([string]::IsNullOrWhiteSpace($projectGoal)) { $projectGoal = "未記錄" }
  $currentStatus = Get-NestedScalar -Block $projectBlock -Key "current_status"
  if ([string]::IsNullOrWhiteSpace($currentStatus)) { $currentStatus = "未記錄" }
  $currentMilestone = Get-NestedScalar -Block $projectBlock -Key "current_milestone"
  if ([string]::IsNullOrWhiteSpace($currentMilestone)) { $currentMilestone = "未記錄" }
  $updatedAt = Get-NestedScalar -Block $projectBlock -Key "updated_at"
  if ([string]::IsNullOrWhiteSpace($updatedAt)) { $updatedAt = "未記錄" }

  $generatedAt = [DateTimeOffset]::Now.ToString("yyyy-MM-ddTHH:mm:sszzz")
  $sections = @(
    New-ReportSection -Title "Current Status Markdown" -Body (Convert-MarkdownToHtml $statusText) -OpenSection $true
    New-YamlSection -Name "context_view" -Title "Context View" -StateText $stateText
    New-YamlSection -Name "execution_view" -Title "Execution View" -StateText $stateText
    New-YamlSection -Name "risk_view" -Title "Risk View" -StateText $stateText
    New-YamlSection -Name "activity_view" -Title "Activity View" -StateText $stateText
    New-ReportSection -Title "Project State YAML" -Body "<pre>$(ConvertTo-HtmlText $stateText)</pre>"
  )

  $html = @"
<!doctype html>
<html lang="zh-Hant">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$(ConvertTo-HtmlText $projectName) - Project Report</title>
  <style>
    :root { color-scheme: light; --bg: #f5f7fa; --surface: #ffffff; --text: #17202a; --muted: #667085; --line: #d8dee8; --accent: #2563eb; --accent-soft: #e8f0ff; }
    * { box-sizing: border-box; }
    body { margin: 0; font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; color: var(--text); background: var(--bg); }
    header { background: var(--surface); border-bottom: 1px solid var(--line); }
    .wrap { max-width: 1180px; margin: 0 auto; padding: 24px; }
    h1 { margin: 0 0 8px; font-size: 30px; letter-spacing: 0; }
    p { line-height: 1.65; }
    .meta { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 16px; color: var(--muted); font-size: 14px; }
    .pill { border: 1px solid var(--line); border-radius: 999px; padding: 6px 10px; background: #fff; }
    .layout { display: grid; grid-template-columns: 240px 1fr; gap: 20px; align-items: start; }
    nav { position: sticky; top: 12px; background: var(--surface); border: 1px solid var(--line); border-radius: 8px; padding: 12px; }
    nav a { display: block; color: var(--text); text-decoration: none; padding: 8px 10px; border-radius: 6px; font-size: 14px; }
    nav a:hover { background: var(--accent-soft); color: var(--accent); }
    .toolbar { display: flex; gap: 10px; margin-bottom: 16px; }
    input[type="search"] { width: 100%; border: 1px solid var(--line); border-radius: 8px; padding: 11px 12px; font-size: 15px; }
    .cards { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; margin: 18px 0 8px; }
    .card { background: var(--surface); border: 1px solid var(--line); border-radius: 8px; padding: 14px; min-width: 0; }
    .card span { display: block; color: var(--muted); font-size: 12px; margin-bottom: 6px; }
    .card strong { display: block; font-size: 15px; overflow-wrap: anywhere; }
    .section { background: var(--surface); border: 1px solid var(--line); border-radius: 8px; margin-bottom: 12px; overflow: hidden; }
    .section[hidden] { display: none; }
    summary { cursor: pointer; padding: 16px 18px; font-weight: 700; }
    .section-body { border-top: 1px solid var(--line); padding: 18px; }
    pre { white-space: pre-wrap; overflow-wrap: anywhere; background: #111827; color: #f9fafb; padding: 16px; border-radius: 8px; overflow: auto; }
    code { background: #eef2f7; padding: 2px 5px; border-radius: 4px; }
    footer { color: var(--muted); font-size: 13px; padding-top: 16px; }
    @media (max-width: 900px) { .layout { grid-template-columns: 1fr; } nav { position: static; } .cards { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
    @media (max-width: 560px) { .wrap { padding: 18px; } .cards { grid-template-columns: 1fr; } }
  </style>
</head>
<body>
  <header>
    <div class="wrap">
      <h1>$(ConvertTo-HtmlText $projectName)</h1>
      <p>固定格式 Project Report Dashboard。HTML 是靜態 snapshot，不會自動跟著 source 檔或專案資料更新。</p>
      <div class="meta">
        <span class="pill">source_summarized_at: $(ConvertTo-HtmlText $sourceSummarizedAt)</span>
        <span class="pill">generated_at: $(ConvertTo-HtmlText $generatedAt)</span>
        <span class="pill">updated_at: $(ConvertTo-HtmlText $updatedAt)</span>
      </div>
      <div class="cards">
        <div class="card"><span>Goal</span><strong>$(ConvertTo-HtmlText $projectGoal)</strong></div>
        <div class="card"><span>Current Status</span><strong>$(ConvertTo-HtmlText $currentStatus)</strong></div>
        <div class="card"><span>Current Milestone</span><strong>$(ConvertTo-HtmlText $currentMilestone)</strong></div>
        <div class="card"><span>Source</span><strong>YAML + Markdown snapshot</strong></div>
      </div>
    </div>
  </header>
  <main class="wrap layout">
    <nav aria-label="Report sections">
      <a href="#current-status-markdown">Current Status</a>
      <a href="#context-view">Context View</a>
      <a href="#execution-view">Execution View</a>
      <a href="#risk-view">Risk View</a>
      <a href="#activity-view">Activity View</a>
      <a href="#project-state-yaml">Project State YAML</a>
    </nav>
    <div>
      <div class="toolbar"><input id="filter" type="search" placeholder="Filter report text..."></div>
      $($sections -join "`n")
      <footer><p>Report source: <code>reports/data/project-state.yml</code> and <code>reports/current-status.md</code>.</p></footer>
    </div>
  </main>
  <script>
    const filter = document.getElementById('filter');
    const sections = Array.from(document.querySelectorAll('.section'));
    filter.addEventListener('input', () => {
      const q = filter.value.trim().toLowerCase();
      for (const section of sections) {
        const text = section.innerText.toLowerCase();
        section.hidden = q && !text.includes(q);
        if (q && !section.hidden) section.open = true;
      }
    });
  </script>
</body>
</html>
"@

  [System.IO.File]::WriteAllText($htmlPath, $html, [System.Text.UTF8Encoding]::new($false))
  return $htmlPath
}

try {
  Ensure-ProjectRoot
  Ensure-ReportSourceFiles
  $htmlPath = Render-Dashboard
  Write-Line "報告已產生：$htmlPath"
  if ($OpenAfterGenerate) {
    Invoke-OpenDashboard -HtmlPath $htmlPath
  }
} catch {
  [Console]::Error.WriteLine($_.Exception.Message)
  exit 1
}
