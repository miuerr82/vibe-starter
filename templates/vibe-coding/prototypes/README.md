# Prototypes README

## 這份文件做什麼

- 用來說明 `vibe-coding/prototypes/` 如何記錄視覺探索、方案比較、驗證結果與決策歷程
- prototype 是視覺決策工作區，不是正式產品程式，也不取代 `ui/design-system.md` 或 `layouts/`
- 當文字規則不足以表達真實畫面行為時，應優先補 prototype，再決定是否進入實作

## Prototype 與 Design Layer 的差異

- `ui/design-system.md`：跨頁 UI 規則、元件限制、互動一致性
- `layouts/`：持久的畫面結構、配置原則、頁型定義
- `prototypes/`：視覺探索、方案比較、實際畫面驗證、決策追蹤

## 使用規則

- prototype 可不完整，重點是快速得到可判斷的視覺與 UX 反饋
- prototype 可刻意忽略 backend，前提是目的在於驗證視覺、資訊密度、互動或流程
- AI 協助生成的 prototype，預設應先放在 `exploring/` 或 `comparing/`
- 未被確認前，prototype 不可直接當成正式實作依據
- `accepted` prototype 應作為畫面實作與防止 design drift 的參考依據
- `deprecated` prototype 不應直接刪除，應保留棄用或被替代原因

## Prototype 狀態

- `exploring`: 早期探索，可快速迭代，不要求完整
- `comparing`: 多個 prototype 方案正在比較
- `accepted`: 已接受，可作為實作參考
- `implemented`: 已落地到真實系統
- `deprecated`: 不再建議使用，僅保留歷史與拒絕原因

## 建議流程

1. 先確認相關技術決策、`ui/design-system.md` 與 `layouts/` 是否已存在
2. 在 `registry.yml` 建立 prototype entry
3. 於對應狀態目錄建立 prototype 資料夾，例如 `exploring/<prototype-id>/`
4. 使用 `_template/` 內的 `prototype.yml`、`README.md`、`decisions.md`、`notes.md` 建立內容
5. 若有多個版本需要比較，將狀態改為 `comparing`
6. 使用者確認後，再將 prototype 標記為 `accepted`
7. 實作完成後，將狀態更新為 `implemented`
8. 若不再採用，將狀態更新為 `deprecated`，並保留原因

## AI 生成指引

- AI 生成 prototype 時，應優先說明這是探索稿、比較稿，還是已接受版本
- AI 應把 prototype 追蹤成明確狀態，避免把實驗稿誤認為正式方向
- 若使用者要求生成畫面但尚未決定方向，AI 應預設建立 `exploring` 或 `comparing` prototype
- 若已有 `accepted` prototype，後續畫面實作應優先比對 accepted 版本

## 範例

```md
- registry: vibe-coding/prototypes/registry.yml
- prototype folder: vibe-coding/prototypes/exploring/dashboard-layout-v1/
- files:
  - prototype.yml
  - README.md
  - decisions.md
  - notes.md
```

## 空白模板

```md
- registry:
- prototype folder:
- files:
  - prototype.yml
  - README.md
  - decisions.md
  - notes.md
```

## 正式資料

- registry file: `vibe-coding/prototypes/registry.yml`
- template directory: `vibe-coding/prototypes/_template/`
- state directories:
  - `vibe-coding/prototypes/exploring/`
  - `vibe-coding/prototypes/comparing/`
  - `vibe-coding/prototypes/accepted/`
  - `vibe-coding/prototypes/implemented/`
  - `vibe-coding/prototypes/deprecated/`
