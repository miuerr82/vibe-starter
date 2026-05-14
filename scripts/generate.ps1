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
  "features",
  "feature_index",
  "layouts",
  "layout_index",
  "ui_design_system",
  "prototypes",
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
  "feature_readme",
  "features_index",
  "layout_readme",
  "layouts_index",
  "design_system",
  "prototype_layer",
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
  "Feature 討論說明",
  "Feature 討論索引",
  "Layout 設計說明",
  "Layout 索引",
  "UI Design System",
  "Prototype 層",
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
    "15" { return "features" }
    "features" { return "features" }
    "feature_readme" { return "features" }
    "16" { return "feature_index" }
    "feature_index" { return "feature_index" }
    "features_index" { return "feature_index" }
    "17" { return "layouts" }
    "layouts" { return "layouts" }
    "layout_readme" { return "layouts" }
    "18" { return "layout_index" }
    "layout_index" { return "layout_index" }
    "layouts_index" { return "layout_index" }
    "19" { return "ui_design_system" }
    "ui_design_system" { return "ui_design_system" }
    "design_system" { return "ui_design_system" }
    "20" { return "prototypes" }
    "prototypes" { return "prototypes" }
    "prototype_layer" { return "prototypes" }
    "21" { return "user_flows" }
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
    "features" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\features\README.md") }
    "feature_index" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\features\index.md") }
    "layouts" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\layouts\README.md") }
    "layout_index" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\layouts\index.md") }
    "ui_design_system" { return (Join-Path $Script:StarterRoot "templates\vibe-coding\ui\design-system.md") }
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
    "features" { return (Join-Path $Script:FeaturesDir "README.md") }
    "feature_index" { return (Join-Path $Script:FeaturesDir "index.md") }
    "layouts" { return (Join-Path $Script:LayoutsDir "README.md") }
    "layout_index" { return (Join-Path $Script:LayoutsDir "index.md") }
    "ui_design_system" { return (Join-Path $Script:UiDir "design-system.md") }
    "user_flows" { return (Join-Path $Script:SpecsDir "user_flows.md") }
    default { Fail "不支援的文件 key：$Key" }
  }
}

function New-PrototypeWorkspaceOutputs {
  $files = @(
    @{
      Source = Join-Path $Script:StarterRoot "templates\vibe-coding\prototypes\README.md"
      Target = Join-Path $Script:PrototypesDir "README.md"
    },
    @{
      Source = Join-Path $Script:StarterRoot "templates\vibe-coding\prototypes\registry.yml"
      Target = Join-Path $Script:PrototypesDir "registry.yml"
    },
    @{
      Source = Join-Path $Script:StarterRoot "templates\vibe-coding\prototypes\_template\prototype.yml"
      Target = Join-Path $Script:PrototypesDir "_template\prototype.yml"
    },
    @{
      Source = Join-Path $Script:StarterRoot "templates\vibe-coding\prototypes\_template\README.md"
      Target = Join-Path $Script:PrototypesDir "_template\README.md"
    },
    @{
      Source = Join-Path $Script:StarterRoot "templates\vibe-coding\prototypes\_template\decisions.md"
      Target = Join-Path $Script:PrototypesDir "_template\decisions.md"
    },
    @{
      Source = Join-Path $Script:StarterRoot "templates\vibe-coding\prototypes\_template\notes.md"
      Target = Join-Path $Script:PrototypesDir "_template\notes.md"
    }
  )

  Ensure-Dir $Script:PrototypesDir
  Ensure-Dir (Join-Path $Script:PrototypesDir "_template")
  Ensure-Dir (Join-Path $Script:PrototypesDir "exploring")
  Ensure-Dir (Join-Path $Script:PrototypesDir "comparing")
  Ensure-Dir (Join-Path $Script:PrototypesDir "accepted")
  Ensure-Dir (Join-Path $Script:PrototypesDir "implemented")
  Ensure-Dir (Join-Path $Script:PrototypesDir "deprecated")

  $summaries = @()
  foreach ($file in $files) {
    $summaries += Copy-TemplateWithConflictPolicy -SourcePath $file.Source -TargetPath $file.Target
  }

  return $summaries
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
  Ensure-Dir $Script:FeaturesDir
  Ensure-Dir $Script:LayoutsDir
  Ensure-Dir $Script:UiDir
  Ensure-Dir $Script:PrototypesDir
  Ensure-Dir (Join-Path $Script:PrototypesDir "_template")
  Ensure-Dir (Join-Path $Script:PrototypesDir "exploring")
  Ensure-Dir (Join-Path $Script:PrototypesDir "comparing")
  Ensure-Dir (Join-Path $Script:PrototypesDir "accepted")
  Ensure-Dir (Join-Path $Script:PrototypesDir "implemented")
  Ensure-Dir (Join-Path $Script:PrototypesDir "deprecated")

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

    if ($key -eq "prototypes") {
      $generatedSummary += New-PrototypeWorkspaceOutputs
      continue
    }

    $generatedSummary += Copy-TemplateWithConflictPolicy `
      -SourcePath (Get-TemplatePath $key) `
      -TargetPath (Get-TargetPath $key)
  }

  Print-Summary -Title "生成完成。已建立、覆寫、略過的檔案如下。" -Items $generatedSummary

  if ($generatedSummary | Where-Object { $_ -match "features" }) {
    Write-Line "下一步建議：可查看 vibe-coding/features/index.md，整理已討論、已確認或待保留的 feature。"
  } elseif ($generatedSummary | Where-Object { $_ -match "prototypes" }) {
    Write-Line "下一步建議：先查看 vibe-coding/prototypes/README.md 與 registry.yml，建立 exploring prototype，並在接受前明確區分 experimental 與 accepted。"
  } elseif ($generatedSummary | Where-Object { $_ -match "layouts|design-system" }) {
    Write-Line "下一步建議：先確認技術決策與是否需要 UI/UX Designer 協助，再整理 vibe-coding/ui/design-system.md 與 vibe-coding/layouts/index.md。"
  } elseif ($generatedSummary | Where-Object { $_ -match "milestones" }) {
    Write-Line "下一步建議：先查看 vibe-coding/milestones/index.md，整理目前 milestone 與工作順序。"
  } elseif ($generatedSummary | Where-Object { $_ -match "user_flows" }) {
    Write-Line "下一步建議：可請 AI 依 user_flows.md 協助補入 behaviors.md 與 flows.md。"
  } else {
    Write-Line "下一步建議：可以先從討論專案目標開始，逐步讓AI助理協助進行您的專案工作。"
  }

  Write-Line "若使用 Claude，可執行 install-skill 安裝 project-level skills。"
} catch {
  [Console]::Error.WriteLine($_.Exception.Message)
  exit 1
}
