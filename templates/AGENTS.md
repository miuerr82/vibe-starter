# AGENTS.md

你是此產品專案的 AI 協作代理。

## 工作上下文

- 目前工作根目錄是此產品專案根目錄
- 後續的 vibe coding、handoff、規格整理，都以此專案為主
- `vibe-coding/vibe-starter` 是初始化與輔助工具目錄，不是產品原始碼主體
- 進行實質修改前，應先閱讀此專案的 `AGENTS.md`、相關 `handoff/` 與其他必要上下文檔案
- 若 `AGENTS.md` 已明確定義 spec 或 handoff 路徑，應優先依該明確定義執行
- 若 `AGENTS.md` 未明確定義 spec 或 handoff 路徑，應先從專案內的 `vibe-coding/` 尋找相關目錄
- 若找不到 `vibe-coding/`，可再搜尋其他 vibe-coding 相關目錄；若仍找不到，才建立新的 `vibe-coding/`
- 若實際使用了 fallback 找到的路徑，應主動建議更新 `AGENTS.md`，把 spec 與 handoff 路徑寫明
- 預設 milestone 總表路徑為 `vibe-coding/milestones/index.md`
- 預設 milestone tasks 目錄為 `vibe-coding/milestones/tasks/`
- 預設 feature 討論目錄為 `vibe-coding/features/`
- 預設 layout 設計目錄為 `vibe-coding/layouts/`
- 預設 UI contract 檔案為 `vibe-coding/ui/design-system.md`
- 預設 prototype 工作目錄為 `vibe-coding/prototypes/`
- 預設 project report source 為 `vibe-coding/reports/data/project-state.yml` 與 `vibe-coding/reports/current-status.md`
- 預設 project report dashboard 為 `vibe-coding/reports/html/index.html`
- 預設 implementation notes 檔案為 `vibe-coding/notes/implementation-notes.md`
- starter launcher 會自動解析專案根目錄，因此不再強制要求從專案根目錄執行；必要時可加 `--project-root <path>` 明確指定根目錄

## 工作原則

- Spec first，implementation second
- 未定義需求不要直接實作
- 優先做增量更新，不覆蓋既有專案規則
- 若發現規格、文件、實作不一致，應先指出並補齊規格
- 事實、推論、缺口要分開；不可自行腦補成既定事實
- 下專案判斷前，先指出依據；路徑、指令、版本、整合行為等高風險資訊要先確認
- 先 planning，再 execution，並以 `milestone` 與 `tasks in milestone` 拆分工作
- 若存在 `vibe-coding/milestones/index.md`，應優先用它判斷目前工作順序與進度
- 若存在 `vibe-coding/features/index.md`，優化或擴充討論時應先查看已確認的 feature，再查看短記錄與討論中項目
- 若工作會影響產品畫面，應先查看 `vibe-coding/ui/design-system.md` 與 `vibe-coding/layouts/index.md`
- 若工作會影響產品畫面且已有 prototype，應再查看 `vibe-coding/prototypes/registry.yml` 與相關 accepted prototype
- 預設使用者為公司同仁，回覆與引導應以內部協作語境為主

## 工作紀律

- 工作紀律規則適用於專案中每一項任務，除非該任務本身明顯為瑣碎可直接處理；對非瑣碎工作應傾向謹慎而非求快
- 動工前要明確說出假設；若還有不確定，應主動詢問，不可用猜測填補
- 若需求有多種合理解讀，應同時列出各種解讀，不要自行收斂成單一假設
- 若有更簡單的做法，應主動提出並推回原方案，不要逕自選擇複雜路線
- 若任務本身產生困惑，應停下來指出不清楚的點，先解決再繼續
- 程式碼只寫足以解決目前問題的最小範圍，不加猜測性的功能或泛化
- 一次性使用的程式碼不要事先做抽象
- 在收尾前可自問「資深工程師會不會覺得這寫得太複雜」，若會就先簡化
- 變更應為外科式修改，只動目前任務必要的位置
- 不要順手重排、重構或「順便修整」與本任務無關的相鄰程式碼、註解或格式
- 沿用目標檔案或模組現有的程式碼風格，不要把個人偏好強加上去
- 任務開始時應先定義成功條件，然後對著成功條件迭代直到驗證通過
- 不可用固定步驟清單代替已驗證的成功條件
- 應把 AI 判斷力留給分類、草稿撰寫、摘要、資訊抽取這類任務
- 不可用 AI 判斷力處理確定性轉換、路由決策或重試邏輯；這類事用程式碼處理
- 每個任務預設 token 預算為 4,000，每個 session 預設預算為 30,000；若專案需要不同數值，請在本 `AGENTS.md` 內覆寫
- 接近 token 預算時，應先整理目前狀態、明示已逼近預算，再開啟新的工作上下文，不可悄悄超支
- 若兩個既有 pattern 互相矛盾，要明確擇一（優先較新或較多測試覆蓋的那個），說明理由，並把另一個標記為後續清理項
- 不可把互相矛盾的 pattern 折中混用
- 動既有模組相關程式碼前，先讀對應 exports、直接 callers 與共用 utilities，掌握目前行為
- 不可在沒有確認的情況下假設某段程式碼「與本任務無關」；若不清楚某段結構為何如此，必須先詢問
- 新寫或修改的測試要把「為何此行為重要」也編碼進去，不只是「做了什麼」
- 不可建立對業務邏輯變更不敏感、永遠會通過的測試
- 每完成一個重要步驟，應產出一段簡短檢查點摘要：完成了什麼、已驗證什麼、還剩什麼
- 不可從一個自己無法清楚陳述的狀態繼續工作；一旦失去脈絡，應停下來重述目前狀態再繼續
- 在目標專案內，應優先沿用既有專案慣例，即使個人覺得換種設計更好
- 若真的認為某個慣例有害，應明確向使用者提出，不可在沒有共識的情況下默默偏離
- 任務中若有任何步驟、驗證或測試被跳過，不可宣告「完成」
- 任何測試被 skip 時，不可宣告「測試全部通過」
- 預設應主動揭露不確定性、阻塞點與只做了一部分的事實，不可把它們藏起來

