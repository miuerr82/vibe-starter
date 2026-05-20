Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($env:OS -eq "Windows_NT") {
  $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
  [Console]::InputEncoding = $utf8NoBom
  [Console]::OutputEncoding = $utf8NoBom
  $OutputEncoding = $utf8NoBom
}

$Script:ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:StarterRoot = Split-Path -Parent (Split-Path -Parent $Script:ScriptDir)
$Script:ProjectRoot = ""
$Script:WorkspaceDir = ""
$Script:SpecsDir = ""
$Script:HandoffDir = ""
$Script:MilestonesDir = ""
$Script:MilestoneTasksDir = ""
$Script:FeaturesDir = ""
$Script:LayoutsDir = ""
$Script:UiDir = ""
$Script:PrototypesDir = ""
$Script:ReportsDir = ""
$Script:ReportDataDir = ""
$Script:ReportHtmlDir = ""
$Script:NotesDir = ""
$Script:DebtDir = ""
$Script:StarterArgs = @()

function Write-Line {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  [Console]::Out.WriteLine($Message)
}

function Fail {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  throw $Message
}

function Set-ProjectPaths {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Root
  )

  $Script:ProjectRoot = $Root
  $Script:WorkspaceDir = Join-Path $Root "vibe-coding"
  $Script:SpecsDir = Join-Path $Script:WorkspaceDir "specs"
  $Script:HandoffDir = Join-Path $Script:WorkspaceDir "handoff"
  $Script:MilestonesDir = Join-Path $Script:WorkspaceDir "milestones"
  $Script:MilestoneTasksDir = Join-Path $Script:MilestonesDir "tasks"
  $Script:FeaturesDir = Join-Path $Script:WorkspaceDir "features"
  $Script:LayoutsDir = Join-Path $Script:WorkspaceDir "layouts"
  $Script:UiDir = Join-Path $Script:WorkspaceDir "ui"
  $Script:PrototypesDir = Join-Path $Script:WorkspaceDir "prototypes"
  $Script:ReportsDir = Join-Path $Script:WorkspaceDir "reports"
  $Script:ReportDataDir = Join-Path $Script:ReportsDir "data"
  $Script:ReportHtmlDir = Join-Path $Script:ReportsDir "html"
  $Script:NotesDir = Join-Path $Script:WorkspaceDir "notes"
  $Script:DebtDir = Join-Path $Script:WorkspaceDir "debt"
}

function Test-ProjectRootCandidate {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Candidate,
    [string]$Label = "專案根目錄"
  )

  if (-not (Test-Path -LiteralPath $Candidate -PathType Container)) {
    Fail "${Label}不存在：$Candidate"
  }

  $starterPath = Join-Path $Candidate "vibe-coding\vibe-starter"
  if (-not (Test-Path -LiteralPath $starterPath -PathType Container)) {
    Fail "$Label $Candidate 中找不到 vibe-coding/vibe-starter。"
  }

  $expectedRoot = [System.IO.Path]::GetFullPath($Script:StarterRoot)
  $actualRoot = [System.IO.Path]::GetFullPath($starterPath)
  if ($expectedRoot -ne $actualRoot) {
    Fail "$Label $Candidate 中的 vibe-coding/vibe-starter 與目前執行的 vibe-starter ($($Script:StarterRoot)) 不一致。"
  }
}

function Resolve-ProjectRoot {
  param(
    [string[]]$ArgList = @()
  )

  $remaining = New-Object System.Collections.Generic.List[string]
  $explicitRoot = $null
  $i = 0
  while ($i -lt $ArgList.Count) {
    $arg = [string]$ArgList[$i]
    if ($arg -eq "--project-root") {
      if (($i + 1) -ge $ArgList.Count) {
        Fail "--project-root 需要提供路徑參數。"
      }
      $explicitRoot = [string]$ArgList[$i + 1]
      $i += 2
      continue
    }
    if ($arg -like "--project-root=*") {
      $explicitRoot = $arg.Substring("--project-root=".Length)
      $i += 1
      continue
    }
    $remaining.Add($arg)
    $i += 1
  }

  $Script:StarterArgs = $remaining.ToArray()

  if (-not [string]::IsNullOrWhiteSpace($explicitRoot)) {
    Test-ProjectRootCandidate -Candidate $explicitRoot -Label "--project-root"
    Set-ProjectPaths -Root ([System.IO.Path]::GetFullPath($explicitRoot))
    return
  }

  $currentLocation = Get-Location
  $cwd = if ($null -ne $currentLocation.ProviderPath) { $currentLocation.ProviderPath } else { $currentLocation.Path }
  $cwdStarter = Join-Path $cwd "vibe-coding\vibe-starter"
  if (Test-Path -LiteralPath $cwdStarter -PathType Container) {
    $expectedRoot = [System.IO.Path]::GetFullPath($Script:StarterRoot)
    $actualRoot = [System.IO.Path]::GetFullPath($cwdStarter)
    if ($expectedRoot -eq $actualRoot) {
      Set-ProjectPaths -Root $cwd
      return
    }
  }

  $inferred = [System.IO.Path]::GetFullPath((Join-Path $Script:StarterRoot "..\.."))

  $chosen = $null
  $stdinTty = $true
  try {
    $stdinTty = -not [Console]::IsInputRedirected
  } catch {
    $stdinTty = $true
  }

  if ($stdinTty) {
    [Console]::Error.WriteLine("目前不在專案根目錄。")
    [Console]::Error.WriteLine("依腳本位置推論出的專案根目錄為：")
    [Console]::Error.WriteLine("  $inferred")
    $answer = Read-Host "是否使用此路徑？[Y/n/其他絕對路徑]"
    switch -Regex ($answer) {
      "^$" { $chosen = $inferred }
      "^(y|Y|yes|YES)$" { $chosen = $inferred }
      "^(n|N|no|NO)$" {
        $customPath = Read-Host "請輸入專案根目錄絕對路徑"
        if ([string]::IsNullOrWhiteSpace($customPath)) {
          Fail "未提供專案根目錄路徑。"
        }
        $chosen = $customPath
      }
      default { $chosen = $answer }
    }
  } else {
    $chosen = $inferred
  }

  Test-ProjectRootCandidate -Candidate $chosen -Label "解析到的專案根目錄"
  Set-ProjectPaths -Root ([System.IO.Path]::GetFullPath($chosen))
}

