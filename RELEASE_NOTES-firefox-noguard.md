FoxTrace 双端环境管理器配套的定制 Firefox 内核 —— **无内核守卫版本**。

> ⚠️ **本版本去除了内核启动守卫（无授权校验）。** 下载解压即可直接运行，不依赖 FoxTrace 管理器授权状态。
> 需要带授权保护的版本请使用 `Firefox-155.0-win64-20260915b.zip`（Release tag `firefox-155.0`）。

## 构建信息

| 项目 | 值 |
| --- | --- |
| 内核版本 | Firefox 155.0 |
| 压缩包 | `Firefox-155.0-win64-20261002-noguard.zip` |
| 压缩包大小 | 约 128.6 MB |
| 解压后体积 | 约 340 MB，顶层目录 `firefox155\` |
| BuildID | `20261002165256`（application.ini） / `20261002172050`（platform.ini） |
| 编译来源 | Mozilla Firefox 155.0 源码自编译 |
| 附带驱动 | geckodriver 0.37.1（与内核版本匹配） |
| 完整性校验 | 见附件 `SHA256SUMS-firefox-noguard.txt` |

## 本版本（无内核守卫）与守卫版的区别

| | 无内核守卫版本（本页） | 带守卫版本（20260915b） |
| --- | --- | --- |
| 内核启动授权校验 | **已移除** | 内建（签名租约 + 一次性启动票据） |
| 是否必须配合管理器 | 否，可独立启动 | 是，且必须为同期版本管理器 |
| `browser_key` 凭据文件 | 不需要 | 需要（管理器自动下发） |
| 适用场景 | 自用 / 调试 / 二次开发 / 需要独立启动内核 | 对外分发、需要防拷贝授权 |

技术上：守卫代码原本内联在 `browser/app/nsBrowserApp.cpp` 的 `main()` 中，本版本已将该文件还原为 Mozilla 上游原版后**重新编译整个内核**，二进制中不再包含任何守卫特征串（`foxtrace` / `FTL1` / `foxtrace-mid-v1` 等）与内置公钥。

## 安装方法

把 zip 解压到 **FoxTrace 管理器 exe 所在目录**，与管理器 exe 同级，得到 `firefox155\` 目录：

```
FoxTrace 管理器目录\
├─ XiTrace.exe（管理器）
├─ firefox155\
│   ├─ firefox.exe
│   └─ geckodriver.exe
└─ ...
```

也可在管理器内新建 / 编辑测试环境时点「下载内核」一键安装。

## 其他说明

- 本内核为自编译定制版本，随包驱动与内核版本匹配，**请勿混用**官方浏览器驱动。
- 系统要求：Windows 10 / 11 64 位；无需额外安装运行库（VC 运行库已随包附带）。
- 国内下载缓慢时，可在直链前拼接加速前缀，例如：
  `https://gh-proxy.com/https://github.com/Chen168886/foxtrace-kernels/releases/download/<tag>/Firefox-155.0-win64-20261002-noguard.zip`
- 校验：`SHA256 = 277549F0067727966DCCF558B3AE1BDA9BB1A312108BEA009464C62A0EB7EA63`
