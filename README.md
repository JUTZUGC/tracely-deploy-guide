# Tracely 一键部署指南

> 第三方部署指南 · 非 Tracely 官方仓库。官方项目：[jwuthri-cloud/Tracely-ai](https://github.com/jwuthri-cloud/Tracely-ai)
> 内容来自官方文档（2026-10-29）。项目迭代快，请以[官方文档](https://doc.tracely-ai.com)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 把线上 trace 变成可回放的测试：先评分，再把失败固化成回归用例，最后在 PR 上拦住退化。

⚠️ 需要 Docker 与 Docker Compose v2。demo profile 会构建并写入演示数据；默认 Web 端口 3001、后端 8000，可用 TRACELY_WEB_PORT / TRACELY_BACKEND_PORT 改。生产部署要自己配 .env、持久化与鉴权。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/tracely-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会检查 Docker Compose，拉取仓库后用 demo profile 构建并启动 Web、后端与 worker，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Docker；未安装时按对话提示安装。）

4. **打开管理面板**
   浏览器访问 [http://127.0.0.1:3001](http://127.0.0.1:3001)，按官方引导完成初始化配置。

## Tracely 是什么？

Tracely 是开源的面向 AI Agent 的 trace 原生 CI/CD：评分、聚类失败、冻结回归测试并拦住退化的 PR（协议：MIT，<img src="https://img.shields.io/github/stars/jwuthri-cloud/Tracely-ai?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

把 Agent 的运行 trace 当成一等公民：结构检查与 LLM 评审器打分，按失败聚类，冻结成可回放的回归测试，并在 PR 上阻断退化；同时提供 Python SDK 与 OTLP/HTTP 接入。

- 一条命令起全栈：Web、后端、worker 一起跑
- 评估器：结构检查 + LLM judge，多输出类型
- 失败聚类：把相似失败归并成可处理的问题
- 回归门禁：失败固化成测试，拦住退化 PR
- 接入灵活：Python SDK 或任意 OTLP/HTTP
- 可自托管：Docker Compose，数据在自己机器

（来源：[官方仓库](https://github.com/jwuthri-cloud/Tracely-ai)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 1.2k stars 10 月新项目 | 名称搜索仅 5 条结果 |
| 定位清晰 | trace 评分 + 回归门禁，不是又一个看板 |
| 一条命令起全栈 | 自带演示数据 |
| 接入方式多 | SDK、OTLP/HTTP 都行 |
| 可自托管 | 数据不离开自己的机器 |
| MIT 可商用可二开 | — |

| 需要注意 | 说明 |
|---|---|
| 需要 Docker 与 Compose 没有桌面版 | — |
| demo 构建慢 首次要拉镜像 | — |
| 生产化要自己补鉴权、持久化与备份 | — |
| 项目很新 接口与 UI 仍会变 | — |
| 不是开箱即用的 SaaS 没有托管服务 | — |

> 以上基于官方文档与社区反馈整理（2026-10-29），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/jwuthri-cloud/Tracely-ai.git
cd Tracely-ai
docker compose --profile demo up -d --build --wait
echo "已启动：http://127.0.0.1:3001 （后端 8000）"
```

启动后浏览器访问 [http://127.0.0.1:3001](http://127.0.0.1:3001)（管理面板）。（来源：[https://github.com/jwuthri-cloud/Tracely-ai#quickstart](https://github.com/jwuthri-cloud/Tracely-ai#quickstart)）

## 验证状态

| 场景 | 状态 |
|---|---|
| README Quickstart 确认 Docker Compose、demo profile、端口 3001 / 8000 | 已核对 2026-10-29 |
| README 确认 Python 3.10+ SDK 与 OTLP/HTTP 接入 | 已核对 2026-10-29 |
| 未实测 docker compose 构建与启动 | 说明 2026-10-29 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-10-29 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-29 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不含 MCP；本仓库的 MCP 只提供部署步骤、端口与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-29）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\tracely-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 启动与停止

```bash
docker compose --profile demo up -d --build --wait   # 启动
docker compose down                                  # 停止
docker compose down -v                               # 停止并清空数据
```

默认端口：Web 3001，后端 8000。改端口用环境变量：

```bash
TRACELY_WEB_PORT=4001 TRACELY_BACKEND_PORT=9000 docker compose --profile demo up -d
```

## 接入自己的 Agent

Python SDK：

```bash
pip install "tracelyai-sdk[openai]"
```

```python
import tracely_sdk as tracely

tracely.init(endpoint="http://127.0.0.1:8000", service_name="support-agent", env="prod")

with tracely.trace(agent="support-agent", conversation="conv-1", user="u_42"):
    ...
```

任何支持 OTLP/HTTP 的服务也可以直接打到 `POST /v1/traces`。

## 注意

- demo profile 适合试用，不要直接当生产环境
- 生产要配 `.env`、持久化存储、鉴权与备份
- 构建会拉镜像并编译前后端，第一次比较久
- 端口冲突时先改环境变量，再重启 compose

## 常见坑

- docker compose 不存在：升级 Docker Desktop，确认是 v2 子命令
- 端口被占：用 TRACELY_WEB_PORT / TRACELY_BACKEND_PORT 改
- 构建失败：先 docker compose build 看具体服务日志
- 页面能开但没有数据：确认用了 --profile demo 并等 --wait 结束
- 重启后数据没了：检查 volume 是否被 down -v 清掉
- SDK 打不进数据：确认 endpoint 指到后端 8000，且容器网络可达

## 免责声明

本仓库为第三方指南，与 Tracely 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-29），项目迭代快，请以[官方文档](https://doc.tracely-ai.com)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
