@echo off

rem �f�B���N�g�����݊m�F
if not exist .\input\iis_access\ (
    echo �G���[�Finput\iis_access�f�B���N�g�������݂��܂���
    exit /b 1
)
if not exist .\work\iis\ (
    echo �G���[�Fwork\iis�f�B���N�g�������݂��܂���
    exit /b 1
)

rem work�f�B���N�g���N���[�j���O
del .\work\iis\*.log
if exist .\work\iis\*.log (
    echo �폜���s: 
) else (
    echo �폜����: 
)

rem �o�b�N�A�b�v�Ώۃt�@�C���A�ŐV1�����擾
for /f %%i in ('dir .\input\iis_access\ /b /on') do set target=.\input\iis_access\%%i
echo �o�b�N�A�b�v�Ώ�: %target%


rem work�f�B���N�g���փR�s�[
copy %target% .\work\iis\

echo -------------------
echo %errorlevel%
echo -------------------




rem �N���[�j���O�Ώۈꗗ�\��
for /f "skip=7" %%i in ('dir .\input\iis_access\ /b /on') do echo %%i

rem �N���[�j���O
for /f "skip=7" %%i in ('dir .\input\iis_access\ /b /on') do ( 
    del .\input\iis_access\%%i

    rem del�R�}���h��errorlevel���肪�ł��Ȃ��̂ŁA�t�@�C�������݂��邩�Ŕ��肷��
    rem �t�@�C�����u�ǂݎ���p�v�ɂ���ƃG���[�����\
    if exist .\input\iis_access\%%i (
        echo �폜���s: %%i
    ) else (
        echo �폜����: %%i
    )
)