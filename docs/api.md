# 后端接口清单（app/controller）

> 由 `route/app.php` 路由定义整理。鉴权标注：
> - **公开**：未挂任何中间件
> - **登录**：需 `JwtAuth`（用户 token）；标注 `*` 的允许匿名（中间件 `allowAnonymous`，内部按 `user_key` 识别小程序身份）
> - **管理员**：需 `JwtAuth` + `AdminAuth`
>
> **内容模型**：图文/视频/论坛帖子统一为 `forum_posts` 一行（`type` 仅 `image_text`/`video`），全部由 `Post` 控制器 + `PostService` 读写。原 `Article` 控制器已废弃。

---

## Account.php — 账号绑定
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/account/list` | 账号绑定列表 | 登录 |
| POST | `/account/bind` | 绑定账号 | 登录 |
| POST | `/account/unbind` | 解绑账号 | 登录 |

## AdminDashboard.php — 后台仪表盘/统计（原 Admin.php 改名）
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/admin/dashboard` | 仪表盘数据 | 管理员 |
| GET | `/admin/stats` | 系统统计 | 管理员 |
| GET | `/admin/visit-trend` | 访问趋势 | 管理员 |
| GET | `/admin/user-trend` | 用户增长趋势 | 管理员 |
| GET | `/admin/popular-pages` | 热门页面 | 管理员 |
| GET | `/admin/system-info` | 系统信息 | 管理员 |

## Appeal.php — 违规申诉
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/appeal/list` | 申诉列表 | 登录 |
| GET | `/appeal/targets` | 可申诉的内容 | 登录 |
| POST | `/appeal/create` | 提交申诉 | 登录 |
| POST | `/appeal/cancel/:id` | 取消申诉 | 登录 |

## Auth.php — 用户令牌
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/auth/profile` | 获取用户信息 | 登录 |
| POST | `/auth/refresh` | 刷新 token | 登录 |
| POST | `/auth/logout` | 用户登出 | 登录 |

## Board.php — 论坛板块
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/board/list` | 板块列表 | 公开 |
| GET | `/board/detail` | 板块详情 | 公开 |
| POST | `/board/join` | 加入/退出板块 | 登录 |
| POST | `/board/follow` | 关注/取消关注版主 | 登录 |
| GET | `/board/admin-list` | 板块列表（含禁用） | 管理员 |
| POST | `/board/create` | 创建板块 | 管理员 |
| POST | `/board/update/:id` | 更新板块 | 管理员 |
| DELETE | `/board/delete/:id` | 删除板块 | 管理员 |
| POST | `/board/status/:id` | 更新板块状态 | 管理员 |

## Certification.php — 实名认证
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| POST | `/certify/submit` | 提交认证申请 | 登录 |
| GET | `/certify/mine` | 我的认证状态 | 登录 |
| GET | `/certify/list` | 认证申请列表 | 管理员 |
| POST | `/certify/review` | 审核通过/驳回 | 管理员 |
| GET | `/certify/status` | 认证状态查询 | 公开 |

## Contact.php — 联系/留言（已修复越权：登录接口仅登录组）
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/contact/info` | 联系信息 | 公开 |
| POST | `/contact/message` | 提交留言 | 公开 |
| POST | `/contact/update` | 更新联系信息 | 登录 |
| GET | `/contact/messages` | 留言列表 | 登录 |
| POST | `/contact/read/:id` | 标记已读 | 登录 |
| POST | `/contact/deleteMessage` | 删除留言 | 登录 |
| GET | `/contact/stats` | 留言统计 | 登录 |
| POST | `/contact/batch-read` | 批量已读 | 登录 |
| POST | `/contact/batch-delete` | 批量删除 | 登录 |

## Creator.php — 创作者数据看板
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/creator/overview` | 概览 | 登录 |
| GET | `/creator/content-stats` | 内容数据 | 登录 |
| GET | `/creator/fans` | 粉丝画像 | 登录 |
| GET | `/creator/announcements` | 官方公告 | 登录 |

## Earning.php — 收益/提现/付费订单
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/earning/overview` | 收益概览 | 登录 |
| GET | `/earning/trend` | 收益趋势 | 登录 |
| GET | `/earning/withdraw-list` | 提现记录 | 登录 |
| POST | `/earning/apply-withdraw` | 申请提现 | 登录 |
| GET | `/earning/orders` | 付费订单 | 登录 |

## Follow.php — 关注
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| POST | `/follow/toggle` | 关注/取消关注 | 登录 |
| GET | `/follow/status` | 查询关注状态 | 登录 |

## Forum.php — 论坛首页聚合
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/forum/hot-topics` | 热门话题 | 公开 |
| GET | `/forum/recommended` | 推荐阅读 | 公开 |
| GET | `/forum/active-authors` | 活跃作者 | 公开 |

## Index.php — 默认页
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/` | 首页 | 公开 |

## Menu.php — 后台角色与菜单
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/admin/menu` | 后台菜单 | 管理员 |
| GET | `/admin/roles` | 角色列表 | 管理员 |
| POST | `/admin/roles` | 角色新增/更新 | 管理员 |
| DELETE | `/admin/roles/:id` | 角色删除 | 管理员 |
| GET | `/admin/menus` | 菜单列表 | 管理员 |
| POST | `/admin/menus` | 菜单新增/更新 | 管理员 |
| DELETE | `/admin/menus/:id` | 菜单删除 | 管理员 |

## Message.php — 站内私信
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/message/conversations` | 会话列表 | 登录 |
| GET | `/message/messages` | 会话消息 | 登录 |
| POST | `/message/send` | 发送私信 | 登录 |
| GET | `/message/unread-count` | 未读总数 | 登录 |

