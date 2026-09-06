@echo off
rem One-shot publisher for the foxtrace-kernels repo.
rem Creates the public GitHub repo, pushes, and uploads both kernel zips as releases.
setlocal
cd /d "%~dp0"

echo [1/5] Checking GitHub CLI...
where gh >nul 2>nul
if errorlevel 1 (
  echo GitHub CLI not found, installing via winget...
  winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements
  if errorlevel 1 (
    echo Failed to install GitHub CLI automatically.
    echo Install it from https://cli.github.com then run this script again.
    pause
    exit /b 1
  )
  set "PATH=%PATH%;%ProgramFiles%\GitHub CLI"
  where gh >nul 2>nul
  if errorlevel 1 (
    echo gh still not on PATH. Open a NEW terminal and run this script again.
    pause
    exit /b 1
  )
)

echo [2/5] Checking GitHub login...
gh auth status >nul 2>nul
if errorlevel 1 (
  echo Not logged in. A browser window will open - finish the login, then come back.
  gh auth login --web --git-protocol https
  if errorlevel 1 (
    echo Login failed. Run "gh auth login" manually and retry.
    pause
    exit /b 1
  )
)

echo [3/5] Creating public repo foxtrace-kernels and pushing...
gh repo create foxtrace-kernels --public --source=. --remote=origin --push
if errorlevel 1 (
  echo repo create returned an error - maybe it already exists, trying plain push...
  git push -u origin HEAD
  if errorlevel 1 (
    echo Push failed.
    pause
    exit /b 1
  )
)

echo [4/5] Creating releases with kernel zips...
gh release create chromium-154.0.8037.0 "..\release-assets\FoxChrome-154.0.8037.0-win64.zip" "..\release-assets\SHA256SUMS.txt" --title "FoxChrome 154.0.8037.0 (Chromium kernel)" --notes "FoxTrace Chrome kernel - Chromium 154.0.8037.0 custom build. Extract next to the FoxTrace manager exe. SHA256: CA61F2E74EA94F2C60A0472C439FA1337EF1788D41B70B966EF26638D74C7DFE"
if errorlevel 1 (
  echo Chromium release failed.
  pause
  exit /b 1
)
gh release create firefox-155.0 "..\release-assets\Firefox-155.0-win64.zip" "..\release-assets\SHA256SUMS.txt" --title "Firefox 155.0 kernel" --notes "FoxTrace Firefox kernel - Firefox 155.0 custom build, includes geckodriver 0.37.1. Extract next to the FoxTrace manager exe. SHA256: B585BF3247E0CCDA0253BCA126E4F1FA8A0319ACB3BBE2DD85D5A1399D0387EC"
if errorlevel 1 (
  echo Firefox release failed.
  pause
  exit /b 1
)

echo [5/5] Done. Opening the repo page in your browser...
gh repo view --web
echo.
echo Customers can now download from:
echo   https://github.com/%USERNAME%/foxtrace-kernels/releases
pause
