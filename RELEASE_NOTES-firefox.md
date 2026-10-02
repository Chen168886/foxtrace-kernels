# FoxTrace Firefox 155.0 内核

FoxTrace 双端环境管理器配套的定制 Firefox 内核，基于 Mozilla Firefox 155.0 源码自编译。

## 构建信息

| 项目 | 值 |
| --- | --- |
| 内核版本 | Firefox 155.0 |
| 压缩包 | `Firefox-155.0-win64-20261002.zip` |
| 压缩包大小 | 134838608 字节（约 128.6 MB） |
| 解压后体积 | 约 340 MB，顶层目录 `firefox155\` |
| BuildID | `20261002165256`（application.ini） / `20261002172050`（platform.ini） |
| 编译来源 | Mozilla Firefox 155.0 源码自编译（SourceStamp `21a0961191033207dc167b842f6c251f337b0e54`） |
| 附带驱动 | geckodriver 0.37.1（与内核版本匹配） |
| 完整性校验 | 见附件 `SHA256SUMS-firefox.txt` |

## 安装方法

把 zip 解压到 **XiTrace 管理器 exe 所在目录**，与管理器 exe 同级，得到 `firefox155\` 目录：

```
XiTrace 管理器目录\
├─ XiTrace.exe
├─ firefox155\
│   ├─ firefox.exe
│   └─ geckodriver.exe
└─ ...
```

也可在管理器内新建 / 编辑测试环境时点「下载内核」一键安装。

## 新版变化

- 内核重新编译，BuildID 更新为 `20261002165256`。
- 提供 geckodriver 0.37.1，与内核版本匹配。

## 其他说明

- 本内核为自编译定制版本，随包驱动与内核版本匹配，**请勿混用**官方浏览器驱动。
- 系统要求：Windows 10 / 11 64 位；无需额外安装运行库（VC 运行库已随包附带）。
- 国内下载缓慢时，可在直链前拼接加速前缀，例如：
  `https://gh-proxy.com/https://github.com/Chen168886/foxtrace-kernels/releases/download/firefox-155.0/Firefox-155.0-win64-20261002.zip`
- 校验：`SHA256 = 277549F0067727966DCCF558B3AE1BDA9BB1A312108BEA009464C62A0EB7EA63`
