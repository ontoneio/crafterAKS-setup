Get-ChildItem -Path .\itd.acgov.org\itd | Rename-Item -NewName {$_.name -replace "page@", 'html'}

