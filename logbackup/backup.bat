@echo off

rem ディレクトリ存在確認
if not exist .\input\iis_access\ (
    echo エラー：input\iis_accessディレクトリが存在しません
    exit /b 1
)
if not exist .\work\iis\ (
    echo エラー：work\iisディレクトリが存在しません
    exit /b 1
)

rem workディレクトリ クリーニング
del .\work\iis\*.log
if exist .\work\iis\*.log (
    echo 失敗: workディレクトリ ファイルクリーニング 
) else (
    echo 成功: workディレクトリ ファイルクリーニング
)

rem バックアップ対象ファイル、最新1件を取得
for /f %%i in ('dir .\input\iis_access\ /b /on') do set target=.\input\iis_access\%%i
echo バックアップ対象: %target%


rem 対象1件をworkディレクトリへコピー
copy %target% .\work\iis\
if %errorlevel% neq 0 (
    echo %errorlevel% 失敗: %target% ファイルコピー
    exit /b 1
) else (
    echo %errorlevel% 成功: %target% ファイルコピー
)

set time2=%time: =0%
set timestamp=%date:~0,4%%date:~5,2%%date:~8,2%%time2:~0,2%%time2:~3,2%%time2:~6,2%

rem 対象フォルダを圧縮コピー
PowerShell -Command "Compress-Archive -Path .\work\iis\ -DestinationPath .\output\iis\iis_access_%timestamp%.zip -Force"

rem クリーニング対象一覧表示
for /f "skip=7" %%i in ('dir .\input\iis_access\ /b /on') do echo %%i

rem クリーニング
for /f "skip=7" %%i in ('dir .\input\iis_access\ /b /on') do (
    del .\input\iis_access\%%i
    rem delコマンドはerrorlevel判定ができないので、ファイルが存在するかで判定する
    rem ファイルを「読み取り専用」にするとエラー発生可能
    if exist .\input\iis_access\%%i (
        echo 失敗: %%i ファイル削除
    ) else (
        echo 成功: %%i ファイル削除
    )
)

echo バックアップ処理完了
