# README.md

## 這份文件做什麼

- 用來說明 `vibe-coding/handoff/` 目錄中的交接文件怎麼建立與延續
- 這份文件幫助不同時間點接手的人快速理解目前進度與下一步
- 若交接內容開始混亂，應優先回到這份文件確認命名與內容規則

## Handoff 誰負責整理

- handoff 由 AI 直接整理並寫入，使用者不需要手寫，也不需要每次決定要不要記

## Handoff 觸發時機

- 工作收尾（結束、暫停、切換主題、交由下一次對話或下一位協作者）時，若仍有未完成的 milestone / task（`todo`、`in_progress`、`blocked`）→ **直接寫 handoff，不詢問**
- 本次碰到的 milestone / task 全部完成 → **不寫 handoff**，除非使用者要求

## 收尾順序（固定）

1. 合併記錄複查（debt、implementation notes、decisions）
2. handoff（依上面的觸發時機）
3. commit：本次工作、紀錄與 handoff 放在同一個 commit
4. push

- commit / push 只在使用者要求或專案規則授權時執行
- 不可先 commit / push 再補 handoff；那只會多一次沒有意義的 commit

## Handoff 位置

- handoff 目錄固定為 `vibe-coding/handoff/`，不可由 `AGENTS.md` 或其他指示改成其他路徑
- 目錄不存在時直接建立，不搜尋、也不改用其他資料夾

## Handoff 檔名

- 格式：`<YYYYMMDD>-<人員代號>[-<n>]-<topic>.md`
- `<topic>` 使用 kebab-case
- 同一人同日第二份起加 `-2`、`-3`，例如 `20261029-alice-2-auth-flow.md`
- 人員代號規則與 `AGENTS.md` 的 ID 規則相同

## 範例

### 建議命名方式

- `20260422-alice-initial-setup.md`
- `20260422-alice-2-auth-flow-update.md`

### 每份 handoff 建議內容

- 作者人員代號
- 目前做到哪裡
- 已完成什麼
- 還缺什麼
- 下一步建議
- 風險或待確認事項
- `open_debt_summary`：仍未償還的 debt
- `scheduled_debt_summary`：已排入 milestone / task 的 debt

### Handoff 觸發時機

- 收尾時仍有未完成的 milestone / task → 直接寫
- 全部完成 → 不寫，除非使用者要求

## 空白模板

```md
### 建議命名方式

- 

### 每份 handoff 建議內容

- 
- 

### Handoff 觸發時機

- 
- 
```

## 正式資料

### 建議命名方式

- 依 `<YYYYMMDD>-<人員代號>[-<n>]-<topic>.md` 命名
- 檔名應能快速反映交接主題

### 每份 handoff 建議內容

- 作者人員代號
- 目前做到哪裡
- 已完成什麼
- 還缺什麼
- 下一步建議
- 風險或待確認事項
- `open_debt_summary`：仍未償還的 debt
- `scheduled_debt_summary`：已排入 milestone / task 的 debt

### Handoff 觸發時機

- 收尾時仍有未完成的 milestone / task → 直接寫
- 全部完成 → 不寫，除非使用者要求

### Handoff 位置

- 固定為 `vibe-coding/handoff/`
