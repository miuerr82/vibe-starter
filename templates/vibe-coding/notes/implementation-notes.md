# Implementation Notes

> 這份文件用來記錄「實作如何詮釋 spec」。
> 不要把它當作進度日誌；進度與工作狀態請使用 `vibe-coding/milestones/`，交接請使用 `vibe-coding/handoff/`。

## 這份文件存什麼

當實作過程中發生以下情況時，加入一筆 entry：

1. **Design decisions**
   - 在 spec 不夠明確時做出的選擇
   - 為什麼這樣選

2. **Deviations**
   - 刻意偏離 spec 的地方
   - 為什麼必須偏離
   - spec 是否應該被回寫

3. **Tradeoffs**
   - 評估過的替代方案
   - 為什麼選定目前的方向

4. **Open questions**
   - 需要 owner 確認的事項
   - 可能影響未來行為、資料、UI、migration 或相容性的疑問

5. **Verification notes**
   - 已驗證的部分
   - 未驗證的部分
   - 實作後已知的風險

## 條目模板

每筆 entry 請複製以下骨架：

```md
## YYYY-MM-DD｜<type>｜<short title>

- **Spec refs:** <檔案路徑 / ROLE-xxx / OBJ-xxx / BEH-xxx / FLOW-xxx / RULE-xxx / layout id>
- **Context:** <當下情境，一兩句>
- **Decision / observation:** <做了什麼 / 觀察到什麼>
- **Why:** <理由>
- **Impact:** <是否需要回寫 spec、是否影響資料、是否影響 UI、是否影響 migration / 相容性>
- **Follow-up:** <尚未解決的待辦、需要 owner 確認的點；無則寫「無」>
- **Status:** open / resolved / waived
```

`<type>` 請填：`design_decision` / `deviation` / `tradeoff` / `open_question` / `verification`。

## 條目（依時間倒序新增）

<!-- 新條目請加在這一行下面 -->
