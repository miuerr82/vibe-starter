Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "lib\common.ps1")

try {
  Ensure-ProjectRoot
  Ensure-Dir $Script:WorkspaceDir

  Append-UniqueLine (Join-Path $Script:WorkspaceDir ".gitignore") "vibe-starter"

  $agentsSummary = Copy-TemplateWithConflictPolicy `
    -SourcePath (Join-Path $Script:StarterRoot "templates\AGENTS.md") `
    -TargetPath (Join-Path $Script:ProjectRoot "AGENTS.md")

  Print-Summary -Title "初始化完成。已處理項目如下。" -Items @(
    "已確認產品專案根目錄"
    "已確保 vibe-coding/.gitignore 忽略 vibe-starter"
    $agentsSummary
  )

  Write-Line "初始化完成。建議下一步執行 generate。"
} catch {
  [Console]::Error.WriteLine($_.Exception.Message)
  exit 1
}
