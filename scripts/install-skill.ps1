Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "lib\common.ps1")

$Script:ClaudeDir = Join-Path $Script:ProjectRoot ".claude"
$Script:ClaudeSkillsDir = Join-Path $Script:ClaudeDir "skills"

$SkillKeys = @(
  "spec-driven-consultant",
  "vibe-uiux-designer",
  "vibe-project-manager"
)

$Aliases = @(
  "spec",
  "uiux",
  "pm"
)

$MenuLabels = @(
  "Spec-driven 需求顧問",
  "UI/UX Designer",
  "Project Manager"
)

function Get-CanonicalMode {
  param([string]$Value)

  switch ($Value) {
    "1" { return "single" }
    "single" { return "single" }
    "2" { return "multiple" }
    "multiple" { return "multiple" }
    "3" { return "all" }
    "all" { return "all" }
    default { return $null }
  }
}

function Get-CanonicalSkill {
  param([string]$Value)

  switch ($Value) {
    "1" { return "spec-driven-consultant" }
    "spec-driven-consultant" { return "spec-driven-consultant" }
    "spec" { return "spec-driven-consultant" }
    "2" { return "vibe-uiux-designer" }
    "vibe-uiux-designer" { return "vibe-uiux-designer" }
    "uiux" { return "vibe-uiux-designer" }
    "3" { return "vibe-project-manager" }
    "vibe-project-manager" { return "vibe-project-manager" }
    "pm" { return "vibe-project-manager" }
    default { return $null }
  }
}

function Get-TemplateDir {
  param([string]$Skill)

  return (Join-Path $Script:StarterRoot "templates\claude\skills\$Skill")
}

function Get-TargetDir {
  param([string]$Skill)

  return (Join-Path $Script:ClaudeSkillsDir $Skill)
}

function Show-AvailableSkills {
  [Console]::Error.WriteLine("可安裝的 Claude skills 如下：")
  for ($i = 0; $i -lt $SkillKeys.Count; $i++) {
    [Console]::Error.WriteLine("- {0}. {1} ({2})，別名：{3}" -f ($i + 1), $SkillKeys[$i], $MenuLabels[$i], $Aliases[$i])
  }
}

function Show-AvailableModes {
  [Console]::Error.WriteLine("請選擇要安裝的 Claude skills：")
  [Console]::Error.WriteLine("- 1. 單一")
  [Console]::Error.WriteLine("- 2. 多個")
  [Console]::Error.WriteLine("- 3. 全部")
}

function Get-RequestedTargets {
  param(
    [string]$Mode,
    [string[]]$RemainingArgs
  )

  $canonicalMode = $null
  if (-not [string]::IsNullOrWhiteSpace($Mode)) {
    $canonicalMode = Get-CanonicalMode $Mode
    if ($null -eq $canonicalMode) {
      $canonicalMode = $Mode
    }
  }

  switch ($canonicalMode) {
    "all" {
      return ,$SkillKeys
    }
    "single" {
      if ($RemainingArgs.Count -eq 0) {
        Show-AvailableSkills
        return ,(Read-Host "請輸入單一 skill 編號（也可輸入 key / 別名）")
      }
      return ,@($RemainingArgs[0])
    }
    "multiple" {
      if ($RemainingArgs.Count -eq 0) {
        Show-AvailableSkills
        $line = Read-Host "請輸入多個 skill 編號，請用空白分隔（也可混用 key / 別名）"
        if ([string]::IsNullOrWhiteSpace($line)) {
          return @()
        }
        return @($line -split "\s+")
      }
      return ,$RemainingArgs
    }
    "" {
      Show-AvailableModes
      return Get-RequestedTargets -Mode (Read-Host "請輸入模式編號 [1/2/3]") -RemainingArgs @()
    }
    $null {
      Show-AvailableModes
      return Get-RequestedTargets -Mode (Read-Host "請輸入模式編號 [1/2/3]") -RemainingArgs @()
    }
    default {
      Fail "不支援的 skill 安裝模式：$Mode"
    }
  }
}

function Test-DirectoryName {
  param([string]$Name)

  if ([string]::IsNullOrWhiteSpace($Name)) {
    return $false
  }
  if ($Name.Contains("/") -or $Name.Contains("\")) {
    return $false
  }
  if ($Name -eq "." -or $Name -eq "..") {
    return $false
  }
  return $true
}

function Copy-SkillTemplate {
  param(
    [Parameter(Mandatory = $true)]
    [string]$SourceDir,
    [Parameter(Mandatory = $true)]
    [string]$TargetDir
  )

  Ensure-Dir $TargetDir
  Get-ChildItem -LiteralPath $SourceDir -Force | Where-Object { $_.Name -ne ".gitkeep" } | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $TargetDir -Recurse -Force
  }
}

function Install-SkillTemplate {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RequestedSkill
  )

  $skill = Get-CanonicalSkill $RequestedSkill
  if ($null -eq $skill) {
    Fail "不支援的 skill key / 別名 / 編號：$RequestedSkill"
  }

  $sourceDir = Get-TemplateDir $skill
  $targetDir = Get-TargetDir $skill
  if (-not (Test-Path -LiteralPath (Join-Path $sourceDir "SKILL.md") -PathType Leaf)) {
    Fail "找不到 skill template：$(Join-Path $sourceDir "SKILL.md")"
  }

  if (Test-Path -LiteralPath $targetDir) {
    Write-Line "Skill 目錄已存在，是否覆寫？"
    if (Read-YesNo "> $targetDir") {
      Copy-SkillTemplate -SourceDir $sourceDir -TargetDir $targetDir
      return "覆寫: $targetDir"
    }

    while ($true) {
      $choice = Read-Host "若不覆寫，請選擇：提供其他目錄名 / 略過 [rename/skip]"
      switch ($choice) {
        "rename" {
          $altName = Read-Host "請提供其他 skill 目錄名（預設保留在 $Script:ClaudeSkillsDir\ 下）"
          if (-not (Test-DirectoryName $altName)) {
            Write-Line "目錄名不可為空，且不可包含 / 或 \。"
            continue
          }
          $altDir = Join-Path $Script:ClaudeSkillsDir $altName
          if (Test-Path -LiteralPath $altDir) {
            Write-Line "目錄已存在：$altDir"
            continue
          }
          Copy-SkillTemplate -SourceDir $sourceDir -TargetDir $altDir
          return "改名: $altDir"
        }
        "skip" {
          return "略過: $targetDir"
        }
        default {
          Write-Line "請輸入 rename 或 skip。"
        }
      }
    }
  }

  Copy-SkillTemplate -SourceDir $sourceDir -TargetDir $targetDir
  return "建立: $targetDir"
}

try {
  Ensure-ProjectRoot
  Ensure-Dir $Script:ClaudeDir
  Ensure-Dir $Script:ClaudeSkillsDir

  $mode = if ($args.Count -gt 0) { [string]$args[0] } else { "" }
  $remainingArgs = if ($args.Count -gt 1) { $args[1..($args.Count - 1)] } else { @() }
  $selectedTargets = Get-RequestedTargets -Mode $mode -RemainingArgs $remainingArgs

  $installSummary = @()
  foreach ($requested in $selectedTargets) {
    if ([string]::IsNullOrWhiteSpace($requested)) {
      continue
    }
    $installSummary += Install-SkillTemplate -RequestedSkill ([string]$requested)
  }

  Print-Summary -Title "Claude skills 安裝完成。已建立、覆寫、略過的項目如下。" -Items $installSummary
  Write-Line "安裝位置：.claude/skills/"
} catch {
  [Console]::Error.WriteLine($_.Exception.Message)
  exit 1
}
