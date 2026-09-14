@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
cd /d "%~dp0"
title FoxTrace 内核发布工具

echo ============================================================
echo   FoxTrace 内核一键发布到 GitHub
echo   本脚本可以反复运行，已完成的步骤会自动跳过
echo ============================================================
echo.
echo   【发布前必读】
echo   1) Firefox 内核含启动授权保护，打包前务必确认内核目录里
echo      没有 browser_key 之类的凭据文件，否则等于把钥匙一起发出去。
echo   2) 内核与服务端必须成对发布：新内核只认新版管理器，单边升级
echo      会让所有环境启动即退出。
echo.

if not exist "..\release-assets\FoxChrome-154.0.8037.0-win64.zip" (
    echo [错误] 找不到 ..\release-assets\FoxChrome-154.0.8037.0-win64.zip
    goto fail
)
if not exist "..\release-assets\Firefox-155.0-win64-20260915.zip" (
    echo [错误] 找不到 ..\release-assets\Firefox-155.0-win64-20260915.zip
    goto fail
)

REM ===== step 1/6 GitHub CLI =====
set "GH="
where gh >nul 2>nul
if not errorlevel 1 (
    for /f "delims=" %%i in ('where gh') do if not defined GH set "GH=%%i"
)
if not defined GH if exist "C:\Program Files\GitHub CLI\gh.exe" set "GH=C:\Program Files\GitHub CLI\gh.exe"
if defined GH goto gh_ready
echo [步骤 1/6] 未检测到 GitHub CLI，正在自动安装，弹出的系统确认窗口请点“是”...
winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements
if exist "C:\Program Files\GitHub CLI\gh.exe" set "GH=C:\Program Files\GitHub CLI\gh.exe"
if not defined GH (
    echo [错误] GitHub CLI 自动安装失败，请到 https://cli.github.com 手动安装后重跑
    goto fail
)
:gh_ready
echo [步骤 1/6] GitHub CLI 就绪
echo.

REM ===== step 2/6 git =====
where git >nul 2>nul
if not errorlevel 1 goto git_ready
if exist "C:\Program Files\Git\cmd\git.exe" (
    set "PATH=%PATH%;C:\Program Files\Git\cmd"
    goto git_ready
)
if exist "%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\cmd\git.exe" (
    set "PATH=%PATH%;%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\cmd"
    goto git_ready
)
echo [步骤 2/6] 未检测到 git，正在自动安装 Git for Windows，弹出的系统确认窗口请点“是”...
winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements
if exist "C:\Program Files\Git\cmd\git.exe" (
    set "PATH=%PATH%;C:\Program Files\Git\cmd"
    goto git_ready
)
echo [错误] git 自动安装失败，请到 https://git-scm.com/download/win 手动安装后重跑
goto fail
:git_ready
echo [步骤 2/6] git 就绪
echo.

REM ===== step 3/6 login GitHub =====
"!GH!" auth status >nul 2>nul
if not errorlevel 1 goto login_ready
echo [步骤 3/6] 需要登录 GitHub 账号，整个过程约 1 分钟，流程如下：
echo.
echo     1. 窗口会显示一个 8 位一次性代码，例如 ABCD-1234，先复制它
echo     2. 按回车，浏览器会自动打开 github.com/login/device
echo        没有自动打开就自己在浏览器输入这个网址
echo     3. 浏览器里如果要求登录 GitHub，就正常登录你的账号
echo     4. 粘贴 8 位代码，点 Continue，再点 Authorize github
echo     5. 窗口出现 Authentication complete 即成功
echo.
echo     说明：这是 GitHub 官方的设备授权流程，不是中毒也不是授权过期；
echo     代码 15 分钟内有效，过期了重跑本脚本会自动换新的；
echo     中途窗口提问一律直接按回车。
echo.
pause
"!GH!" auth login --hostname github.com --git-protocol https --web
"!GH!" auth status >nul 2>nul
if errorlevel 1 (
    echo [错误] 登录未完成，重新双击本脚本再试一次
    goto fail
)
:login_ready
echo [步骤 3/6] GitHub 已登录
echo.

REM ===== step 4/6 account =====
"!GH!" api user --jq .login > "%TEMP%\foxtrace_gh_user.txt" 2>nul
if errorlevel 1 (
    echo [错误] 无法获取 GitHub 用户名，请稍后重跑本脚本
    goto fail
)
set "GH_USER="
set /p GH_USER=<"%TEMP%\foxtrace_gh_user.txt"
del "%TEMP%\foxtrace_gh_user.txt" >nul 2>nul
if not defined GH_USER (
    echo [错误] 无法读取 GitHub 用户名
    goto fail
)
echo [步骤 4/6] GitHub 账号：!GH_USER!
echo.

