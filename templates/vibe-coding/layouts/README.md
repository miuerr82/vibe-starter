# Layouts README

## 這份文件做什麼

- 用來說明 `vibe-coding/layouts/` 如何記錄產品畫面結構、配置原則、視覺方向與互動指引
- layout 是可持續引用的設計規格，不是一次性的 task note
- layout 可以由 feature、milestone 或 task 觸發，但不必固定隸屬於 milestone
- 若畫面實作結果不符合期待，應回來修正 layout 定義，再依定義調整實作

## 使用時機

- 產品畫面一開始不符合預期，需要先固化畫面方向
- feature 需要新的頁面、流程、列表、詳情、表單或 dashboard
- 需要定義 overall、list、detail、form、dashboard、flow 或 feature-specific layout
- 需要固化特定 component 的使用方式、配置原則或畫面行為

## Layout 前置流程

1. 先確認是否已有技術決策
   - 例如：Laravel、Vue 3、Inertia.js、Element Plus、Tailwind CSS
   - 技術決策應記錄在 `vibe-coding/specs/decisions.md`
2. 再詢問是否需要 UI/UX Designer 協助
   - 需要：由 UI/UX Designer 先提出 UI/UX 規劃，再由使用者確認
   - 不需要：由 AI 直接和使用者討論 layout、互動、視覺與元件細節
3. 確認跨頁 UI 規則
   - 記錄在 `vibe-coding/ui/design-system.md`
4. 最後固化 layout
   - 更新 `vibe-coding/layouts/index.md`
   - 必要時建立 `vibe-coding/layouts/<layout-id>.md`

## 不知道怎麼規劃時

- 請先找 1 到 3 個喜歡的網站、後台系統、SaaS 產品、截圖或 UI 範例
- 回填參考 URL 或圖片位置
- 說明喜歡哪些部分：
  - 畫面結構
  - 資訊密度
  - 導航方式
  - 色系方向
  - 表格或列表行為
  - 表單樣式
  - 元件感覺
- 說明不想採用哪些部分
- AI 應將偏好轉成此專案自己的 layout 規則，不直接照抄參考網站

### 可直接請 AI 協助的 Prompt

> 我不確定這個 layout 該怎麼規劃。請先用設計師角度給我 2 到 3 個方案，說明各自適合的情境、優缺點，並建議一個最適合目前技術棧和產品類型的方案。

## Layout 類型

- `overall`: 全站或全產品畫面原則
- `list`: 列表頁或集合視圖
- `detail`: 詳情頁
- `form`: 表單或編輯頁
- `dashboard`: 儀表板或總覽頁
- `flow`: 多步驟流程畫面
- `feature_specific`: 因 feature 需要新增的專用 layout
- `component_guidance`: 需要固化的 component 使用或樣式原則

## Layout 狀態

- `proposed`: 剛提出，尚未整理
- `discussing`: 正在討論
- `defined`: 已固化，可以被實作引用
- `active`: 目前專案採用中的 layout
- `revision_needed`: 實作或使用後發現需要調整
- `deprecated`: 不再建議使用

## 範例

```md
# LAYOUT-001 後台列表頁

## 狀態

- status: active
- type: list
- updated_at: 2026-05-10

## Scope

- applies_to: 後台資料管理列表
- related_features: -
- related_milestones: -
- related_tasks: -
- ui_contract_refs: vibe-coding/ui/design-system.md

## Screen Principles

- 使用 table-first 結構
- 搜尋、篩選與主要操作放在列表上方
- 重要狀態欄位需可快速掃描
- 批次操作只在選取資料後顯示

## Structure

- header: 標題、主要新增按鈕
- primary_area: 搜尋列、篩選器、資料表格
- secondary_area: 分頁、批次操作
- empty_state: 顯示建立第一筆資料的動作
- loading_state: 使用表格骨架或 loading 狀態
- error_state: 顯示可重試的錯誤提示

## Visual Direction

- tone: restrained admin
- density: standard compact
- color_guidance: 依 design-system.md
- component_guidance: 優先使用既定 UI library 的 table、pagination、button、tag

## Constraints

- 不使用過大的 marketing card 版型
- 不讓次要統計資訊壓過主要資料表格
```

## 空白模板

```md
# <layout-id> <title>

## 狀態

- status:
- type:
- updated_at:

## Purpose

-

## Scope

- applies_to:
- related_features:
- related_milestones:
- related_tasks:
- technical_decision_refs:
- ui_contract_refs:

## Reference Sources

- url_or_image:
- liked_parts:
- disliked_parts:
- applied_to:

## Screen Principles

-

## Structure

- header:
- primary_area:
- secondary_area:
- navigation:
- actions:
- empty_state:
- loading_state:
- error_state:

## Visual Direction

- tone:
- density:
- color_guidance:
- typography_guidance:
- spacing_guidance:
- component_guidance:

## Interaction Guidance

-

## Responsive Guidance

-

## Constraints

-

## Open Questions

-

## Decision Notes

-
```

## 正式資料

### 建議流程

- 先確認 `vibe-coding/specs/decisions.md` 是否已有相關技術決策
- 再確認是否需要 UI/UX Designer 協助
- 先補或確認 `vibe-coding/ui/design-system.md`
- 更新 `vibe-coding/layouts/index.md`
- 需要固化單一畫面模式時，建立 `vibe-coding/layouts/<layout-id>.md`