## Pay.php — 虚拟支付
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/pay/goods` | 道具列表 | 登录 |
| GET | `/pay/status` | 订单状态 | 登录 |
| POST | `/pay/order` | 下单 | 登录 |
| GET | `/pay/wallet` | 钱包余额 | 登录 |
| POST | `/pay/query` | 查单 | 管理员 |
| GET\|POST | `/pay/notify` | 发货回调 | 公开 |

## Post.php — 内容（帖子）统一接口（吸收原 Article 能力）
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/post/list` | 帖子列表（板块/分类/关键词/精华/排序） | 公开 |
| GET | `/post/detail/:id` | 详情（正文/评论/点赞态/付费态；作者/管理员可见任意状态） | 公开 |
| GET | `/post/comments/:id` | 评论列表 | 公开 |
| GET | `/post/poster-code` | 分享小程序码 | 公开 |
| POST | `/post/create` | 论坛发帖（默认 approved） | 登录 |
| POST | `/post/upload-image` | 图片上传（→/static/images/forum/） | 登录 |
| POST | `/post/upload-video` | 视频上传（→/static/videos/article/） | 登录 |
| POST | `/post/like` | 点赞/取消 | 登录 |
| POST | `/post/comment` | 发表评论 | 登录 |
| POST | `/post/buy` | 金币购买解锁 | 登录 |
| POST | `/post/report` | 举报 | 登录 |
| POST | `/post/save` | 创作者新建（submit=1→pending，否则 draft；必填 board_id） | 登录 |
| GET | `/post/creator-list` | 我的内容（默认排除草稿） | 登录 |
| GET | `/post/drafts` | 草稿箱 | 登录 |
| GET | `/post/categories` | 分类字典 | 登录 |
| POST | `/post/toggle-status/:id` | 上下架/重新提交（作者本人） | 登录 |
| POST | `/post/batch` | 批量下架/上架/提交/删除（作者本人） | 登录 |
| POST | `/post/update/:id` | 更新（作者本人或管理员；作者仅可改非 pending/approved） | 登录 |
| POST | `/post/delete/:id` | 删除（作者本人或管理员；作者仅可删非 pending/approved） | 登录 |
| GET | `/post/admin-list` | 全部内容（管理端） | 管理员 |
| POST | `/post/review/:id` | 审核通过/驳回 | 管理员 |

> `PostService`（`app/service/PostService.php`）承载所有 `forum_posts` 读写，禁止在控制器里再写直连逻辑。

## Search.php — 综合搜索
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/search` | 搜索内容/板块/用户 | 公开 |

## Setting.php — 系统设置/备份
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/setting/list` | 系统设置 | 管理员 |
| POST | `/setting/update` | 更新设置 | 管理员 |
| GET | `/setting/system-info` | 系统信息 | 管理员 |
| POST | `/setting/backup` | 备份数据 | 管理员 |
| POST | `/setting/restore` | 恢复数据 | 管理员 |
| POST | `/setting/clear-cache` | 清除缓存 | 管理员 |
| GET | `/setting/backup-list` | 备份列表 | 管理员 |
| DELETE | `/setting/backup/:filename` | 删除备份 | 管理员 |

## User.php — 用户（已修复越权：user/update 仅管理员组）
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/user/info` | 公开主页信息 | 公开 |
| GET | `/user/splash-data` | 启动页数据 | 公开 |
| GET | `/user/map-data` | 地图数据 | 公开 |
| POST | `/user/save-info` | 保存微信用户信息 | 公开* |
| GET | `/user/get-info` | 获取微信用户信息 | 公开* |
| POST | `/user/update-stats` | 更新用户统计 | 公开* |
| POST | `/user/upload-avatar` | 上传头像 | 公开* |
| POST | `/user/upload-cover` | 上传封面（需登录） | 登录 |
| GET | `/user/list` | 用户列表 | 管理员 |
| POST | `/user/create` | 新建用户 | 管理员 |
| POST | `/user/update` | 更新用户（角色/状态）——**仅管理员** | 管理员 |
| POST | `/user/delete` | 删除用户 | 管理员 |

## UserReviewAdmin.php — 后台审核（原 User.php 拆分）
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/admin/covers` | 封面审核列表 | 管理员 |
| POST | `/admin/cover-review` | 封面审核通过/驳回 | 管理员 |
| GET | `/admin/profile-reviews` | 资料审核列表 | 管理员 |
| POST | `/admin/profile-review` | 资料审核通过/驳回 | 管理员 |

## Visit.php — 访问统计
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| POST | `/visit/log` | 记录访问 | 公开 |
| GET | `/visit/stats` | 访问统计 | 公开 |
| GET | `/visit/trend` | 访问趋势 | 公开 |
| GET | `/visit/realtime` | 实时数据 | 公开 |
| GET | `/visit/geo` | 地理位置统计 | 公开 |

## WechatAuth.php — 微信登录（已拆分后台登录到 AdminAuth）
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| POST | `/wechat/login` | 微信登录 | 公开 |
| POST | `/wechat/complete-info` | 完善用户信息 | 公开 |
| GET | `/wechat/verify-token` | 验证 token | 公开 |
| POST | `/wechat/scan-confirm` | 小程序确认后台扫码登录 | 公开 |

## AdminAuth.php — 后台登录（从 WechatAuth 拆分）
| 方法 | 接口 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/admin/captcha` | 图形验证码 | 公开 |
| POST | `/admin/password-login` | 管理员密码登录 | 公开 |
| POST | `/admin/scan-ticket` | 创建扫码票据+小程序码 | 公开 |
| GET | `/admin/scan-status` | 轮询扫码状态 | 公开 |

---

共 **23 个控制器文件**（含新增 `AdminDashboard`/`UserReviewAdmin`/`AdminAuth`、删除 `Article`），约 **130 个接口**。
