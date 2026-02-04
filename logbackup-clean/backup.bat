@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo -------クリーニング処理開始-------

echo -------env読み込み-------
call env.bat

echo -------チェック処理-------
rem ディレクトリ存在確認
if not exist .\iis_httperr\ (
    echo エラー：iis_httperrディレクトリが存在しません
    exit /b 1
)

echo -------クリーニング処理-------

forfiles /P "iis_httperr" /D -180 /C "cmd /c if @isdir==FALSE echo @path" >nul 2>&1
if !errorlevel! equ 0 (
    forfiles /P "iis_httperr" /D -180 /C "cmd /c if @isdir==FALSE del /q @path & echo 削除済みファイル：@path"
    forfiles /P "iis_httperr" /D -180 /C "cmd /c if @isdir==FALSE echo @path" >nul 2>&1
    if !errorlevel! equ 0 (
        echo %date% %time% [NG] ファイル削除に失敗しました。
        forfiles /P "iis_httperr" /D -180 /C "cmd /c echo 削除失敗ファイル：@path"
        exit /b 1
    ) else (
        echo %date% %time% [OK] ファイル削除に成功しました。
    )
) else (
    echo %date% %time% 削除対象ファイルなし
)

echo -------クリーニング処理終了-------
exit /b 0
