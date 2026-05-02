# vibe-starter

`vibe-starter` 是放在產品專案內的初始化工具，用來幫新專案建立最基本的 AI 協作工作環境與 spec 文件骨架。

它的定位不是產品原始碼模板，而是：

- 幫專案補上根目錄 `AGENTS.md`
- 幫專案建立 `vibe-coding/` 下的工作文件
- 幫專案生成第一版 spec / handoff 模板

後續真正的產品開發，仍然以產品專案根目錄為主。

## Quick Start

如果你是第一次使用，先照下面其中一種方式做即可。

### 方式 A：Linux / macOS

適合已有 `git`，並使用 `bash` 的環境。

```bash
git clone <your-product-repo> /path/to/project
cd /path/to/project
mkdir -p vibe-coding
cd vibe-coding
git clone https://github.com/miuerr82/vibe-starter.git
cd /path/to/project
bash ./vibe-coding/vibe-starter/scripts/init
bash ./vibe-coding/vibe-starter/scripts/generate
```

### 方式 B：Windows

適合已有 `git`，並使用 PowerShell 或 cmd 的環境。

先取得 starter：

```powershell
git clone <your-product-repo> C:\path\to\project
Set-Location C:\path\to\project
New-Item -ItemType Directory -Force vibe-coding
Set-Location .\vibe-coding
git clone https://github.com/miuerr82/vibe-starter.git
Set-Location C:\path\to\project
```

再執行 starter：

```powershell
.\vibe-coding\vibe-starter\scripts\init.ps1
.\vibe-coding\vibe-starter\scripts\generate.ps1
```

或：

```cmd
cd /d C:\path\to\project
if not exist vibe-coding mkdir vibe-coding
cd vibe-coding
git clone https://github.com/miuerr82/vibe-starter.git
cd /d C:\path\to\project
.\vibe-coding\vibe-starter\scripts\init.cmd
.\vibe-coding\vibe-starter\scripts\generate.cmd
```

### 方式 C：沒有 `git`

1. 先下載產品專案到本機，並進入產品專案根目錄。
2. 建立 `vibe-coding/` 目錄。
3. 開啟 `https://github.com/miuerr82/vibe-starter/tags`。
4. 下載最新 tag 的原始碼壓縮檔。
5. 解壓縮後，若資料夾名稱帶有版本號，請重新命名為 `vibe-starter`。
6. 將該資料夾放到產品專案的 `vibe-coding/` 下面，使路徑成為 `vibe-coding/vibe-starter`。
7. 回到產品專案根目錄後，執行 `init` 與 `generate`。

例如：

```text
<project-root>/
├─ vibe-coding/
│  └─ vibe-starter/
```

之後可依你的 shell 選擇對應入口：

Linux / macOS：

```bash
bash ./vibe-coding/vibe-starter/scripts/init
bash ./vibe-coding/vibe-starter/scripts/generate
```

Windows PowerShell：

```powershell
.\vibe-coding\vibe-starter\scripts\init.ps1
.\vibe-coding\vibe-starter\scripts\generate.ps1
```

Windows cmd：

```cmd
.\vibe-coding\vibe-starter\scripts\init.cmd
.\vibe-coding\vibe-starter\scripts\generate.cmd
```

做完之後，你會得到：

- 根目錄 `AGENTS.md`
- `vibe-coding/.gitignore`
- `vibe-coding/specs/` 下的 spec 模板
- `vibe-coding/handoff/` 下的 handoff 模板
- `vibe-coding/milestones/` 下的 milestone 追蹤模板

## 這個專案的用途

這個 starter 主要處理兩件事：

1. `init`
   - 初始化產品專案的 AI 協作環境
   - 建立或補齊 `AGENTS.md`
   - 建立 `vibe-coding/.gitignore`

2. `generate`
   - 在 `vibe-coding/` 下生成 spec、handoff 與 milestone 模板
   - 協助專案快速進入 spec-driven 工作方式

目前第一版聚焦在：

- 單一專案
- 全端 web 專案優先
- 中文文件優先

## 適用情境

- 你剛建立一個新的產品專案
- 你想把 AI 協作規則與 handoff 留在產品專案內
- 你想先生成 spec 文件骨架，再逐步補內容
- 你不想把 starter 本身當成產品 repo 的一部分

## 目錄位置

`vibe-starter` 預期放在產品專案內的這個位置：

```text
<project-root>/
├─ vibe-coding/
│  └─ vibe-starter/
```

不論你是用 `git clone` 還是從 tags 下載最新版，只要最後目錄位置一致，後續工作流程就相同。

## `init` 會做什麼

