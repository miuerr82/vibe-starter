# vibe-starter

這份 starter 是放在專案內 `vibe-coding/` 目錄下的小工具，用來初始化新的專案。後續開發仍以專案根目錄為主，`vibe-starter` 只負責初始化與輔助。

## 適用情境

- 你要建立一個新的單一專案
- 你希望用 starter 幫專案補上基礎結構
- 你希望把工具集中放在專案內的 `vibe-coding/`
- 你希望後續開發與 handoff 都跟著專案走

## 1. 建立並取得產品專案

先在 GitHub 建立產品專案，然後 clone 到本機。

範例：

```bash
git clone <your-product-repo> /path/to/project
cd /path/to/project
```

## 2. 建立 `vibe-coding` 工作目錄

在專案底下建立放置工具的工作目錄：

範例：

```bash
mkdir vibe-coding
cd vibe-coding
```

## 3. 取得 `vibe-starter`

在 `vibe-coding/` 底下 clone `vibe-starter`：

```bash
cd /path/to/my-project
git clone https://....../vibe-starter
```

完成後回到專案根目錄：

```bash
cd /path/to/project
```

## 4. 執行初始化

從專案根目錄執行：

```bash
bash ./vibe-coding/vibe-starter/scripts/init
```

## 5. `init` 會做什麼

`init` 至少應完成以下事情：

- 確認目前是在產品專案根目錄執行
- 檢查 `vibe-coding/.gitignore` 是否存在
- 若不存在則建立 `vibe-coding/.gitignore`
- 若已存在則直接 append 忽略規則
- 將 `vibe-starter` 加入 `vibe-coding/.gitignore`
- 檢查專案根目錄是否已有 `AGENTS.md`
- 如果沒有 `AGENTS.md`，建立一份基礎版 `AGENTS.md`
- 將 starter 所需的初始化內容寫入該專案
- 讓後續 vibe coding 以該專案根目錄為主要工作上下文
- 完成後建議下一步執行 `generate`

目前基礎 `AGENTS.md` 模板草案位於：

- `vibe-starter/templates/AGENTS.md`

## 6. `AGENTS.md` 規則

- `init` 執行時，會先檢查專案根目錄是否存在 `AGENTS.md`
- 若不存在，會建立一份基礎 `AGENTS.md`
- 若已存在，會先詢問是否覆寫
- 若不覆寫，可選擇提供其他檔名，或直接略過

## 7. 檔案衝突處理

- 若 `init` 發現根目錄 `AGENTS.md` 已存在，不會直接覆蓋
- 會先詢問是否覆寫
- 若不覆寫，可選擇提供其他檔名，或直接略過該檔案
- `vibe-coding/.gitignore` 不走覆寫流程，存在時直接 append

建議提示語：

- `檔案已存在，是否覆寫？`
- `若不覆寫，請選擇：提供其他檔名 / 略過`

## 8. 後續工作位置

- 後續的 vibe coding 以目標專案根目錄為主
- 專案開發過程產生的 handoff 應跟著該專案保存
- `vibe-starter` 位於 `vibe-coding/` 內，作為工具使用
- `vibe-coding/.gitignore` 會忽略 `vibe-starter`

## 9. 標準工作步驟

```bash
git clone <your-product-repo> /path/to/project
cd /path/to/project
mkdir vibe-coding && cd vibe-coding
git clone https://....../vibe-starter
cd /path/to/project
bash ./vibe-coding/vibe-starter/scripts/init
```

## 10. 注意事項

- `vibe-starter` 是專案內的工具目錄，不是產品原始碼主體
- 一個 starter 初始化流程只對應一個專案
- 需要人工閱讀與維護的說明文件，預設應保持中文

## 11. 下一步

- `init` 完成後，建議執行 `generate`
- `generate` 用來建立 `vibe-coding/` 內的其他支援文件
- `generate` 不負責產品原始碼初始化
- `generate` 產出的每份文件都應包含用途說明、至少一個範例，以及可直接填寫的空白模板
- 建議提示語：
  - `請選擇要生成的文件：單一 / 多個 / 全部`
  - `檔案已存在，是否覆寫？`
  - `若不覆寫，請選擇：提供其他檔名 / 略過`
  - `生成完成。已建立、覆寫、略過的檔案如下。`
- 第一個建議生成的文件是 `vibe-coding/specs/0_project.md`
- 第二個建議生成的文件是 `vibe-coding/specs/glossary.md`
- 第三個建議生成的文件是 `vibe-coding/specs/roles.md`
- 第四個建議生成的文件是 `vibe-coding/specs/objects.md`
- 第五個建議生成的文件是 `vibe-coding/specs/behaviors.md`
- 第六個建議生成的文件是 `vibe-coding/specs/flows.md`
- 第七個建議生成的文件是 `vibe-coding/specs/boundaries.md`
- 第八個建議生成的文件是 `vibe-coding/specs/states.md`
- 第九個建議生成的文件是 `vibe-coding/specs/rules.md`
- 第十個建議生成的文件是 `vibe-coding/specs/interfaces.md`
- 第十一個建議生成的文件是 `vibe-coding/specs/decisions.md`
- 第十二個建議生成的文件是 `vibe-coding/handoff/README.md`
- 可選輔助文件是 `vibe-coding/specs/user_flows.md`
- 若熟悉 spec 建模，可直接撰寫 `behaviors.md` 與 `flows.md`
- 若想先用步驟流程描述需求，可先寫 `user_flows.md`，再由 AI 協助整理成正式 spec
- 若已有可交接內容，建議提示：
  - `目前已有可交接內容，是否要我整理 handoff？`

## 12. `generate` 使用方式

- 從產品專案根目錄執行
- 支援 `single`、`multiple`、`all`
- 選擇文件時，可使用正式 key、常用別名、或編號
- 若不帶參數執行，會先進入模式編號選單，再進入文件編號選單

範例：

```bash
bash ./vibe-coding/vibe-starter/scripts/generate
bash ./vibe-coding/vibe-starter/scripts/generate single 0_project
bash ./vibe-coding/vibe-starter/scripts/generate single project
bash ./vibe-coding/vibe-starter/scripts/generate single 1
bash ./vibe-coding/vibe-starter/scripts/generate multiple glossary roles objects
bash ./vibe-coding/vibe-starter/scripts/generate multiple 2 role object
bash ./vibe-coding/vibe-starter/scripts/generate all
```

互動模式流程：

1. 先選模式
   - `1` 單一
   - `2` 多個
   - `3` 全部
2. 若選 `1` 或 `2`，再從文件編號清單選擇目標文件

目前可用的文件 key / 別名 / 編號：

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
