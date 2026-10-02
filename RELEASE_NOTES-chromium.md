# FoxTrace Chromium 154.0 内核

FoxTrace 双端环境管理器配套的定制 Chromium 内核，基于 Chromium 154.0.8037.0 源码自编译。

## 构建信息

| 项目 | 值 |
| --- | --- |
| 内核版本 | Chromium 154.0.8037.0 |
| 压缩包 | `FoxChrome-154.0.8037.0-win64-20261002.zip` |
| 压缩包大小 | 286438872 字节（约 273.2 MB） |
| 解压后体积 | 约 715 MB（511 个文件），顶层目录 `chromium154\` |
| 编译来源 | Chromium 154.0.8037.0 源码自编译（HEAD `e967b7961d80199276ce493904c95f5fbbc42fca`） |
| 附带驱动 | chromedriver 154.0.8037.0（与内核同源编译，版本匹配） |
| 完整性校验 | 见附件 `SHA256SUMS-chromium.txt` |

## 安装方法

把 zip 解压到 **XiTrace 管理器 exe 所在目录**，与管理器 exe 同级，得到 `chromium154\` 目录：

```
XiTrace 管理器目录\
├─ XiTrace.exe
├─ chromium154\
│   ├─ chrome.exe
│   ├─ FoxChrome.exe
│   └─ chromedriver.exe
└─ ...
```

也可在管理器内新建 / 编辑测试环境时点「下载内核」一键安装。

## 新版变化

- 内核重新编译，版本 154.0.8037.0。
- 提供 chromedriver 154.0.8037.0，与内核同源编译、版本匹配。

## 其他说明

- `FoxChrome.exe` 是 `chrome.exe` 的改名副本（部分安全软件会按文件名拦截非系统目录下未签名的 `chrome.exe`，改名副本不受影响）；两者同时存在时管理器优先使用 `FoxChrome.exe`。
- 本内核为自编译定制版本，随包驱动与内核版本匹配，**请勿混用**官方浏览器驱动。
- 系统要求：Windows 10 / 11 64 位；无需额外安装运行库（VC 运行库已随包附带）。
- 国内下载缓慢时，可在直链前拼接加速前缀，例如：
  `https://gh-proxy.com/https://github.com/Chen168886/foxtrace-kernels/releases/download/chromium-154.0/FoxChrome-154.0.8037.0-win64-20261002.zip`
- 校验：`SHA256 = ACCCA5CCB1BAF80D7F402037BD5C27C8C02333FE3CF4686EA9F1D2AC58C75DFB`