`init` 目前會：

- 確認你是從產品專案根目錄執行
- 確保 `vibe-coding/` 存在
- 建立或補齊 `vibe-coding/.gitignore`
- 將 `vibe-starter` 加入 `vibe-coding/.gitignore`
- 檢查根目錄 `AGENTS.md`
- 若沒有 `AGENTS.md`，則建立一份基礎版
- 若已有 `AGENTS.md`，則走衝突處理流程
- 完成後提示下一步執行 `generate`

基礎 `AGENTS.md` 模板位置：

- `templates/AGENTS.md`

## `generate` 會做什麼

`generate` 目前會在產品專案的 `vibe-coding/` 下建立這些文件：

- `specs/0_project.md`
- `specs/glossary.md`
- `specs/roles.md`
- `specs/objects.md`
- `specs/behaviors.md`
- `specs/flows.md`
- `specs/boundaries.md`
- `specs/states.md`
- `specs/rules.md`
- `specs/interfaces.md`
- `specs/decisions.md`
- `handoff/README.md`
- `milestones/index.md`
- `milestones/tasks/README.md`
- 可選：`specs/user_flows.md`

這些文件的模板都位於：

- `templates/vibe-coding/specs/`
- `templates/vibe-coding/handoff/`
- `templates/vibe-coding/milestones/`

## `generate` 使用方式

可從產品專案根目錄執行：

```bash
bash ./vibe-coding/vibe-starter/scripts/generate
```

```powershell
.\vibe-coding\vibe-starter\scripts\generate.ps1
```

```cmd
.\vibe-coding\vibe-starter\scripts\generate.cmd
```

也可直接指定模式：

```bash
bash ./vibe-coding/vibe-starter/scripts/generate single 1
bash ./vibe-coding/vibe-starter/scripts/generate single project
bash ./vibe-coding/vibe-starter/scripts/generate multiple 2 role object
bash ./vibe-coding/vibe-starter/scripts/generate all
```

```powershell
.\vibe-coding\vibe-starter\scripts\generate.ps1 single 1
.\vibe-coding\vibe-starter\scripts\generate.ps1 single project
.\vibe-coding\vibe-starter\scripts\generate.ps1 multiple 2 role object
.\vibe-coding\vibe-starter\scripts\generate.ps1 all
```

```cmd
.\vibe-coding\vibe-starter\scripts\generate.cmd single 1
.\vibe-coding\vibe-starter\scripts\generate.cmd single project
.\vibe-coding\vibe-starter\scripts\generate.cmd multiple 2 role object
.\vibe-coding\vibe-starter\scripts\generate.cmd all
```

### 模式

- `single`
- `multiple`
- `all`

若不帶參數執行，會進入互動式編號選單：

1. 先選模式
   - `1. 單一`
   - `2. 多個`
   - `3. 全部`
2. 若選 `1` 或 `2`，再選文件編號

### 文件編號 / key / 別名

- `1` / `0_project` / `project`
- `2` / `glossary` / `terms`
- `3` / `roles` / `role`
- `4` / `objects` / `object`
- `5` / `behaviors` / `behavior`
- `6` / `flows` / `flow`
- `7` / `boundaries` / `boundary`
- `8` / `states` / `state`
- `9` / `rules` / `rule`
- `10` / `interfaces` / `interface`
- `11` / `decisions` / `decision`
- `12` / `handoff` / `handoff_readme`
- `13` / `milestones` / `milestone_index`
- `14` / `milestone_tasks` / `tasks_readme`
- `15` / `user_flows` / `steps`

## 初始化後的工作流程

執行完 `init` 與 `generate` 之後，日常工作建議照這個順序進行：

1. 先讀上下文
   - 先閱讀專案根目錄 `AGENTS.md`
   - 若 `AGENTS.md` 已明確寫出 spec 或 handoff 路徑，優先使用該路徑
   - 若 `AGENTS.md` 沒有明確寫出路徑，先從 `vibe-coding/` 找起
   - 若沒有 `vibe-coding/`，再搜尋其他 vibe-coding 相關目錄；若仍找不到，才建立新的 `vibe-coding/`
   - 若本次是靠 fallback 才找到有效路徑，應建議補寫回 `AGENTS.md`
   - 再讀 `vibe-coding/handoff/` 下最近的交接內容
   - 若已有 spec，先看與當前工作相關的文件