## 文件與語言規則

- 需要人工閱讀、維護、交接的文件與模板，預設使用中文
- 文件應保持結構清楚、命名一致、易於快速理解

## 專案邊界

- 專案開發產生的 handoff、文件、規格應留在此產品專案內
- 不要把此專案特有內容回寫到 `vibe-starter`
- `vibe-starter` 的調整只限於通用 starter 能力

## 工作流程

- 開始執行前，先整理計畫，列出 `milestone` 與 `tasks in milestone`，並確認對應 spec、文件與上下文完整
- milestone 應記錄在 `vibe-coding/milestones/index.md`；每個 milestone 的 task 詳細內容應記錄在 `vibe-coding/milestones/tasks/<milestone-id>.md`
- milestone 總表應使用固定欄位順序：`milestone_id`, `work_order`, `priority`, `status`, `ignored`, `title`, `task_status_summary`, `manual_pending_task_refs`, `started_at`, `completed_at`, `actual_duration`, `elapsed_calendar_duration`, `tasks_file_path`
- `work_order` 是明確工作順序；`priority` 是選填重要性提示，不可覆蓋 `work_order`
- `ignored` 或 `blocked` 的 milestone 不應被建議為下一步，除非使用者明確要求查看
- `manual_pending_task_refs` 只記錄使用者手動 pending 的商業決策項，不可由 AI 自動推導
- `actual_duration` 使用 `00h:00m`；`elapsed_calendar_duration` 以天為單位並保留小數點兩位
- 若是舊專案，先判斷這次修改是否只屬於純技術性、小範圍且不改行為的調整
- 若會影響行為、流程、規則、狀態或物件責任，先補最小必要 spec，再進入實作
- 每次只處理一個 task
- 每段工作階段完成後，若已完成或暫停 1 個以上 milestone 或 task，應詢問使用者是否要整理 handoff
- 使用者第一次要求 `記錄進度`、`記錄交接進度` 或等價要求時，應先解析 handoff 位置；若 `AGENTS.md` 沒有明確定義，先找 `vibe-coding/handoff/`，不可先自行發明其他資料夾
- 若使用者同意記錄 handoff，應整理完成內容、目前狀態、下一步與風險後寫入 handoff
- `handoff` 記錄完成後，若仍有未完成的 `tasks in milestone`，再詢問使用者要繼續或停止
- 使用者的繼續或停止，是 `handoff` 之後的下一步決策，不是記錄 `handoff` 的前提
- 若沒有作用中的 `milestone`，或 `tasks in milestone` 已全部完成，則不強制詢問是否繼續；若有合理下一步，可提供建議，但仍保留停止選項

## Feature 討論

- feature 討論不直接放進 `vibe-coding/specs/`；未成為正式規格前，應放在 `vibe-coding/features/`
- 當使用者提出 feature 方向並討論到可暫存點時，AI 應詢問是否保留完整 feature 討論
- 可暫存點包含：已提出方向、已辨識問題或使用者意圖、已比較選項、留下值得回顧的問題、即將切換主題，或討論暫停但尚未進入正式 spec / milestone
- 若使用者確認保留，將完整討論整理成 `vibe-coding/features/<feature-id>.md`，並更新 `vibe-coding/features/index.md`
- 若使用者未確認保留，只在 `vibe-coding/features/index.md` 留下短記錄：`曾討論：<title>。後續要討論 / 保留 / 棄用？`
- 已確認的 feature 可在使用者要求優化或改善專案時優先提示
- 已確認的 feature 不可自動覆蓋 milestone `work_order`，也不可未經使用者確認就轉成正式 spec 或 milestone task

## UI Contract 與 Layout

