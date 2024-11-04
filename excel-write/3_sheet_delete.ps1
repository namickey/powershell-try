function Delete-ExcelSheet {
    param(
        $filePath,
        $excel
    )
    $book = $excel.Workbooks.Open($filePath)
 
    # �V�[�g�̍폜
    $excel.worksheets.item("�\��").delete()
     
    # �㏑���ۑ�
    $book.Save()
    $book.Close()
}


try {
    # Excel�I�u�W�F�N�g�쐬
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
 
    Set-Location 1_renamed
    $list = Get-ChildItem -File -Filter *.xlsx
    ForEach($l in $list) {
        write-host $l.FullName
        Delete-ExcelSheet -filePath $l.FullName -excel $excel
    }
} catch {
    Write-Error "�G���[���������܂���: $_"
} finally {
    $excel.Quit()
    $excel = $null
    [GC]::Collect()
}