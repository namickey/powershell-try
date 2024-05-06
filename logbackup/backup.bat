@echo off
setlocal enabledelayedexpansion

echo -------バックアップ処理開始-------

echo -------env読み込み-------
call env.bat

echo -------チェック処理-------

rem ディレクトリ存在確認
if not exist %input_path% (
    echo エラー：input\iis_accessディレクトリが存在しません
    exit /b 1
)
if not exist .\work\iis\ (
    echo エラー：work\iisディレクトリが存在しません
    exit /b 1
)

if not exist .\output\iis\ (
    echo エラー：output\iisディレクトリが存在しません
    exit /b 1
)

rem ファイル存在確認
if not exist .\encrypt\share.key (
    echo エラー：.\encrypt\share.keyが存在しません
    exit /b 1
)
if not exist .\encrypt\share.iv (
    echo エラー：.\encrypt\share.ivが存在しません
    exit /b 1
)

echo -------復号処理-------

echo "参考:暗号化文字列":%enc_text%
FOR /F "usebackq" %%i IN (`powershell -executionpolicy Bypass -File .\encrypt\dec.ps1`) DO set value=%%i
if %value% equ 1 (
    echo 予期せぬエラー：復号処理呼び出し
    exit /b 1
)
echo "参考:復号済み文字列":%value%

echo -------NASマウント-------

rem ネットワークエラー等を考慮し、早めにマウント処理を実施
rem 未実装

echo -------work クリーニング処理-------

rem 異常終了時のファイル残存を考慮し、ファイルクリーニングを早めに実施
del .\work\iis\*.log
if exist .\work\iis\*.log (
    echo 失敗: workディレクトリ ファイルクリーニング 
) else (
    echo 成功: workディレクトリ ファイルクリーニング
)

echo -------「input」⇒「work」-------

for /f %%i in ('dir .\input\iis_access\*.log /a-d /b ^| find /c /v ""') do set num=%%i
echo inputファイル数: %num%
if not %num%==0 (
    rem バックアップ対象ファイルが存在した場合、最新ファイル名1件を取得する
    for /f %%i in ('dir .\input\iis_access\*.log /on /b') do set target=.\input\iis_access\%%i
    echo バックアップ対象:!target!
    
    rem 対象1件をworkディレクトリへコピー
    copy !target! .\work\iis\
    if %errorlevel% neq 0 (
        echo %errorlevel% 失敗: !target! ファイルコピー
        exit /b 1
    ) else (
        echo %errorlevel% 成功: !target! ファイルコピー
    )
) else (
    echo バックアップ対象ファイルが存在しません
    rem バックアップ対象が無くとも正常として扱い、以降の処理は継続する。
)

echo -------「work」⇒「output + 圧縮」-------

rem zipファイル名に使用するタイムスタンプ生成
set time2=%time: =0%
set timestamp=%date:~0,4%%date:~5,2%%date:~8,2%%time2:~0,2%%time2:~3,2%%time2:~6,2%
rem 日付のみのタイムスタンプ生成
set date=%date:~0,4%%date:~5,2%%date:~8,2%

rem workディレクトリにファイルが存在するか確認。ファイルが存在する場合のみzip圧縮する
for /f %%i in ('dir .\work\iis\*.log /a-d /b ^| find /c /v ""') do set num=%%i
echo "workファイル数":%num%
if not %num%==0 (
    echo workディレクトリにファイルが存在。
    echo ⇒圧縮処理を実施

    rem 対象フォルダをzip圧縮し、outputフォルダへ出力
    rem ファイル名にタイムスタンプ
    rem PowerShell -Command "Compress-Archive -Path .\work\iis\ -DestinationPath .\output\iis\iis_%timestamp%.zip -Force"
    rem ファイル名に日付
    PowerShell -Command "Compress-Archive -Path .\work\iis\ -DestinationPath .\output\iis\iis_%date%.zip -Force"
    if not exist .\output\iis\iis_%date%.zip (
        echo 失敗: .\work\iis\ ファイル圧縮
        exit /b 1
    ) else (
        echo 成功: .\work\iis\ ファイル圧縮
    )
) else (
    echo workディレクトリにファイルが存在しません。
    echo ⇒圧縮処理をスキップします。
    rem バックアップ対象が無くとも正常として扱い、以降の処理は継続する。
)

echo -------inputクリーニング処理-------

rem inputクリーニング対象一覧表示
for /f "skip=7" %%i in ('dir .\input\iis_access\*.log /b /o-n') do echo inputクリーニング対象:%%i

rem inputクリーニング
for /f "skip=7" %%i in ('dir .\input\iis_access\*.log /b /o-n') do (
    del .\input\iis_access\%%i
    rem delコマンドはerrorlevel判定ができないので、ファイルが存在するかで判定する
    rem ファイルを「読み取り専用」にするとエラー発生可能
    if exist .\input\iis_access\%%i (
        echo ⇒失敗: %%i inputファイルクリーニング
    ) else (
        echo ⇒成功: %%i inputファイルクリーニング
    )
)

echo -------outputクリーニング処理-------

rem outputクリーニング対象一覧表示
for /f "skip=10" %%i in ('dir .\output\iis\*.zip /b /o-n') do echo outputクリーニング対象:%%i

rem outputクリーニング
for /f "skip=10" %%i in ('dir .\output\iis\*.zip /b /o-n') do (
    del .\output\iis\%%i
    rem delコマンドはerrorlevel判定ができないので、ファイルが存在するかで判定する
    rem ファイルを「読み取り専用」にするとエラー発生可能
    if exist .\input\iis_access\%%i (
        echo ⇒失敗: %%i outputファイルクリーニング
    ) else (
        echo ⇒成功: %%i outputファイルクリーニング
    )
)

echo -------バックアップ処理終了-------
