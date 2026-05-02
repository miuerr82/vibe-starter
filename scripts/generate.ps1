Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "lib\common.ps1")

$FileKeys = @(
  "0_project",
  "glossary",
  "roles",
  "objects",
  "behaviors",
  "flows",
  "boundaries",
  "states",
  "rules",
  "interfaces",
  "decisions",
  "handoff",
  "milestones",
  "milestone_tasks",
  "user_flows"
)

$Aliases = @(
  "project",
  "terms",
  "role",
  "object",
  "behavior",
  "flow",
  "boundary",
  "state",
  "rule",
  "interface",
  "decision",
  "handoff_readme",
  "milestone_index",
  "tasks_readme",
  "steps"
)

$MenuLabels = @(
  "專案入口",
  "術語表",
  "角色",
  "物件",
  "行為",
  "流程",
  "邊界",
  "狀態",
  "規則",
  "介面",
  "決策",
  "交接說明",
  "Milestone 總表",
  "Milestone tasks 說明",
  "步驟流程"
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

function Get-CanonicalKey {
  param([string]$Value)

  switch ($Value) {
    "1" { return "0_project" }
    "0_project" { return "0_project" }
    "project" { return "0_project" }
    "2" { return "glossary" }
    "glossary" { return "glossary" }
    "terms" { return "glossary" }
    "3" { return "roles" }
    "roles" { return "roles" }
    "role" { return "roles" }
    "4" { return "objects" }
    "objects" { return "objects" }
    "object" { return "objects" }
    "5" { return "behaviors" }
    "behaviors" { return "behaviors" }
    "behavior" { return "behaviors" }
    "6" { return "flows" }
    "flows" { return "flows" }
    "flow" { return "flows" }
    "7" { return "boundaries" }
    "boundaries" { return "boundaries" }
    "boundary" { return "boundaries" }
    "8" { return "states" }
    "states" { return "states" }
    "state" { return "states" }
    "9" { return "rules" }
    "rules" { return "rules" }
    "rule" { return "rules" }
    "10" { return "interfaces" }
    "interfaces" { return "interfaces" }
    "interface" { return "interfaces" }
    "11" { return "decisions" }
    "decisions" { return "decisions" }
    "decision" { return "decisions" }
    "12" { return "handoff" }
    "handoff" { return "handoff" }
    "handoff_readme" { return "handoff" }
    "13" { return "milestones" }
    "milestones" { return "milestones" }
    "milestone_index" { return "milestones" }
    "14" { return "milestone_tasks" }
    "milestone_tasks" { return "milestone_tasks" }
    "tasks_readme" { return "milestone_tasks" }
    "15" { return "user_flows" }
    "user_flows" { return "user_flows" }
    "steps" { return "user_flows" }
    default { return $null }
  }
}

function Get-TemplatePath {
  param([string]$Key)

  switch ($Key) {
    "0_project" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\0_project.md") }
    "glossary" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\glossary.md") }
    "roles" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\roles.md") }
    "objects" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\objects.md") }
    "behaviors" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\behaviors.md") }
    "flows" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\flows.md") }
    "boundaries" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\boundaries.md") }
    "states" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\states.md") }
    "rules" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\rules.md") }
    "interfaces" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\interfaces.md") }
    "decisions" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\decisions.md") }
    "handoff" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\handoff\README.md") }
    "milestones" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\milestones\index.md") }
    "milestone_tasks" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\milestones\tasks\README.md") }
    "user_flows" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\specs\user_flows.md") }
    default { Fail "不支援的文件 key：$Key" }
  }
}

function Get-TargetPath {
  param([string]$Key)

  switch ($Key) {
    "0_project" { return (Join-Path $Script:SpecsDir "0_project.md") }
    "glossary" { return (Join-Path $Script:SpecsDir "glossary.md") }
    "roles" { return (Join-Path $Script:SpecsDir "roles.md") }
    "objects" { return (Join-Path $Script:SpecsDir "objects.md") }
    "behaviors" { return (Join-Path $Script:SpecsDir "behaviors.md") }
    "flows" { return (Join-Path $Script:SpecsDir "flows.md") }
    "boundaries" { return (Join-Path $Script:SpecsDir "boundaries.md") }
    "states" { return (Join-Path $Script:SpecsDir "states.md") }
    "rules" { return (Join-Path $Script:SpecsDir "rules.md") }
    "interfaces" { return (Join-Path $Script:SpecsDir "interfaces.md") }
    "decisions" { return (Join-Path $Script:SpecsDir "decisions.md") }
    "handoff" { return (Join-Path $Script:HandoffDir "README.md") }
    "milestones" { return (Join-Path $Script:MilestonesDir "index.md") }
    "milestone_tasks" { return (Join-Path $Script:MilestoneTasksDir "README.md") }
    "user_flows" { return (Join-Path $Script:SpecsDir "user_flows.md") }
    default { Fail "不支援的文件 key：$Key" }
  }
}

function Show-AvailableFiles {
  [Console]::Error.WriteLine("可生成的文件如下：")
  for ($i = 0; $i -lt $FileKeys.Count; $i++) {
    [Console]::Error.WriteLine("- {0}. {1} ({2})，別名：{3}" -f ($i + 1), $FileKeys[$i], $MenuLabels[$i], $Aliases[$i])
  }
}

function Show-AvailableModes {
  [Console]::Error.WriteLine("請選擇要生成的文件：")
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
      return ,$FileKeys
    }
    "single" {
      if ($RemainingArgs.Count -eq 0) {
        Show-AvailableFiles
        return ,(Read-Host "請輸入單一文件編號（也可輸入 key / 別名）")
      }
      return ,@($RemainingArgs[0])
    }
    "multiple" {
      if ($RemainingArgs.Count -eq 0) {
        Show-AvailableFiles
        $line = Read-Host "請輸入多個文件編號，請用空白分隔（也可混用 key / 別名）"
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
      Fail "不支援的生成模式：$Mode"
    }
  }
}

