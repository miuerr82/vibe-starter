# Technical Debt Register

> 這份文件用來追蹤「為了當下選擇刻意留下的未來代價」。
> 不要把它當作進度日誌；進度與工作狀態請使用 `vibe-coding/milestones/`，交接請使用 `vibe-coding/handoff/`，spec 詮釋請使用 `vibe-coding/notes/implementation-notes.md`。

## 這份文件存什麼

每一筆 debt 都會經過下列狀態流轉：

- `proposed` → `accepted`：使用者確認要登記為 debt
- `accepted` → `scheduled`：已連到 milestone / task 預計回收
- `scheduled` → `paying_back` → `paid`：實際開始並完成回收
- `accepted` → `waived`：明確決定不回收，但必須記 `review_condition`
- 任何 open 狀態 → `superseded`：被新條目取代

已結束的條目（`paid` / `waived` / `superseded`）保留為歷史記錄，不刪除。

## 摘要區（每次更新時同步調整）

### Open（accepted, 未排程）

| debt_id | title | debt_type | payback_trigger / window | accepted_by | updated_at |
| --- | --- | --- | --- | --- | --- |

### Scheduled

| debt_id | title | payback_milestone_ref | payback_task_ref | updated_at |
| --- | --- | --- | --- | --- |

### Paid

| debt_id | title | resolved_at | resolution_summary | updated_at |
| --- | --- | --- | --- | --- |

### Waived

| debt_id | title | review_condition | updated_at |
| --- | --- | --- | --- |

## 條目模板

每筆 entry 請複製以下骨架：

```md
## DEBT-xxx｜<short title>

- **Status:** proposed / accepted / scheduled / paying_back / paid / waived / superseded
- **Debt type:** shortcut / workaround / deferred_refactor / missing_test / hardcoded_value / dependency_pin / duplicate_logic / scaling_limit / compliance_gap / other
- **Summary:** <一兩句說明這筆 debt 在做什麼>
- **Spec refs:** <檔案路徑 / OBJ-xxx / BEH-xxx / RULE-xxx / layout id / decision id / milestone id>
- **Related milestone refs:** <產生此 debt 的 milestone_id 或為空>
- **Related task refs:** <產生此 debt 的 task_id 或為空>
- **Reason left:** <為什麼當下選擇留下，而不是現在就處理>
- **Alternatives considered:** <考慮過但被淘汰的替代方案>
- **Cost of not paying:** <不處理的影響：效能 / 維護性 / 阻擋擴張 / 風險面 等>
- **Blocks future scope:** <明確阻擋的未來功能或範圍；無則寫「無」>
- **Payback trigger:** <信號條件，例如「上線 X 功能前」「流量超過 N」「下次重構 Y 模組時」；若改用 window 則寫「無」>
- **Payback window:** <預期回收時段，例如「2026 Q3 前」；若改用 trigger 則寫「無」>
- **Payback priority:** low / normal / high / critical
- **Accepted by:** <承擔者；通常是 owner role 或人員>
- **Review condition:** <若 waived 必填；其他狀態下若有重新評估點也可填>
- **Payback milestone ref:** <scheduled / paying_back / paid 時填；其他狀態空白>
- **Payback task ref:** <scheduled / paying_back / paid 時填；其他狀態空白>
- **Resolution summary:** <paid / waived / superseded 時填，含回寫到哪份 spec 或 decision>
- **Created at:** YYYY-MM-DD
- **Updated at:** YYYY-MM-DD
- **Resolved at:** YYYY-MM-DD（paid / waived / superseded 時填）
```

## 條目（依時間倒序新增）

<!-- 新條目請加在這一行下面 -->
