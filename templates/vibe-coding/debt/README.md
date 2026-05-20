# README.md

## 這份文件做什麼

- 說明 `vibe-coding/debt/` 目錄的用途與 `debt-register.md` 的寫法
- 幫助未來檢視、交接、治理的人能看到「現在欠了未來什麼、為什麼留下、什麼時候要還」

## 這個資料夾的定位

- 這層只記錄「為了當下選擇刻意留下的未來代價」
- 這層**不是進度記錄**，也不是 implementation notes、handoff、decision log
  - 進度與工作狀態以 `vibe-coding/milestones/` 為準
  - 工作節點交接以 `vibe-coding/handoff/` 為準
  - 對 spec 的詮釋、偏離、取捨、未決問題以 `vibe-coding/notes/implementation-notes.md` 為準
  - 決策本體以 `vibe-coding/specs/decisions.md` 為準

## 主要產出

- `vibe-coding/debt/debt-register.md`：單一 rolling 註冊表，貫穿整個產品專案實作期間
- 每筆 debt 都是一個帶有狀態機的條目（proposed / accepted / scheduled / paying_back / paid / waived / superseded）
- 已解決 (paid / waived / superseded) 的條目仍保留為歷史記錄，不刪除

## 何時新增條目

- 為了趕時程留下硬編值、跳過測試、或繞過 spec 流程時
- 為了相容性 / 第三方 API 限制留下 workaround 時
- 評估後決定先延後重構，但已知未來會撞到的時候
- 接受某個風險、但同意未來特定條件下要回頭處理時

## 不可寫入的內容

- 「今天完成了 task X」「目前進度 60%」這類**進度敘述**
- 「明天要做 task Y」這類**下一步規劃**
- 已經寫在 `vibe-coding/notes/implementation-notes.md` 的 spec 詮釋
- 已經寫在 `vibe-coding/specs/decisions.md` 的決策結論本體

## 條目應該怎麼寫

每一筆 entry 至少要包含：

- `debt_id`（DEBT-001 起遞增、不重用）
- `debt_type`：`shortcut` / `workaround` / `deferred_refactor` / `missing_test` / `hardcoded_value` / `dependency_pin` / `duplicate_logic` / `scaling_limit` / `compliance_gap` / `other`
- 對應 spec 引用（檔案路徑、OBJ-xxx、BEH-xxx、RULE-xxx、layout id、decision id、milestone id 等）
- `reason_left`：為什麼當下選擇留下
- `cost_of_not_paying`：不處理的代價（效能、可維護性、阻擋擴張、合規風險等）
- `payback_trigger` 或 `payback_window`：什麼條件下要回頭處理（兩者不可同時空白）
- `accepted_by`：誰知情並承擔
- 若是 waived，必須記 `review_condition`

## tradeoff 與 debt 的邊界

- 沒有未來代價的取捨 → 記在 `vibe-coding/notes/implementation-notes.md` 的 `tradeoff` 類型
- 有未來代價（必須回頭處理或明確 waive）→ 記在本檔案
- 同一個取捨不應同時跨兩層；spec 詮釋脈絡會被本 debt 條目的 `spec_refs` 帶過去

## 何時回寫 spec

- debt 結束 (paid) 時，若實作改回了 spec、或變更了 spec 的方向，應回寫到對應 `vibe-coding/specs/` 檔案或 `vibe-coding/specs/decisions.md`
- 回寫後本 debt 條目改為 `paid`、並在 `resolution_summary` 中引用 spec 變更位置；條目本身保留作歷史紀錄

## 與其他層的關係

- 實作中遇到 spec 詮釋問題：見 `vibe-coding/notes/implementation-notes.md`
- 架構或選型決策：見 `vibe-coding/specs/decisions.md` 與 `vibe-coding/specs/`
- 任何 milestone / task 若為了「還某筆 debt」而存在，應在該 milestone 或 task 的 `paying_back_debt_ref` 引用本檔案的對應 debt_id
- 任何 milestone / task 若產生新的 debt，應在 `incurred_debt_refs` 引用對應 debt_id
- 交接時，handoff 應在 `open_debt_summary` 與 `scheduled_debt_summary` 中摘錄本檔案的目前狀態