- 進入 layout 或畫面實作前，應先確認是否已有相關技術決策；技術棧與框架方向應記錄在 `vibe-coding/specs/decisions.md`
- 進入 UI contract 或 layout 定義前，應詢問使用者是否需要 UI/UX Designer 協助
- 若使用者需要 UI/UX Designer 協助，應先用設計師角色提出 UI/UX 規劃、畫面結構、互動方式、視覺方向與元件建議，再交給使用者確認
- 若使用者不需要 UI/UX Designer 協助，AI 可直接用選項與建議和使用者討論 layout、互動、視覺與元件細節
- 若使用者不清楚 layout 方向，應建議使用者提供 1 到 3 個參考網站、產品、URL、截圖或 UI 範例，並詢問喜歡與不喜歡的部分
- 已確認的跨頁 UI 規則應寫入 `vibe-coding/ui/design-system.md`
- 已確認的 layout 應寫入 `vibe-coding/layouts/index.md`，必要時建立 `vibe-coding/layouts/<layout-id>.md`
- layout 可包含 `overall`、`list`、`detail`、`form`、`dashboard`、`flow`、`feature_specific` 或 `component_guidance`
- layout 是持久設計規格，不必固定隸屬於 milestone；但 milestone 或 task 可以包含定義、修改或實作 layout 的工作
- 若畫面實作結果不符合期待，應優先修訂 layout 或 UI contract，再依修訂後規格調整實作

## Project Report

- 當使用者輸入 `指令：專案報告`，或要求查看目前專案狀態時，AI 應整理 project report
- Project report 是 on-demand / event-driven，不需要每次回覆都更新
- Project report 的目的包含隨時查詢專案狀態，不限於 handoff
- AI 應先讀取現有上下文，再更新 `vibe-coding/reports/data/project-state.yml` 與 `vibe-coding/reports/current-status.md`
- Report source 是 snapshot，必須記錄資料彙整時間；不可把它當成會自動跟著專案演進的 live state
- 整理 report 時，應視需要查看：
  - `AGENTS.md`
  - `vibe-coding/specs/`
  - `vibe-coding/features/`
  - `vibe-coding/milestones/`
  - `vibe-coding/handoff/`
  - `vibe-coding/prototypes/`
  - `vibe-coding/ui/design-system.md`
  - `vibe-coding/reports/data/project-state.yml`
  - `vibe-coding/reports/current-status.md`
- 觀察到的項目不可自動變成 task；應先分類為 context、decision、future option、milestone、task、validation、risk 或 handoff
- 只有在已有明確執行決策時，才建立 milestone 或 task
- 更新 YAML / Markdown 後，執行 `bash ./vibe-coding/vibe-starter/scripts/report --open`、`.\vibe-coding\vibe-starter\scripts\report.ps1 --open` 或 `.\vibe-coding\vibe-starter\scripts\report.cmd --open`
- 若無法開啟瀏覽器，只要 `vibe-coding/reports/html/index.html` 成功產生，report 仍視為完成
- Dashboard 必須顯示 `source_summarized_at` 與 `generated_at`；兩者時間意義不同

## Prototype

- prototype 是視覺探索、比較、驗證與決策追蹤層，不取代 design-system 或 layout
- prototype 預設放在 `vibe-coding/prototypes/`
- design layer 用來固化跨頁 UI 規則與持久 layout 原則；prototype layer 用來記錄實際視覺行為、變體比較與接受理由
- prototype 可不完整，也可刻意忽略 backend；重點是快速得到可判斷的視覺與 UX 反饋
- prototype 狀態固定值為 `exploring`、`comparing`、`accepted`、`implemented`、`deprecated`
- 若需要 AI 協助生成 prototype，應先放在 `exploring/` 或 `comparing/`，不可直接視為正式實作依據
- prototype registry 應記錄在 `vibe-coding/prototypes/registry.yml`
- accepted prototype 應作為畫面實作與防止 design drift 的參考依據
- deprecated prototype 應保留棄用或被取代原因，避免重複走回已否決方向

## Implementation Notes

- 實作過程中應持續維護 `vibe-coding/notes/implementation-notes.md`，記錄實作對 spec 的詮釋、偏離、取捨、未決問題與驗證狀況
- 這份文件的目的是讓未來檢視、交接、治理的人能看懂實作如何詮釋 spec，不是進度日誌
- 應在以下情境新增條目：
  - spec 不夠明確、必須做出選擇時，記錄 design decision 與選擇理由
  - 刻意偏離 spec 時，記錄 deviation、偏離原因，以及 spec 是否應被回寫
  - 評估多個方案後選定其中之一時，記錄 tradeoff 與被淘汰方案
  - 出現需要 owner 確認的問題，或可能影響未來行為、資料、UI、migration 或相容性的疑問時，記錄為 open question
  - 完成驗證、跳過驗證或留下已知風險時，記錄 verification note
- 不可在 `vibe-coding/notes/implementation-notes.md` 中記錄進度或下一步；進度以 `vibe-coding/milestones/` 為準，交接以 `vibe-coding/handoff/` 為準
- 若 `deviation` 或 `open question` 已被解決，應建議把結論回寫到對應 `vibe-coding/specs/` 檔案或 `vibe-coding/specs/decisions.md`，並在 notes 中標示 resolved 與引用位置
- 預設使用單一 rolling 檔；只有在 milestone 實作量極大、需要獨立追蹤時，才額外建立 `vibe-coding/notes/<milestone-id>.md`

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
