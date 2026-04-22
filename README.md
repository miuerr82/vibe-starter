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

## 快速開始

1. 建立並 clone 產品專案

```bash
git clone <your-product-repo> /path/to/project
cd /path/to/project
```

2. 建立 `vibe-coding/`

```bash
mkdir -p vibe-coding
cd vibe-coding
```

3. clone `vibe-starter`

```bash
git clone https://<your-repo>/vibe-starter
cd /path/to/project
```

4. 執行初始化

```bash
bash ./vibe-coding/vibe-starter/scripts/init
```

5. 生成工作文件

```bash
bash ./vibe-coding/vibe-starter/scripts/generate
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
