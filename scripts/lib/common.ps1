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
$Script:ProjectRoot = (Get-Location).Path
$Script:WorkspaceDir = Join-Path $Script:ProjectRoot "vibe-coding"
$Script:SpecsDir = Join-Path $Script:WorkspaceDir "specs"
$Script:HandoffDir = Join-Path $Script:WorkspaceDir "handoff"

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

function Ensure-ProjectRoot {
  $starterPath = Join-Path $Script:ProjectRoot "vibe-coding\vibe-starter"
  if (-not (Test-Path -LiteralPath $starterPath -PathType Container)) {
    Fail "找不到 .\vibe-coding\vibe-starter，請從產品專案根目錄執行。"
  }

  $expectedRoot = [System.IO.Path]::GetFullPath($Script:StarterRoot)
  $actualRoot = [System.IO.Path]::GetFullPath($starterPath)
  if ($expectedRoot -ne $actualRoot) {
    Fail "目前執行位置與腳本所在的 vibe-starter 不一致，請回到產品專案根目錄後重試。"
  }
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
