Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "lib\common.ps1")

$CanonicalRepoUrl = "https://github.com/miuerr82/vibe-starter.git"
$TagsApiUrl = "https://api.github.com/repos/miuerr82/vibe-starter/tags"
$ArchiveBaseUrl = "https://github.com/miuerr82/vibe-starter/archive/refs/tags"

Initialize-Starter -ArgList $args

foreach ($arg in $Script:StarterArgs) {
  switch ($arg) {
    "--help" {
      Write-Line "用法：.\vibe-coding\vibe-starter\scripts\sync.ps1 [--project-root <path>]"
      exit 0
    }
    "-h" {
      Write-Line "用法：.\vibe-coding\vibe-starter\scripts\sync.ps1 [--project-root <path>]"
      exit 0
    }
    default {
      Fail "不支援的 sync 參數：$arg"
    }
  }
}

function Test-CommandExists {
  param([string]$Name)
  return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Test-GitClone {
  if (-not (Test-CommandExists "git")) { return $false }
  & git -C $Script:StarterRoot rev-parse --is-inside-work-tree *> $null
  return ($LASTEXITCODE -eq 0)
}

function Get-CurrentVersion {
  if (Test-GitClone) {
    $v = & git -C $Script:StarterRoot rev-parse --short HEAD 2>$null
    if ($LASTEXITCODE -eq 0) { return $v.Trim() }
  }
  return "unknown"
}

function Get-LatestTag {
  $resp = Invoke-RestMethod -Uri $TagsApiUrl -Headers @{ "User-Agent" = "vibe-starter-sync" }
  if ($resp -and $resp.Count -gt 0) { return $resp[0].name }
  return $null
}

function Sync-ViaGit {
  $before = (& git -C $Script:StarterRoot rev-parse --short HEAD).Trim()

  $status = & git -C $Script:StarterRoot status --porcelain
  if ($status) {
    Fail "starter 工具目錄有本地修改，sync 不會覆寫。請先處理 $($Script:StarterRoot) 的變更後再試。專案內容未變動。"
  }

  & git -C $Script:StarterRoot pull --ff-only origin *> $null
  if ($LASTEXITCODE -ne 0) {
    & git -C $Script:StarterRoot pull --ff-only *> $null
    if ($LASTEXITCODE -ne 0) {
      Fail "git 更新失敗（可能是網路問題或無法 fast-forward）。starter 工具與專案內容皆未變動。"
    }
  }

  $after = (& git -C $Script:StarterRoot rev-parse --short HEAD).Trim()
  return [pscustomobject]@{
    Before  = $before
    After   = $after
    Method  = "git pull --ff-only"
    Changed = ($before -ne $after)
  }
}

function Sync-ViaArchive {
  $tmpRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("vibe-starter-sync-" + [System.Guid]::NewGuid().ToString("N"))
  New-Item -ItemType Directory -Path $tmpRoot | Out-Null
  try {
    $before = Get-CurrentVersion
    $tag = Get-LatestTag
    if (-not $tag) { Fail "無法判斷最新版本標籤（tags API 取得失敗）。專案內容未變動。" }

    $tarball = Join-Path $tmpRoot "starter.tar.gz"
    Invoke-WebRequest -Uri "$ArchiveBaseUrl/$tag.tar.gz" -OutFile $tarball -Headers @{ "User-Agent" = "vibe-starter-sync" }

    & tar -xzf $tarball -C $tmpRoot
    if ($LASTEXITCODE -ne 0) { Fail "解壓版本 $tag 失敗（需要 tar）。專案內容未變動。" }

    $extracted = Get-ChildItem -Path $tmpRoot -Directory | Where-Object { $_.Name -like "vibe-starter-*" } | Select-Object -First 1
    if (-not $extracted) { Fail "解壓內容結構不符預期。專案內容未變動。" }

    # refresh ONLY the starter tool directory; never touch anything outside StarterRoot
    Copy-Item -Path (Join-Path $extracted.FullName "*") -Destination $Script:StarterRoot -Recurse -Force

    return [pscustomobject]@{
      Before  = $before
      After   = $tag
      Method  = "archive download ($tag)"
      Changed = $true
    }
  }
  finally {
    Remove-Item -Path $tmpRoot -Recurse -Force -ErrorAction SilentlyContinue
  }
}

if (Test-GitClone) {
  $result = Sync-ViaGit
}
else {
  $result = Sync-ViaArchive
}

if ($result.Changed) {
  Print-Summary -Title "同步完成。starter 工具已更新，專案內容未變動。" -Items @(
    "更新方式: $($result.Method)",
    "原版本: $($result.Before)",
    "新版本: $($result.After)",
    "工具位置: $($Script:StarterRoot)"
  )
  Write-Line "下一步建議：可執行 generate 檢視是否有新增的模板檔（不會自動覆寫既有內容）。"
}
else {
  Write-Line "starter 工具已是最新版，無需更新。"
  Write-Line "目前版本: $($result.After)（$($result.Method)）"
}