function Initialize-Starter {
  param(
    [string[]]$ArgList = @()
  )

  Resolve-ProjectRoot -ArgList $ArgList
}

function Ensure-Dir {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path
  )

  if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Append-UniqueLine {
  param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath,
    [Parameter(Mandatory = $true)]
    [string]$ExpectedLine
  )

  Ensure-Dir (Split-Path -Parent $FilePath)
  if (-not (Test-Path -LiteralPath $FilePath -PathType Leaf)) {
    New-Item -ItemType File -Path $FilePath | Out-Null
  }

  $existingLines = [System.IO.File]::ReadAllLines($FilePath)
  if ($existingLines -notcontains $ExpectedLine) {
    $writer = [System.IO.StreamWriter]::new($FilePath, $true, [System.Text.UTF8Encoding]::new($false))
    try {
      $writer.WriteLine($ExpectedLine)
    } finally {
      $writer.Dispose()
    }
  }
}

function Read-YesNo {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Prompt
  )

  while ($true) {
    $answer = Read-Host "$Prompt [y/N]"
    switch -Regex ($answer) {
      "^(y|yes)$" { return $true }
      "^(n|no)?$" { return $false }
      default { Write-Line "請輸入 y 或 n。" }
    }
  }
}

function Resolve-ConflictTarget {
  param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath
  )

  if (-not (Test-Path -LiteralPath $TargetPath)) {
    return @{
      Action = "write"
      Path = $TargetPath
    }
  }

  Write-Line "檔案已存在，是否覆寫？"
  if (Read-YesNo "> $TargetPath") {
    return @{
      Action = "overwrite"
      Path = $TargetPath
    }
  }

  while ($true) {
    $choice = Read-Host "若不覆寫，請選擇：提供其他檔名 / 略過 [rename/skip]"
    switch ($choice) {
      "rename" {
        $dirPath = Split-Path -Parent $TargetPath
        $altName = Read-Host "請提供其他檔名（預設保留在 $dirPath\ 下）"
        if ([string]::IsNullOrWhiteSpace($altName)) {
          Write-Line "檔名不可為空。"
          continue
        }
        return @{
          Action = "rename"
          Path = Join-Path $dirPath $altName
        }
      }
      "skip" {
        return @{
          Action = "skip"
          Path = $TargetPath
        }
      }
      default {
        Write-Line "請輸入 rename 或 skip。"
      }
    }
  }
}

function Copy-TemplateWithConflictPolicy {
  param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,
    [Parameter(Mandatory = $true)]
    [string]$TargetPath
  )

  $resolution = Resolve-ConflictTarget -TargetPath $TargetPath
  switch ($resolution.Action) {
    "skip" {
      return "略過: $TargetPath"
    }
    "rename" {
      Ensure-Dir (Split-Path -Parent $resolution.Path)
      Copy-Item -LiteralPath $SourcePath -Destination $resolution.Path -Force
      return "改名: $($resolution.Path)"
    }
    "overwrite" {
      Ensure-Dir (Split-Path -Parent $TargetPath)
      Copy-Item -LiteralPath $SourcePath -Destination $TargetPath -Force
      return "覆寫: $TargetPath"
    }
    "write" {
      Ensure-Dir (Split-Path -Parent $TargetPath)
      Copy-Item -LiteralPath $SourcePath -Destination $TargetPath -Force
      return "建立: $TargetPath"
    }
    default {
      Fail "不支援的衝突處理結果：$($resolution.Action)"
    }
  }
}

function Print-Summary {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Title,
    [Parameter(Mandatory = $true)]
    [string[]]$Items
  )

  Write-Line $Title
  foreach ($item in $Items) {
    Write-Line "- $item"
  }
}
