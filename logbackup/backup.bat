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

rem workディレクトリクリーニング
del .\work\iis\*.log
if exist .\work\iis\*.log (
    echo 削除失敗: 
) else (
    echo 削除成功: 
)

rem バックアップ対象ファイル、最新1件を取得
for /f %%i in ('dir .\input\iis_access\ /b /on') do set target=.\input\iis_access\%%i
echo バックアップ対象: %target%


rem workディレクトリへコピー
copy %target% .\work\iis\

echo -------------------
echo %errorlevel%
echo -------------------




rem クリーニング対象一覧表示
for /f "skip=7" %%i in ('dir .\input\iis_access\ /b /on') do echo %%i

rem クリーニング
for /f "skip=7" %%i in ('dir .\input\iis_access\ /b /on') do ( 
    del .\input\iis_access\%%i

    rem delコマンドはerrorlevel判定ができないので、ファイルが存在するかで判定する
    rem ファイルを「読み取り専用」にするとエラー発生可能
    if exist .\input\iis_access\%%i (
        echo 削除失敗: %%i
    ) else (
        echo 削除成功: %%i
    )
)