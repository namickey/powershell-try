@echo off
setlocal enabledelayedexpansion

echo -------�o�b�N�A�b�v�����J�n-------

rem env�ǂݍ���
call env.bat

echo -------�`�F�b�N����-------

rem �f�B���N�g�����݊m�F
if not exist %input_path% (
    echo �G���[�Finput\iis_access�f�B���N�g�������݂��܂���
    exit /b 1
)
if not exist .\work\iis\ (
    echo �G���[�Fwork\iis�f�B���N�g�������݂��܂���
    exit /b 1
)

rem �t�@�C�����݊m�F
if not exist .\encrypt\share.key (
    echo �G���[�F.\encrypt\share.key�����݂��܂���
    exit /b 1
)
if not exist .\encrypt\share.iv (
    echo �G���[�F.\encrypt\share.iv�����݂��܂���
    exit /b 1
)

echo -------��������-------

rem �Q�l�@���ϐ��\��
echo %enc_text%
rem ���������Ăяo��
FOR /F "usebackq" %%i IN (`powershell -executionpolicy Bypass -File .\encrypt\dec.ps1`) DO set value=%%i
if %value% equ 1 (
    echo �\�����ʃG���[�F���������Ăяo��
    exit /b 1
)
rem �Q�l�@�����ςݕ�����\��
echo dec:%value%:

echo -------work �N���[�j���O����-------

rem work�f�B���N�g�� �N���[�j���O
del .\work\iis\*.log
if exist .\work\iis\*.log (
    echo ���s: work�f�B���N�g�� �t�@�C���N���[�j���O 
) else (
    echo ����: work�f�B���N�g�� �t�@�C���N���[�j���O
)

echo -------�uinput�v�ˁuwork�v-------

for /f %%i in ('dir .\input\iis_access\*.log /a-d /b ^| find /c /v ""') do set num=%%i
echo input�t�@�C����: %num%
if not %num%==0 (
    rem �o�b�N�A�b�v�Ώۃt�@�C���A�ŐV1�����擾
    for /f %%i in ('dir .\input\iis_access\*.log /on /b') do set target=.\input\iis_access\%%i
    echo �o�b�N�A�b�v�Ώ�:!target!
    
    rem �Ώ�1����work�f�B���N�g���փR�s�[
    copy !target! .\work\iis\
    if %errorlevel% neq 0 (
        echo %errorlevel% ���s: !target! �t�@�C���R�s�[
        exit /b 1
    ) else (
        echo %errorlevel% ����: !target! �t�@�C���R�s�[
    )
) else (
    echo �o�b�N�A�b�v�Ώۃt�@�C�������݂��܂���
)

echo -------�uwork�v�ˁuoutput + ���k�v-------

rem zip�t�@�C�����Ɏg�p����^�C���X�^���v����
set time2=%time: =0%
set timestamp=%date:~0,4%%date:~5,2%%date:~8,2%%time2:~0,2%%time2:~3,2%%time2:~6,2%

rem work�f�B���N�g���Ƀt�@�C�������݂��邩�m�F�B�t�@�C�������݂���ꍇ�̂�zip���k����
for /f %%i in ('dir .\work\iis\*.log /a-d /b ^| find /c /v ""') do set num=%%i
echo work�t�@�C����: %num%
if not %num%==0 (
    echo work�f�B���N�g���Ƀt�@�C�������݁B
    echo �ˈ��k���������{

    rem �Ώۃt�H���_��zip���k���Aoutput�t�H���_�֏o��
    PowerShell -Command "Compress-Archive -Path .\work\iis\ -DestinationPath .\output\iis\iis_%timestamp%.zip -Force"
) else (
    echo work�f�B���N�g���Ƀt�@�C�������݂��܂���B
    echo �ˈ��k�������X�L�b�v���܂��B
)

echo -------�N���[�j���O����-------

rem input�N���[�j���O�Ώۈꗗ�\��
for /f "skip=7" %%i in ('dir .\input\iis_access\ /b /o-n') do echo input�N���[�j���O�Ώ�:%%i

rem input�N���[�j���O
for /f "skip=7" %%i in ('dir .\input\iis_access\ /b /o-n') do (
    del .\input\iis_access\%%i
    rem del�R�}���h��errorlevel���肪�ł��Ȃ��̂ŁA�t�@�C�������݂��邩�Ŕ��肷��
    rem �t�@�C�����u�ǂݎ���p�v�ɂ���ƃG���[�����\
    if exist .\input\iis_access\%%i (
        echo �ˎ��s: %%i input�t�@�C���N���[�j���O
    ) else (
        echo �ː���: %%i input�t�@�C���N���[�j���O
    )
)

rem output�N���[�j���O�Ώۈꗗ�\��
for /f "skip=4" %%i in ('dir .\output\iis\*.zip /b /o-n') do echo output�N���[�j���O�Ώ�:%%i

rem output�N���[�j���O
for /f "skip=4" %%i in ('dir .\output\iis\*.zip /b /o-n') do (
    del .\output\iis\%%i
    rem del�R�}���h��errorlevel���肪�ł��Ȃ��̂ŁA�t�@�C�������݂��邩�Ŕ��肷��
    rem �t�@�C�����u�ǂݎ���p�v�ɂ���ƃG���[�����\
    if exist .\input\iis_access\%%i (
        echo �ˎ��s: %%i output�t�@�C���N���[�j���O
    ) else (
        echo �ː���: %%i output�t�@�C���N���[�j���O
    )
)

echo -------�o�b�N�A�b�v�����I��-------
