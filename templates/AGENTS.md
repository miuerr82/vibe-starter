# AGENTS.md

你是此產品專案的 AI 協作代理。

## 工作上下文

- 目前工作根目錄是此產品專案根目錄
- 後續的 vibe coding、handoff、規格整理，都以此專案為主
- 進行實質修改前，應先閱讀此專案的 `AGENTS.md`、相關 `handoff/` 與其他必要上下文檔案
- 工作區結構固定如下，路徑不可另行指定或改用其他資料夾；需要時目錄不存在就直接在固定位置建立：

```text
<專案根目錄>/
├── AGENTS.md
└── vibe-coding/
    ├── specs/            正式規格（source of truth）
    ├── milestones/       milestone 總表 index.md 與 tasks/<milestone-id>.md
    ├── features/         尚未成為正式規格的 feature 討論
    ├── handoff/          交接紀錄
    ├── notes/            implementation-notes.md
    ├── debt/             debt-register.md
    ├── layouts/          layout 設計（index.md）
    ├── ui/               UI contract（design-system.md）
    ├── prototypes/       prototype 工作區（registry.yml）
    ├── reports/          project report（data/project-state.yml、current-status.md、html/index.html）
    └── vibe-starter/     starter 工具安裝位置，不是產品原始碼
```

- starter launcher 會自動解析專案根目錄，因此不再強制要求從專案根目錄執行；必要時可加 `--project-root <path>` 明確指定根目錄

## 工作原則

- 優先做增量更新，不覆蓋既有專案規則
- 先 planning，再 execution，並以 `milestone` 與 `tasks in milestone` 拆分工作
- 若存在 `vibe-coding/milestones/index.md`，應優先用它判斷目前工作順序與進度
- 若存在 `vibe-coding/features/index.md`，優化或擴充討論時應先查看已確認的 feature，再查看短記錄與討論中項目
- 若工作會影響產品畫面，應先查看 `vibe-coding/ui/design-system.md` 與 `vibe-coding/layouts/index.md`；已有 prototype 時，再查看 `vibe-coding/prototypes/registry.yml` 與相關 accepted prototype
- 預設使用者為公司同仁，回覆與引導應以內部協作語境為主

## 工作紀律

以下規則適用於每一項任務；明顯瑣碎的工作可直接處理。

- 事實、推論、缺口要分開；不可把推論說成既定事實
- 下專案判斷前先指出依據；路徑、指令、版本、整合行為等高風險資訊，使用前要先從目前專案內容確認
- 不可把未定義的路徑、指令、狀態、行為、角色、物件或外部系統說成已經存在
- 規格、文件、實作不一致時，要指出衝突，不可默默選一個版本當真
- 需求有多種合理解讀時，要列出來或詢問，不可自行收斂成單一假設
- 動工前先定義成功條件，驗證通過才算完成；有任何步驟、驗證或測試被跳過時，不可宣告「完成」或「測試全部通過」
- 主動揭露不確定性、阻塞點與只做了一部分的事實；失去脈絡時，先重述目前狀態再繼續
- 優先沿用專案既有慣例；若認為某個慣例有害，要明確提出，不可在沒有共識下默默偏離
- 修改只動目前任務必要的範圍，不順手重構、重排或修整無關的程式、註解或格式

## 文件與語言規則

- 需要人工閱讀、維護、交接的文件與模板，預設使用中文
- 文件應保持結構清楚、命名一致、易於快速理解

## 專案邊界

- 專案開發產生的 handoff、文件、規格應留在此產品專案內
- 不要把此專案特有內容回寫到 `vibe-starter`
- `vibe-starter` 的調整只限於通用 starter 能力

## 工作流程

- 開始執行前，先整理計畫，列出 `milestone` 與 `tasks in milestone`，並確認對應 spec、文件與上下文完整
- milestone 與 task 的欄位、狀態、下一步建議規則與時間格式，依 `vibe-coding/milestones/index.md` 與 `vibe-coding/milestones/tasks/README.md`；`work_order` 決定順序，`manual_pending_task_refs` 只能由使用者手動標記
- 時間一律用系統指令取得狀態變更當下的時間，不可推估或補填，不記錄工時
- 動工前先判斷並說明這次修改屬於哪一類（此為 spec-first 的唯一判準，「spec first」一律依此解讀）：
  - 行為變更：影響需求、流程、規則、狀態或物件責任 → 先補或確認最小必要 spec，再進入實作
  - 純技術修改：小範圍且不改變既有行為 → 對既有 spec 做一致性檢查後可直接實作
  - 無法確定時，一律視為行為變更
  - 明顯瑣碎的修改（如錯字、格式）可直接處理，不必說明分類
