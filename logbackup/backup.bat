@echo off

rem env�ǂݍ���
call env.bat


rem �Q�l�@���ϐ��\��
echo %enc_text%
rem ���������Ăяo��
FOR /F "usebackq" %%i IN (`powershell -executionpolicy Bypass -File .\encrypt\dec.ps1`) DO set value=%%i
rem �Q�l�@�����ςݕ�����\��
echo dec: %value%


rem �f�B���N�g�����݊m�F
if not exist %input_path% (
    echo �G���[�Finput\iis_access�f�B���N�g�������݂��܂���
    exit /b 1
)
if not exist .\work\iis\ (
    echo �G���[�Fwork\iis�f�B���N�g�������݂��܂���
    exit /b 1
)

rem work�f�B���N�g�� �N���[�j���O
del .\work\iis\*.log
if exist .\work\iis\*.log (
    echo ���s: work�f�B���N�g�� �t�@�C���N���[�j���O 
) else (
    echo ����: work�f�B���N�g�� �t�@�C���N���[�j���O
)

rem �o�b�N�A�b�v�Ώۃt�@�C���A�ŐV1�����擾
for /f %%i in ('dir .\input\iis_access\ /b /on') do set target=.\input\iis_access\%%i
echo �o�b�N�A�b�v�Ώ�: %target%


rem �Ώ�1����work�f�B���N�g���փR�s�[
copy %target% .\work\iis\
if %errorlevel% neq 0 (
    echo %errorlevel% ���s: %target% �t�@�C���R�s�[
    exit /b 1
) else (
    echo %errorlevel% ����: %target% �t�@�C���R�s�[
)

rem zip�t�@�C�����Ɏg�p����^�C���X�^���v����
set time2=%time: =0%
set timestamp=%date:~0,4%%date:~5,2%%date:~8,2%%time2:~0,2%%time2:~3,2%%time2:~6,2%

rem �Ώۃt�H���_��zip���k���Aoutput�t�H���_�֏o��
PowerShell -Command "Compress-Archive -Path .\work\iis\ -DestinationPath .\output\iis\iis_access_%timestamp%.zip -Force"

rem �N���[�j���O�Ώۈꗗ�\��
for /f "skip=7" %%i in ('dir .\input\iis_access\ /b /on') do echo %%i

rem �N���[�j���O
for /f "skip=7" %%i in ('dir .\input\iis_access\ /b /on') do (
    del .\input\iis_access\%%i
    rem del�R�}���h��errorlevel���肪�ł��Ȃ��̂ŁA�t�@�C�������݂��邩�Ŕ��肷��
    rem �t�@�C�����u�ǂݎ���p�v�ɂ���ƃG���[�����\
    if exist .\input\iis_access\%%i (
        echo ���s: %%i �t�@�C���폜
    ) else (
        echo ����: %%i �t�@�C���폜
    )
)

echo �o�b�N�A�b�v��������
