Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "lib\common.ps1")

$OpenAfterGenerate = $false
Initialize-Starter -ArgList $args

foreach ($arg in $Script:StarterArgs) {
  switch ($arg) {
    "--open" { $OpenAfterGenerate = $true }
    "-o" { $OpenAfterGenerate = $true }
    "--help" {
      Write-Line "用法：.\vibe-coding\vibe-starter\scripts\report.ps1 [--open] [--project-root <path>]"
      exit 0
    }
    "-h" {
      Write-Line "用法：.\vibe-coding\vibe-starter\scripts\report.ps1 [--open] [--project-root <path>]"
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

function New-Panel {
  param(
    [string]$Title,
    [string]$Body,
    [string]$Id = ""
  )

  $idAttr = if ([string]::IsNullOrWhiteSpace($Id)) { "" } else { " id=`"$(ConvertTo-HtmlText $Id)`"" }
  $html = @"
    <section class="panel"$idAttr>
      <h2>$(ConvertTo-HtmlText $Title)</h2>
      $Body
    </section>
"@
  return $html
}

function Get-YamlBlock {
  param(
    [string]$Name,
    [string]$StateText
  )

  $block = Get-TopLevelBlock -Name $Name -Text $StateText
  if ([string]::IsNullOrWhiteSpace($block)) {
    return "尚未記錄"
  }

  return $block
}

function New-YamlPanel {
  param(
    [string]$Name,
    [string]$Title,
    [string]$Id,
    [string]$StateText
  )

  $block = Get-YamlBlock -Name $Name -StateText $StateText
  return New-Panel -Title $Title -Id $Id -Body "<pre>$(ConvertTo-HtmlText $block)</pre>"
}

function Get-KeywordCount {
  param(
    [string]$Text,
    [string[]]$Keywords
  )

  $count = 0
  foreach ($keyword in $Keywords) {
    $matches = [regex]::Matches($Text, "\b" + [regex]::Escape($keyword) + "\b", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $count += $matches.Count
  }
  return $count
}

function Get-DisplayCount {
  param([int]$Count)

  if ($Count -gt 0) {
    return [string]$Count
  }
  return "—"
}

function Get-CompactText {
  param(
    [AllowNull()][string]$Text,
    [int]$Limit = 72
  )

  $normalized = ([regex]::Replace([string]$Text, "\s+", " ")).Trim()
  if ([string]::IsNullOrWhiteSpace($normalized)) {
    return "未記錄"
  }
  if ($normalized.Length -le $Limit) {
    return $normalized
  }
  return $normalized.Substring(0, $Limit - 1).TrimEnd() + "..."
}

function Get-MarkdownSection {
  param(
    [string]$Text,
    [string[]]$TitlePatterns
  )

  $capture = $false
  $captured = [System.Collections.Generic.List[string]]::new()
  foreach ($line in ($Text -split "\r?\n")) {
    $heading = [regex]::Match($line, "^(#{1,6})\s+(.*)$")
    if ($heading.Success) {
      if ($capture) {
        break
      }
      $title = $heading.Groups[2].Value.Trim().ToLowerInvariant()
      foreach ($pattern in $TitlePatterns) {
        if ($title.Contains($pattern.ToLowerInvariant())) {
          $capture = $true
          break
        }
      }
      continue
    }

    if ($capture) {
      $captured.Add($line)
    }
  }

  return (($captured -join "`n").Trim())
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
  $executionBlock = Get-YamlBlock -Name "execution_view" -StateText $stateText
  $contextBlock = Get-YamlBlock -Name "context_view" -StateText $stateText
  $riskBlock = Get-YamlBlock -Name "risk_view" -StateText $stateText
  $nextActionsText = Get-MarkdownSection -Text $statusText -TitlePatterns @("next", "下一步", "todo", "action")
  if ([string]::IsNullOrWhiteSpace($nextActionsText)) {
    $nextActionsText = "尚未整理。請由 AI 依目前專案狀態補入下一步。"
  }

  $completedCount = Get-DisplayCount (Get-KeywordCount -Text $executionBlock -Keywords @("completed", "done"))
  $activeCount = Get-DisplayCount (Get-KeywordCount -Text $executionBlock -Keywords @("active", "executing"))
  $pendingValidationCount = Get-DisplayCount (Get-KeywordCount -Text $executionBlock -Keywords @("pending"))
  $riskCount = Get-DisplayCount (Get-KeywordCount -Text $riskBlock -Keywords @("severity", "risk"))
  $compactMilestone = Get-CompactText -Text $currentMilestone -Limit 24
  $compactStatus = Get-CompactText -Text $currentStatus -Limit 24

  $mainPanels = @(
    New-YamlPanel -Name "execution_view" -Title "Milestone Progress" -Id "milestone-progress" -StateText $stateText
    New-Panel -Title "Pending Validations" -Id "pending-validations" -Body "<pre>$(ConvertTo-HtmlText $executionBlock)</pre>"
    New-YamlPanel -Name "risk_view" -Title "Risks" -Id "risks" -StateText $stateText
    New-YamlPanel -Name "debt_view" -Title "Technical Debt" -Id "technical-debt" -StateText $stateText
    New-YamlPanel -Name "activity_view" -Title "Recent Handoffs & Activity" -Id "recent-handoffs-activity" -StateText $stateText
    New-Panel -Title "Current Status Markdown" -Id "current-status" -Body (Convert-MarkdownToHtml $statusText)
    New-Panel -Title "Project State YAML" -Id "project-state-yaml" -Body "<pre>$(ConvertTo-HtmlText $stateText)</pre>"
  )

  $sidePanels = @(
    New-Panel -Title "Next Actions" -Id "next-actions" -Body (Convert-MarkdownToHtml $nextActionsText)
    New-Panel -Title "Observations" -Id "observations" -Body "<pre>$(ConvertTo-HtmlText $contextBlock)</pre>"
    New-Panel -Title "Future Options" -Id "future-options" -Body "<pre>$(ConvertTo-HtmlText $contextBlock)</pre>"
    New-Panel -Title "Pending Decisions" -Id "pending-decisions" -Body "<pre>$(ConvertTo-HtmlText $contextBlock)</pre>"
  )

  $html = @"
<!doctype html>
<html lang="zh-Hant">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$(ConvertTo-HtmlText $projectName) - Project Report</title>
<style>
  :root {
    --bg:#f1f5f9; --surface:#fff; --surface-2:#f8fafc;
    --text:#0f172a; --muted:#64748b; --line:#e2e8f0;
    --teal:#0d9488; --amber:#d97706; --red:#dc2626; --green:#16a34a; --slate:#475569;
    --t-meta:1rem; --t-body:1.067rem; --t-item:1.2rem; --t-h3:1.333rem; --t-h2:1.467rem; --t-h1:2rem;
  }
  *{box-sizing:border-box}
  html{font-size:15px}
  body{margin:0;font-family:system-ui,-apple-system,"Segoe UI",sans-serif;color:var(--text);background:var(--bg);font-size:var(--t-body);line-height:1.6}
  .wrap{max-width:1280px;margin:0 auto;padding:1.5rem}
  header{background:var(--surface);border-bottom:1px solid var(--line)}
  h1{margin:0;font-size:var(--t-h1);font-weight:700;letter-spacing:0}
  h2{margin:0 0 1rem;font-size:var(--t-h2);font-weight:700;color:var(--slate);text-transform:uppercase;letter-spacing:.04em}
  h3{margin:1rem 0 .375rem;font-size:var(--t-h3);font-weight:600}
  p{margin:.5rem 0;line-height:1.65}
  .sub{color:var(--muted);font-size:var(--t-body);margin-top:.5rem}
  .meta-row{display:flex;flex-wrap:wrap;gap:.5rem;margin-top:.875rem;font-size:var(--t-meta);color:var(--muted)}
  .meta-row span{background:var(--surface-2);border:1px solid var(--line);border-radius:999px;padding:.375rem .75rem}
  .kpis{display:grid;grid-template-columns:repeat(6,1fr);gap:.75rem;margin:1.25rem 0 0}
  .kpi{background:var(--surface);border:1px solid var(--line);border-radius:.5rem;padding:1rem;display:flex;flex-direction:column;gap:.625rem;min-width:0}
  .kpi .label{color:var(--muted);font-size:var(--t-meta);line-height:1;height:1.125rem;display:flex;align-items:center;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  .kpi .value{font-size:var(--t-h1);font-weight:700;color:var(--text);line-height:1;height:2.25rem;display:inline-flex;align-items:center}
  .kpi .delta{color:var(--muted);font-size:var(--t-meta);line-height:1;height:1.125rem;display:flex;align-items:center;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  .kpi.ok .value{color:var(--green)}
  .kpi.warn .value{color:var(--amber)}
  .kpi.danger .value{color:var(--red)}
  .toolbar{margin:0 0 1rem}
  input[type="search"]{width:100%;border:1px solid var(--line);border-radius:.5rem;padding:.75rem .875rem;font-size:1rem;background:var(--surface)}
  main{display:grid;grid-template-columns:1fr 20rem;gap:1.25rem;margin-top:1.25rem}
  .panel{background:var(--surface);border:1px solid var(--line);border-radius:.625rem;padding:1.125rem;margin-bottom:.875rem}
  .panel[hidden]{display:none}
  aside .panel{padding:1rem}
  pre{white-space:pre-wrap;overflow-wrap:anywhere;background:var(--surface-2);border:1px solid var(--line);color:var(--slate);padding:1rem;border-radius:.5rem;overflow:auto;font-size:.95rem;line-height:1.55}
  code{background:#eef2f7;padding:.125rem .375rem;border-radius:.25rem}
  ul,ol{padding-left:1.25rem}
  li{margin:.25rem 0}
  footer{color:var(--muted);font-size:var(--t-meta);padding:1.125rem 0;text-align:center}
  @media (max-width:1000px){.kpis{grid-template-columns:repeat(3,1fr)}main{grid-template-columns:1fr}aside .panel{padding:.875rem}}
  @media (max-width:620px){.wrap{padding:1rem}.kpis{grid-template-columns:1fr 1fr}}
</style>
</head>
<body>
<header>
  <div class="wrap">
    <h1>$(ConvertTo-HtmlText $projectName) <span style="color:var(--muted);font-weight:500;font-size:var(--t-h3)">- Project Report</span></h1>
    <p class="sub">$(ConvertTo-HtmlText $projectGoal)</p>
    <div class="meta-row">
      <span>source_summarized_at: $(ConvertTo-HtmlText $sourceSummarizedAt)</span>
      <span>generated_at: $(ConvertTo-HtmlText $generatedAt)</span>
      <span>updated_at: $(ConvertTo-HtmlText $updatedAt)</span>
      <span>current_status: $(ConvertTo-HtmlText $currentStatus)</span>
      <span>current_milestone: $(ConvertTo-HtmlText $currentMilestone)</span>
    </div>
    <div class="kpis">
      <div class="kpi ok"><div class="label">已完成項目</div><div class="value">$completedCount</div><div class="delta">execution_view snapshot</div></div>
      <div class="kpi"><div class="label">作用中項目</div><div class="value">$activeCount</div><div class="delta">$(ConvertTo-HtmlText $compactMilestone)</div></div>
      <div class="kpi warn"><div class="label">待驗證</div><div class="value">$pendingValidationCount</div><div class="delta">validations / pending</div></div>
      <div class="kpi danger"><div class="label">風險紀錄</div><div class="value">$riskCount</div><div class="delta">risk_view snapshot</div></div>
      <div class="kpi"><div class="label">資料彙整</div><div class="value">YML</div><div class="delta">$(ConvertTo-HtmlText $sourceSummarizedAt)</div></div>
      <div class="kpi"><div class="label">狀態輸出</div><div class="value">MD</div><div class="delta">$(ConvertTo-HtmlText $compactStatus)</div></div>
    </div>
  </div>
</header>

<main class="wrap">
  <div>
    <div class="toolbar"><input id="filter" type="search" placeholder="Filter report text..."></div>
    $($mainPanels -join "`n")
  </div>
  <aside>
    $($sidePanels -join "`n")
  </aside>
</main>

<div class="wrap">
  <footer>
    Source: <code>vibe-coding/reports/data/project-state.yml</code> + <code>vibe-coding/reports/current-status.md</code>.
    HTML is a static snapshot; regenerate it when the source summary changes.
  </footer>
</div>

<script>
  const filter = document.getElementById('filter');
  const sections = Array.from(document.querySelectorAll('.panel'));
  filter.addEventListener('input', () => {
    const q = filter.value.trim().toLowerCase();
    for (const section of sections) {
      const text = section.innerText.toLowerCase();
      section.hidden = q && !text.includes(q);
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
