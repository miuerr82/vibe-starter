# Layouts Index

## 這份文件做什麼

- 用來追蹤此專案已討論、已定義、使用中或需修訂的 layout
- layout 是產品畫面的持久設計參考，後續實作應優先引用 active layout
- 這份文件是 layout 導航入口；單一 layout 細節可放在 `vibe-coding/layouts/<layout-id>.md`

## 使用規則

- layout 定義前，應先確認相關技術決策與 UI contract
- 若使用者需要設計師協助，應先由 UI/UX Designer 提出 UI/UX 規劃
- 若使用者不需要設計師協助，AI 可直接用選項與建議引導 layout 討論
- 已確認的 layout 應記錄為 `defined` 或 `active`
- implementation task 影響畫面時，應引用相關 active layout
- 若實作結果不符合畫面期待，應修訂 layout，而不是只在 task 裡留下零散描述

## Layouts

| layout_id | status | type | title | scope | layout_file | ui_contract_refs | related_features | related_milestones | related_tasks | updated_at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

## UI/UX Assistance Decisions

| decision_scope | selected_mode | designer_required | reason | related_layout_refs | updated_at |
| --- | --- | --- | --- | --- | --- |

## Reference Sources

| ref_id | source | liked_parts | disliked_parts | applied_to_layouts | updated_at |
| --- | --- | --- | --- | --- | --- |

## 範例

### Layouts

| layout_id | status | type | title | scope | layout_file | ui_contract_refs | related_features | related_milestones | related_tasks | updated_at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| LAYOUT-001 | active | overall | 後台整體版型 | 全站後台 | vibe-coding/layouts/LAYOUT-001.md | vibe-coding/ui/design-system.md | - | - | - | 2026-05-10 |
| LAYOUT-002 | defined | list | 後台列表頁 | 資料管理列表 | vibe-coding/layouts/LAYOUT-002.md | vibe-coding/ui/design-system.md | FEAT-001 | MS-001 | TASK-001 | 2026-05-10 |

### UI/UX Assistance Decisions

| decision_scope | selected_mode | designer_required | reason | related_layout_refs | updated_at |
| --- | --- | --- | --- | --- | --- |
| admin screens | designer_requested | yes | 需要先由設計師提出互動與資訊架構建議 | LAYOUT-001 | 2026-05-10 |

## 空白模板

```md
## Layouts

| layout_id | status | type | title | scope | layout_file | ui_contract_refs | related_features | related_milestones | related_tasks | updated_at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

## UI/UX Assistance Decisions

| decision_scope | selected_mode | designer_required | reason | related_layout_refs | updated_at |
| --- | --- | --- | --- | --- | --- |

## Reference Sources

| ref_id | source | liked_parts | disliked_parts | applied_to_layouts | updated_at |
| --- | --- | --- | --- | --- | --- |
```

## 正式資料

### Layout 狀態固定值

- `proposed`
- `discussing`
- `defined`
- `active`
- `revision_needed`
- `deprecated`

### Layout 類型固定值

- `overall`
- `list`
- `detail`
- `form`
- `dashboard`
- `flow`
- `feature_specific`
- `component_guidance`