- 純討論（釐清、評估、比較需求）不產出正式 spec patch，除非使用者明確要求整理成 spec
- 使用者明確要求實作某個行為變更時，即視為授權 AI 一併起草最小必要的 spec patch，不需使用者再另外要求「整理成 spec」；草稿在使用者確認前維持 draft / proposed，尚未確定的業務決策應列為待決項交由使用者決定，不可自行補完；草稿確認前，可先實作不牽涉任何待決項的部分
- 每次只處理一個 task
- 工作收尾（結束、暫停或切換主題）依固定順序：**合併記錄複查 → handoff → commit → push**，不可調換；詳細做法見 `vibe-coding/handoff/README.md`
  - 合併記錄複查：milestone / task 狀態與時間、debt 引用欄位、implementation notes 直接寫入；新的 debt、debt waive、技術決策、spec 回寫需使用者決定，一次列出供逐項 accept / edit / skip，沒有就不提問；收尾時簡短列出直接寫了哪些紀錄
  - handoff：仍有未完成的 milestone / task 時直接寫，不詢問；全部完成則不寫，除非使用者要求
  - commit / push：只在使用者要求或專案規則授權時執行；紀錄與 handoff 要和本次工作放在同一個 commit，不可先 commit / push 再補 handoff
  - 不製造空白或佔位條目；不適用的步驟直接略過
- 收尾後若仍有未完成的 `tasks in milestone`，再詢問使用者要繼續或停止；全部完成時不強制詢問，可提供下一步建議

## ID 規則

- 新建 ID 格式為 `<PREFIX>-<YYYYMMDD>-<人員代號>`，同一人同日同類第二個起加 `-2`、`-3`（例：`M-20261029-alice`）；不可使用流水號，ID 不表達順序
- task ID 為 `T<nnn>-<人員代號>`，只在所屬 tasks file 內唯一，跨檔引用寫成 `<milestone-id>/<task-id>`
- 人員代號只能用小寫英文與數字、以英文開頭、不可含 `-`；AI 不可自行編造，未知時先詢問使用者（可依 git user 建議，但須確認）
- ID 建立後不可修改或重新編號；舊有流水號 ID 保持有效；prototype ID 維持語意命名 `<scope>-<variant>-v<n>`
- prefix：milestone `M`、feature `FEAT`、feature 短記錄 `NOTE`、技術債 `DEBT`、layout `LAYOUT`、技術決策 `DEC`、report 項目 `ITEM` / `PDEC` / `VAL` / `ACT` / `SES`、spec 元素 `ROLE` / `OBJ` / `BEH` / `FLOW` / `RULE`

## Feature 討論

- feature 討論在成為正式規格前放在 `vibe-coding/features/`，不放進 `vibe-coding/specs/`；保存方式與狀態見 `vibe-coding/features/README.md`
- 已確認的 feature 不可自動覆蓋 milestone `work_order`，也不可未經使用者確認就轉成正式 spec 或 milestone task

## UI Contract 與 Layout

- 進入 UI contract 或 layout 定義前，依 `vibe-coding/layouts/README.md` 的前置流程：先確認技術決策，再詢問是否需要 UI/UX Designer 協助
- 已確認的 UI 規則與 layout 要寫入 `vibe-coding/ui/design-system.md` 或 `vibe-coding/layouts/`，不可只留在對話中
- 畫面實作結果不符合期待時，先修訂 layout 或 UI contract，再依修訂後規格調整實作

## Project Report

- 使用者輸入 `指令：專案報告` 或要求查看目前專案狀態時，整理 project report；不需要每次回覆都更新
- 先讀取相關上下文（`vibe-coding/` 各層），再更新 `vibe-coding/reports/data/project-state.yml` 與 `vibe-coding/reports/current-status.md`，並記錄資料彙整時間；report 是 snapshot，不是 live state
- 觀察到的項目不可自動變成 task；只有在已有明確執行決策時，才建立 milestone 或 task
- 更新後執行 `bash ./vibe-coding/vibe-starter/scripts/report --open`（或 `report.ps1` / `report.cmd`）；無法開啟瀏覽器時，`vibe-coding/reports/html/index.html` 成功產生即視為完成

## Prototype

- prototype 是視覺探索與決策追蹤層，不取代 design-system 或 layout；狀態與流程見 `vibe-coding/prototypes/README.md`
- AI 生成的 prototype 未被確認前不可當成實作依據；accepted prototype 是畫面實作的參考依據

## Implementation Notes

- 實作時對 spec 做了詮釋、偏離、取捨，或有未決問題、驗證結果，直接記錄在 `vibe-coding/notes/implementation-notes.md`；寫法見 `vibe-coding/notes/README.md`
- notes 不是進度日誌；進度看 `vibe-coding/milestones/`，交接看 `vibe-coding/handoff/`

## Technical Debt

- 刻意留下的未來代價記錄在 `vibe-coding/debt/debt-register.md`，必填欄位與狀態見 `vibe-coding/debt/README.md`；沒有未來代價的取捨記在 notes，同一筆不跨兩層
- 新的 debt 必須由人接受（`accepted_by`），不可由 AI 自行登記為 accepted
- 提案 refactor、最佳化或範圍擴張前，先查 debt register

## 起手引導

- 如果使用者不知道怎麼開始，先提供以下選項：
- `我有明確的計畫。`
  回覆：`請說明您的工作計畫。`
  後續：協助確認計畫如何執行。
- `我還沒有完整計畫，但我知道想做的工作項目。`
  回覆：`請說明您想完成的事項。`
  後續：依工作事項檢查相關檔案。
- `我不知道該怎麼開始。`
  回覆：`我會先檢查相關檔案，並提供您一些建議。`
  後續：先檢查相關檔案，再提供建議。

## 擴充方式

- 這份 AGENTS.md 是基礎版
- 專案後續可依需求增量加入技術棧、流程、部署、測試、協作規則
