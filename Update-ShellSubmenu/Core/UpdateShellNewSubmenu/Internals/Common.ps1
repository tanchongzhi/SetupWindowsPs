$null = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

$ShellNewSubmenuPreservedFileTypes = @('.lnk', '.library-ms', 'Folder')
