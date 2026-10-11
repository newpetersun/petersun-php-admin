# 前端影响清单（后端重构 P0/P1 对应）

> 背景：本次后端重构把「创作者图文/视频」与「论坛帖子」统一为 `forum_posts` 一张表，
> 废弃 `Article` 控制器，所有内容接口收拢到 `Post`；并修复了若干越权/命名问题。
> 后端 URL 路径基本保持不变（仅 `/article/*` 被移除），管理端登录/审核控制器改名不影响 URL。
>
> 结论：**uni-app（论坛）几乎零改动**；**molu-admin（创作者中心）需要把 `/article/*` 切换到 `/post/*` 并补「板块选择」**；管理端前端无需改动。

---

## 一、molu-admin 创作者中心（必须改）

原 `/article/*` 已删除，全部改调 `/post/*`：

| 原接口 | 新接口 | 变化 / 注意点 |
|---|---|---|
| `GET /article/list` | `GET /post/creator-list` | query：`type`(image_text\|video)、`status`、`keyword`、`page`、`limit`；默认排除草稿 |
| `GET /article/drafts` | `GET /post/drafts` | 返回 `words`（字数）、`updatedAt` |
| `GET /article/detail/:id` | `GET /post/detail/:id` | **现在支持查看自己非 approved 的内容**（草稿/待审/驳回），便于编辑 |
| `POST /article/save` | `POST /post/save` | **新增必填 `board_id`**；`submit=1` 提交审核(pending)，否则存草稿(draft) |
| `POST /article/update/:id` | `POST /post/update/:id` | 作者仅可编辑 非 pending/approved 的内容；支持 `cover_images`/`video_url`/`duration`/`category` |
| `DELETE /article/delete/:id` | `POST /post/delete/:id` | 作者仅可删除 非 pending/approved 的内容（需先下架） |
| `POST /article/toggle-status/:id` | `POST /post/toggle-status/:id` | 状态流转：approved↔offline、draft/rejected→pending |
| `POST /article/batch` | `POST /post/batch` | `action`：`offline`/`approve`/`submit`/`delete`；`ids` 数组 |
| `GET /article/categories` | `GET /post/categories` | 分类字典（沿用 `article_categories`） |
| `POST /article/upload-video` | `POST /post/upload-video` | 字段名 `file` |
| `POST /article/upload-image` | `POST /post/upload-image` | 统一保存到 `/static/images/forum/`（原 article 目录不再使用） |
| `GET /article/admin-list` | `GET /post/admin-list` | 管理端 |
| `POST /article/review/:id` | `POST /post/review/:id` | 管理端：`action`=approve/reject，`reject` 必填 `reason` |

### 必须新增的 UI/逻辑
1. **板块选择**：编辑器必须让用户选择 `board_id`（板块）。原 Article 不强制板块，现在 `board_id` 是必填，不传会返回 `400 所属板块不能为空`。
2. **5 态状态机**：发布流程应区分「存草稿」(`submit` 不传) 与「提交审核」(`submit=1`→pending)。创作者中心需展示 `statusText` / `rejectReason`。
3. **统一响应字段**（`PostService::formatPost`，camelCase）：
   - 列表/详情统一返回：`id, type, typeText, title, summary, cover(首图), coverImages(数组), category, tags[], author, authorAvatar, userId, createdAt, updatedAt, views, comments, likes, isEssence, isPinned, isPaid, coinPrice, price, duration, videoUrl, status, statusText, rejectReason, auditTime`。
   - 详情额外：`content`（付费未解锁时为空）、`purchased`、`liked`、`comments[]`。
   - molu-admin「我的图文/视频」页面应适配 `cover` / `statusText` / `rejectReason` / `typeText` / `duration` / `videoUrl`。

---

## 二、uni-app（论坛）—— 基本零改动，注意 3 点

所有 `/post/*` 接口保留且行为不变。需确认/微调：

1. **权限加固**：`POST /post/update/:id`、`POST /post/delete/:id` 现在要求「作者本人或管理员」。确认 uni-app 只在作者本人操作自己的帖子时调用，否则返回 `403`。
   （此前任意登录用户可删改任意帖子，属越权 bug，本次已修复。）
2. **新增校验**：发帖/发布现校验 `title` ≤ 60 字、`content` 非空、`tags` ≤ 10 个、付费内容 `is_paid=1` 时 `coin_price>0`。若前端传参越界会被 `400` 拒绝。
3. **已发布内容编辑受限**：作者现不可直接编辑/删除「审核中(pending)/已发布(approved)」的帖子，需先下架(offline)。若 uni-app 有「编辑已发布帖」流程需调整为先下架。

---

## 三、管理端前端 —— 无需改动

以下仅**控制器类名**变化，**URL 路径不变**，前端无需改：

| URL（不变） | 旧控制器 | 新控制器 |
|---|---|---|
| `/admin/dashboard`、`/admin/stats`、`/admin/visit-trend`、`/admin/user-trend`、`/admin/popular-pages`、`/admin/system-info` | `Admin` | `AdminDashboard` |
| `/admin/covers`、`/admin/cover-review`、`/admin/profile-reviews`、`/admin/profile-review` | `User` | `UserReviewAdmin` |
| `/admin/captcha`、`/admin/password-login`、`/admin/scan-ticket`、`/admin/scan-status` | `WechatAuth` | `AdminAuth` |

---

## 四、数据/库表备注（非前端，供参考）

- `articles` 表现在已**无任何代码读写**，属于孤儿表。是否从 `sundongliang.sql` 删除由你决定（建议保留以兼容历史导入，或单独迁移脚本清理）。
- `sundongliang.sql` 中 `forum_posts` 的种子数据存在历史错乱：第 370 行把标题 `'Java入门简介'` 写进了 `type` 列（与现表列序不一致）。运行库不受影响，仅 SQL 导入时会报错，建议修正该行或移除非必要种子。
- `article_categories` 表仍被 `POST /post/categories` 读取，保留。