try {
  Ensure-ProjectRoot
  Ensure-Dir $Script:WorkspaceDir
  Ensure-Dir $Script:SpecsDir
  Ensure-Dir $Script:HandoffDir
  Ensure-Dir $Script:MilestonesDir
  Ensure-Dir $Script:MilestoneTasksDir

  $mode = if ($args.Count -gt 0) { [string]$args[0] } else { "" }
  $remainingArgs = if ($args.Count -gt 1) { $args[1..($args.Count - 1)] } else { @() }
  $selectedTargets = Get-RequestedTargets -Mode $mode -RemainingArgs $remainingArgs

  $generatedSummary = @()
  foreach ($requested in $selectedTargets) {
    if ([string]::IsNullOrWhiteSpace($requested)) {
      continue
    }
    $key = Get-CanonicalKey ([string]$requested)
    if ($null -eq $key) {
      Fail "不支援的文件 key / 別名 / 編號：$requested"
    }

    $generatedSummary += Copy-TemplateWithConflictPolicy `
      -SourcePath (Get-TemplatePath $key) `
      -TargetPath (Get-TargetPath $key)
  }

  Print-Summary -Title "生成完成。已建立、覆寫、略過的檔案如下。" -Items $generatedSummary

  if ($generatedSummary | Where-Object { $_ -match "milestones" }) {
    Write-Line "下一步建議：先查看 vibe-coding/milestones/index.md，整理目前 milestone 與工作順序。"
  } elseif ($generatedSummary | Where-Object { $_ -match "user_flows" }) {
    Write-Line "下一步建議：可請 AI 依 user_flows.md 協助補入 behaviors.md 與 flows.md。"
  } else {
    Write-Line "下一步建議：先補 0_project.md、glossary.md、roles.md。"
  }

  Write-Line "目前已有可交接內容，是否要我整理 handoff？"
} catch {
  [Console]::Error.WriteLine($_.Exception.Message)
  exit 1
}
