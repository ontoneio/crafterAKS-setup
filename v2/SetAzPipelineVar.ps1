function Set-AzPipelineVar {
    [CmdletBinding(
        SupportsShouldProcess=$true
    )]
    param (
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true)]
        [String]
        $VarName,

        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true)]
        # [Any]
        $Value
    )

    process {
        Write-Output "##vso[task.setvariable variable=$VarName;]$Value"
    }
}

Set-AzPipelineVar -VarName 'env' -Value 'dev'