2. 先規劃，再執行
   - 先整理本次工作的 `milestone`
   - 再把每個 `milestone` 拆成 `tasks in milestone`
   - milestone 總表放在 `vibe-coding/milestones/index.md`
   - milestone tasks 詳細內容放在 `vibe-coding/milestones/tasks/<milestone-id>.md`
   - 總表依 `work_order` 提供工作順序，`priority` 只作為選填的重要性提示
   - 總表中的 `manual_pending_task_refs` 只記錄使用者手動 pending 的商業決策項，不由 AI 自動推導
   - `actual_duration` 使用 `00h:00m`，`elapsed_calendar_duration` 以天為單位並保留小數點兩位
   - 一次只處理一個 task

3. 先判斷是否需要補 spec
   - 若只是純技術性、小範圍、且不改變行為的修改，可先做一致性檢查後直接實作
   - 若會影響需求、物件責任、流程、規則或狀態，先補最小必要 spec
   - 若 spec、文件、實作不一致，先指出並補齊
   - spec 明確後再進入實作

4. task 完成後立即記錄 `handoff`
   - 每完成一個 task，就先更新 `vibe-coding/handoff/`
   - `handoff` 應記錄本次完成內容、目前狀態、下一步建議或待處理項目

5. 再決定是否繼續
   - 若目前 `milestone` 還有未完成 task，`handoff` 記錄完成後，再由使用者決定要繼續或停止
   - 若沒有作用中的 `milestone`，或 task 已全部完成，則不必強制詢問是否繼續
   - 這種情況下若有合理下一步，可以提供建議，但仍保留停止選項

6. 如果不知道怎麼開始
   - 先提供這三個選項：
     - `我有明確的計畫。`
     - `我還沒有完整計畫，但我知道想做的工作項目。`
     - `我不知道該怎麼開始。`
   - 若使用者選擇第三項，再先檢查相關檔案並提供建議

這套流程的核心是：

- 產品開發以產品專案根目錄為主
- spec 與 handoff 跟著產品專案走
- `vibe-starter` 只負責初始化與提供通用工作骨架

## 可直接使用的 prompts

以下 prompt 可直接複製後使用，適合在不知道怎麼開始、需要判斷、拆解工作，或卡住時使用。

### 開局用

- `請幫我開始這次工作。`
- `我有明確的計畫，請幫我確認執行方式。`
- `我知道想做什麼，但還沒整理，請幫我整理成 milestone 和 tasks in milestone。`
- `我不知道怎麼開始，請先檢查相關檔案並給我建議。`
- `請先幫我整理這個專案目前的狀態與建議起點。`

### 判斷用

- `請幫我判斷這次修改要不要先補 spec。`
- `請幫我判斷這是小修，還是會影響行為的改動。`
- `請幫我判斷目前應該先看哪些檔案。`
- `請幫我判斷這次工作比較像 bug fix、規格補齊，還是功能擴充。`

### 拆解用

- `請幫我把這次工作整理成 milestone。`
- `請幫我把這個 milestone 拆成 tasks in milestone。`
- `請幫我按照目前上下文，整理最合理的執行順序。`
- `請幫我整理這次工作需要先處理的 spec。`

### 卡住時用

- `我卡住了，請幫我找出目前缺少的資訊。`
- `請幫我整理目前進度、風險和下一步。`
- `請幫我確認 spec、文件、實作是否一致。`
- `請幫我找出這次工作最大的阻塞點。`

### 舊專案用

- `這是舊專案，請幫我判斷這次修改是否需要先補最小必要 spec。`
- `請幫我從現有程式與文件反推出這次工作需要的最小 spec 範圍。`
- `請幫我找出這次改動會影響的流程、規則、狀態或物件。`

### task 完成後用

- `請幫我整理這個 task 的 handoff 內容。`
- `請幫我整理這個 task 完成後的下一步建議。`
- `請幫我確認目前這個 milestone 還剩下哪些 tasks。`

## 衝突處理規則

### `AGENTS.md`

若根目錄已存在 `AGENTS.md`，會詢問：

- 是否覆寫
- 若不覆寫，可選：
  - 提供其他檔名
  - 略過

### `generate` 產生的文件

若目標檔案已存在，會詢問：

- 是否覆寫
- 若不覆寫，可選：
  - 提供其他檔名
  - 略過

### `vibe-coding/.gitignore`

- 不走覆寫流程
- 若已存在，直接 append 必要內容

## 使用後的工作方式

執行完 `init` 與 `generate` 之後：

- 產品開發仍以產品專案根目錄為主
- spec 與 handoff 跟著產品專案走
- `vibe-starter` 只是工具，不是產品原始碼的一部分

## 注意事項

- 這個 starter 目前是最小可用版本
- 後續 spec 結構或模板格式仍可能調整
- 需要人工閱讀與維護的文件，預設以中文為主
