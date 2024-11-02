# �G�N�Z���ҏW�i�V�[�g���ύX�j

function Rename-ExcelSheet {
    param (
        [string]$filePath,
        [string]$currentSheetName,
        [string]$newSheetName
    )

    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false

    try {
        $workbook = $excel.Workbooks.Open($filePath)
        
        # �V�[�g���ύX
        $sheet = $workbook.Sheets.Item($currentSheetName) 
        $sheet.Name = $newSheetName

        # �Z���̒l��ύX
        $sheet.Cells.Item(2, 2).Value2 = "�V�K"

        $workbook.Save()
    } catch {
        Write-Error "�G���[���������܂���: $_"
    } finally {
        $excel.Quit()

        # COM�I�u�W�F�N�g�̉��
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet) | Out-Null
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
        Remove-Variable -Name excel
        Remove-Variable -Name workbook
        Remove-Variable -Name sheet
    }
}

Set-Location 1_renamed
$list = Get-ChildItem -File -Filter *.xlsx
$list | ForEach-Object { Write-Output $_.FullName }

ForEach($l in $list) {
    Rename-ExcelSheet -filePath $l.FullName -currentSheetName "�\��" -newSheetName "�^�C�g��"
}