REM ===== step 5/6 repo and push =====
"!GH!" repo view "!GH_USER!/foxtrace-kernels" >nul 2>nul
if errorlevel 1 (
    echo [步骤 5/6] 创建公开仓库 !GH_USER!/foxtrace-kernels 并推送...
    "!GH!" repo create foxtrace-kernels --public --source=. --remote=origin --push
    if errorlevel 1 (
        echo [错误] 创建仓库失败
        goto fail
    )
) else (
    echo [步骤 5/6] 仓库已存在，同步最新文件...
    git remote get-url origin >nul 2>nul
    if errorlevel 1 git remote add origin "https://github.com/!GH_USER!/foxtrace-kernels.git"
    git add -A
    git commit -m "Update kernel files" >nul 2>nul
    git push -u origin HEAD
    if errorlevel 1 (
        echo [错误] 推送失败
        goto fail
    )
)
echo [步骤 5/6] 代码已推送
echo.

REM ===== step 6/6 upload kernels =====
"!GH!" release view chromium-154.0.8037.0 -R "!GH_USER!/foxtrace-kernels" --json assets --jq ".assets[].name" 2>nul | findstr /C:"FoxChrome-154.0.8037.0-win64.zip" >nul
if not errorlevel 1 goto chrome_done
"!GH!" release view chromium-154.0.8037.0 -R "!GH_USER!/foxtrace-kernels" >nul 2>nul
if errorlevel 1 (
    echo [步骤 6/6] 正在上传 Chrome 内核 274MB，需要几分钟，请勿关闭窗口...
    "!GH!" release create chromium-154.0.8037.0 -R "!GH_USER!/foxtrace-kernels" "..\release-assets\FoxChrome-154.0.8037.0-win64.zip" "..\release-assets\SHA256SUMS-chrome.txt" --title "FoxChrome 154.0.8037.0 Chromium kernel" --notes "FoxTrace Chrome kernel. Chromium 154.0.8037.0 custom build, bundled chromedriver. Extract next to the FoxTrace manager exe."
) else (
    echo [步骤 6/6] Chrome Release 已存在，补传内核文件...
    "!GH!" release upload chromium-154.0.8037.0 -R "!GH_USER!/foxtrace-kernels" "..\release-assets\FoxChrome-154.0.8037.0-win64.zip" "..\release-assets\SHA256SUMS-chrome.txt" --clobber
)
if errorlevel 1 (
    echo [错误] Chrome 内核上传失败，重跑本脚本即可续传
    goto fail
)
:chrome_done
echo [步骤 6/6] Chrome 内核完成
echo.
"!GH!" release view firefox-155.0 -R "!GH_USER!/foxtrace-kernels" --json assets --jq ".assets[].name" 2>nul | findstr /C:"Firefox-155.0-win64-20260915b.zip" >nul
if not errorlevel 1 (
    echo [步骤 6/6] 本版本 Firefox 内核已上传，跳过上传
    goto firefox_sync
)
"!GH!" release view firefox-155.0 -R "!GH_USER!/foxtrace-kernels" >nul 2>nul
if errorlevel 1 (
    echo [步骤 6/6] 正在上传 Firefox 内核 128MB，需要几分钟，请勿关闭窗口...
    "!GH!" release create firefox-155.0 -R "!GH_USER!/foxtrace-kernels" "..\release-assets\Firefox-155.0-win64-20260915b.zip" "..\release-assets\SHA256SUMS-firefox.txt" --title "FoxTrace Firefox 155.0 内核（含启动授权保护）" --notes-file "RELEASE_NOTES-firefox.md"
) else (
    echo [步骤 6/6] Firefox Release 已存在，补传内核文件...
    "!GH!" release upload firefox-155.0 -R "!GH_USER!/foxtrace-kernels" "..\release-assets\Firefox-155.0-win64-20260915b.zip" "..\release-assets\SHA256SUMS-firefox.txt" --clobber
)
if errorlevel 1 (
    echo [错误] Firefox 内核上传失败，重跑本脚本即可续传
    goto fail
)
:firefox_sync
echo [步骤 6/6] 同步发布说明...
"!GH!" release edit firefox-155.0 -R "!GH_USER!/foxtrace-kernels" --title "FoxTrace Firefox 155.0 内核（含启动授权保护）" --notes-file "RELEASE_NOTES-firefox.md" >nul 2>nul
echo [步骤 6/6] 清除历史上的无授权内核资产（如存在）...
"!GH!" release delete-asset firefox-155.0 "Firefox-155.0-win64.zip" -R "!GH_USER!/foxtrace-kernels" --yes >nul 2>nul
:firefox_done
echo [步骤 6/6] Firefox 内核完成
echo.

echo ============================================================
echo   全部完成，可以发给客户了
echo.
echo   下载页：
echo   https://github.com/!GH_USER!/foxtrace-kernels/releases
echo.
echo   Chrome 内核直链：
echo   https://github.com/!GH_USER!/foxtrace-kernels/releases/download/chromium-154.0.8037.0/FoxChrome-154.0.8037.0-win64.zip
echo.
echo   Firefox 内核直链：
echo   https://github.com/!GH_USER!/foxtrace-kernels/releases/download/firefox-155.0/Firefox-155.0-win64.zip
echo ============================================================
start "" "https://github.com/!GH_USER!/foxtrace-kernels/releases"
pause
exit /b 0

:fail
echo.
pause
exit /b 1
