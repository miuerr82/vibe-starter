# README.md

## 這份文件做什麼

- 說明 `vibe-coding/notes/` 目錄的用途與 `implementation-notes.md` 的寫法
- 幫助未來檢視、交接、治理的人理解「實作如何詮釋 spec」

## 這個資料夾的定位

- 這層只記錄「實作對 spec 的詮釋、偏離、取捨、未決問題與驗證狀況」
- 這層**不是進度記錄**，也不是 handoff
  - 進度與工作狀態以 `vibe-coding/milestones/` 為準
  - 工作節點交接以 `vibe-coding/handoff/` 為準
  - spec 與決策本體以 `vibe-coding/specs/` 為準

## 主要產出

- `vibe-coding/notes/implementation-notes.md`：單一 rolling 文件，貫穿整個產品專案實作期間
- 若某個 milestone 的實作量極大、需要獨立追蹤，才可額外建立 `vibe-coding/notes/<milestone-id>.md`
- 預設仍以單一 rolling 檔為主，避免拆檔過細失去整體 traceability

## 何時新增條目

- 實作過程中遇到 spec 不夠明確、必須做出選擇時
- 實作刻意偏離 spec 時
- 評估多個方案後選定其中之一時
- 出現需要 owner 確認的開放問題時
- 完成驗證、跳過驗證、或留下已知風險時

## 不可寫入的內容

- 「今天完成了 task X」「目前進度 60%」這類**進度敘述**
- 「明天要做 task Y」這類**下一步規劃**
- 已經寫在 `vibe-coding/specs/` 或 `vibe-coding/specs/decisions.md` 的決策結論
- 已經寫在 `vibe-coding/handoff/` 的交接內容

進度與下一步請更新 `vibe-coding/milestones/`；交接請整理 `vibe-coding/handoff/`。

## 條目應該怎麼寫

每一筆 entry 建議包含：

- 日期
- 類型：`design_decision` / `deviation` / `tradeoff` / `open_question` / `verification`
- 對應 spec 引用（檔案路徑、ROLE/OBJ/BEH/FLOW/RULE id、layout id 等）
- 描述
- 為什麼
- 影響範圍（是否需要回寫 spec、是否影響資料、是否影響 migration / 相容性）

## 何時應該回寫 spec

- `deviation` 或 `design_decision` 若已被驗證可接受，應建議把結論回寫到 `vibe-coding/specs/` 對應檔案
- `open_question` 在 owner 確認後，結論應回寫到 spec 或 `decisions.md`，並在 notes 中標示已 resolved 與引用位置
- 回寫後，notes 中的對應條目保留作為歷史紀錄，不要刪除

## 與其他層的關係

- 實作前的需求釐清：見 `vibe-coding/features/` 與 `vibe-coding/specs/`
- 實作中的工作順序：見 `vibe-coding/milestones/`
- 實作中的視覺與互動規則：見 `vibe-coding/ui/`、`vibe-coding/layouts/`、`vibe-coding/prototypes/`
- 實作後的交接：見 `vibe-coding/handoff/`
- 本層只負責填補：實作怎麼詮釋 spec、偏離原因、取捨理由、未決問題、驗證狀況
