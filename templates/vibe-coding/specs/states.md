# states.md

## 這份文件做什麼

- 用來定義此產品專案中的狀態與狀態轉移
- 這份文件負責描述一個物件可能有哪些狀態，以及狀態之間如何改變
- 這份文件不重新定義流程，也不在這裡補寫角色或物件定義
- 每個有狀態的物件以 `### <OBJ ID> <物件名稱>` 為標題，與 `objects.md` 使用同一個 ID；狀態 key 用 snake_case 英文，括號內附中文，跨檔引用一律用 key

## 不知道怎麼開始時

- 可以先從「這個物件會經歷哪些階段」開始想
- 若不確定要不要列成狀態，可以先問自己：這個差異是否會影響後續行為、權限、規則或流程
- 若還是不確定，可先回頭看 `objects.md`、`behaviors.md`、`flows.md`，把那些會被建立、送出、審核、完成、取消的變化整理成狀態與轉移

### 可直接請 AI 協助的 Prompt

> 請根據我的 `objects.md`、`behaviors.md`、`flows.md`，幫我整理出此專案應該寫進 `states.md` 的狀態與狀態轉移。請只整理明確的狀態與允許的轉移，不要把流程步驟整段重寫，並指出哪些物件其實不需要獨立狀態。

## 範例

### OBJ-20260505-alice 申請單

- 狀態：
  - draft（草稿）
  - submitted（已送出）
  - reviewing（審核中）
  - approved（已核准）
  - rejected（已退回）
- 轉移：
  - draft → submitted（觸發：BEH-20260505-alice）
  - submitted → reviewing（觸發：BEH-20260505-alice-2）
  - reviewing → approved（觸發：BEH-20260505-alice-3）
  - reviewing → rejected（觸發：BEH-20260505-alice-4）

## 空白模板

```md
### OBJ-<YYYYMMDD>-<人員代號> 物件名稱

- 狀態：
  - 
- 轉移：
  -  → （觸發：BEH-）
```

## 正式資料

### OBJ-<YYYYMMDD>-<人員代號> 物件名稱

- 狀態：
  - 
- 轉移：
  -  → （觸發：BEH-）
### OBJ-<YYYYMMDD>-<人員代號> 物件名稱

- 狀態：
  - 
- 轉移：
  -  → （觸發：BEH-）
