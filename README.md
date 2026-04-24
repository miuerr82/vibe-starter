# vibe-starter

`vibe-starter` 是放在產品專案內的初始化工具，用來幫新專案建立最基本的 AI 協作工作環境與 spec 文件骨架。

它的定位不是產品原始碼模板，而是：

- 幫專案補上根目錄 `AGENTS.md`
- 幫專案建立 `vibe-coding/` 下的工作文件
- 幫專案生成第一版 spec / handoff 模板

後續真正的產品開發，仍然以產品專案根目錄為主。

## Quick Start

如果你是第一次使用，先照這 5 步做即可：

```bash
git clone <your-product-repo> /path/to/project
cd /path/to/project
mkdir -p vibe-coding
cd vibe-coding
git clone https://<your-repo>/vibe-starter
cd /path/to/project
bash ./vibe-coding/vibe-starter/scripts/init
bash ./vibe-coding/vibe-starter/scripts/generate
```

做完之後，你會得到：

- 根目錄 `AGENTS.md`
- `vibe-coding/.gitignore`
- `vibe-coding/specs/` 下的 spec 模板
- `vibe-coding/handoff/` 下的 handoff 模板

## 這個專案的用途

這個 starter 主要處理兩件事：

1. `init`
   - 初始化產品專案的 AI 協作環境
   - 建立或補齊 `AGENTS.md`
   - 建立 `vibe-coding/.gitignore`

2. `generate`
   - 在 `vibe-coding/` 下生成 spec 與 handoff 模板
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
- 可選：`specs/user_flows.md`

這些文件的模板都位於：

- `templates/vibe-coding/specs/`
- `templates/vibe-coding/handoff/`

## `generate` 使用方式

可從產品專案根目錄執行：

```bash
bash ./vibe-coding/vibe-starter/scripts/generate
```

也可直接指定模式：

```bash
bash ./vibe-coding/vibe-starter/scripts/generate single 1
bash ./vibe-coding/vibe-starter/scripts/generate single project
bash ./vibe-coding/vibe-starter/scripts/generate multiple 2 role object
bash ./vibe-coding/vibe-starter/scripts/generate all
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
- `13` / `user_flows` / `steps`

## 初始化後的工作流程

執行完 `init` 與 `generate` 之後，日常工作建議照這個順序進行：

1. 先讀上下文
   - 先閱讀專案根目錄 `AGENTS.md`
   - 再讀 `vibe-coding/handoff/` 下最近的交接內容
   - 若已有 spec，先看與當前工作相關的文件

2. 先規劃，再執行
   - 先整理本次工作的 `milestone`
   - 再把每個 `milestone` 拆成 `tasks in milestone`
   - 一次只處理一個 task

3. 先補 spec，再做實作
   - 若需求、物件、流程或規則還沒定義，先補 spec
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
