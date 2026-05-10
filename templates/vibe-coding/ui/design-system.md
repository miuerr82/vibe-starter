# Design System

## 這份文件做什麼

- 用來記錄此專案跨頁共用的 UI contract
- UI contract 先決定元件、視覺、互動、狀態與文案規則，再讓各 layout 依規則延伸
- 如果專案已有技術棧或 UI library，這份文件應說明如何使用與限制它

## 前置確認

- 技術決策來源：`vibe-coding/specs/decisions.md`
- UI/UX assistance mode:
  - `designer_requested`: 由 UI/UX Designer 先提出規劃
  - `direct_ai_discussion`: AI 直接和使用者討論畫面與互動細節
- 相關 layout 入口：`vibe-coding/layouts/index.md`

## 不知道怎麼開始時

- 先確認產品類型：
  - 後台管理系統
  - SaaS 工作台
  - 內容型網站
  - 資料分析 dashboard
  - 消費者產品
- 再確認技術限制：
  - backend framework
  - frontend framework
  - UI library
  - CSS framework
  - 是否有既有品牌色或設計素材
- 若沒有偏好，AI 應提出 2 到 3 組可選 UI contract 方案，並建議一組保守預設

### 可直接請 AI 協助的 Prompt

> 請根據我的技術棧、產品類型與參考網站，先用 UI/UX Designer 角色提出 UI contract。請包含資訊密度、色系方向、元件使用規則、互動方式、空狀態、loading、error，以及哪些設計方向不要採用。

## 範例

```md
## UI Contract

- status: accepted
- assistance_mode: designer_requested
- technical_decision_refs: vibe-coding/specs/decisions.md#application-stack
- updated_at: 2026-05-10

## Visual Direction

- product_type: 後台管理系統
- tone: restrained admin
- density: standard compact
- color_direction: 中性色底、單一主色作為操作提示、狀態色只用於語意狀態
- typography: 使用 UI library 預設字級，避免 hero-scale 字體
- spacing: 以緊湊但可掃描為原則

## Component Rules

- buttons: 主要動作每個區塊最多一個 primary button
- tables: list page 優先使用 table，狀態欄位使用 tag
- forms: 欄位少用 single-column，欄位多用 two-column 或 step form
- modals: 僅用於短操作或確認，不承載複雜流程
- navigation: 後台預設使用 sidebar，加上必要 breadcrumb

## Interaction Rules

- save_success: 顯示 toast 或 message
- validation_error: 欄位旁顯示錯誤，頁面頂部可補摘要
- delete_action: 需要 confirm
- list_filtering: 搜尋與篩選放在列表上方
- detail_navigation: 從 list 進入 detail 後保留返回列表方式

## State Presentation

- empty_state: 說明目前沒有資料，並提供建立第一筆資料的動作
- loading_state: 使用 skeleton 或 UI library loading
- error_state: 說明錯誤並提供重試動作

## Content Tone

- language: 中文優先
- button_copy: 使用動詞開頭
- error_copy: 說明原因與下一步
```

## 空白模板

```md
## UI Contract

- status:
- assistance_mode:
- technical_decision_refs:
- updated_at:

## Technical Stack Constraints

- programming_language:
- backend_framework:
- frontend_framework:
- ui_library:
- integration_style:
- css_framework:
- constraints:

## Reference Style Sources

- source:
- liked_parts:
- disliked_parts:
- applied_rules:

## Visual Direction

- product_type:
- tone:
- density:
- color_direction:
- typography:
- spacing:
- radius:
- shadow:

## Design Tokens

- primary_color:
- secondary_color:
- semantic_colors:
- background_colors:
- border_colors:
- text_colors:
- spacing_scale:
- border_radius:

## Component Rules

- buttons:
- tables:
- forms:
- modals:
- drawers:
- tabs:
- sidebar:
- breadcrumb:
- tags:
- cards:

## Interaction Rules

- save_success:
- validation_error:
- delete_action:
- list_filtering:
- sorting:
- pagination:
- detail_navigation:
- bulk_actions:

## State Presentation

- empty_state:
- loading_state:
- error_state:
- disabled_state:
- permission_denied_state:

## Information Architecture

- navigation_groups:
- sidebar_rules:
- breadcrumb_rules:
- page_title_rules:
- action_placement:

## Content Tone

- language:
- button_copy:
- empty_state_copy:
- error_copy:
- helper_text:

## Constraints

-

## Open Questions

-
```

## 正式資料

### UI Contract 狀態固定值

- `proposed`
- `reviewing`
- `accepted`
- `revision_needed`

### Assistance Mode 固定值

- `designer_requested`
- `direct_ai_discussion`
