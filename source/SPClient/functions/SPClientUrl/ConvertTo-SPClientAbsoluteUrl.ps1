﻿#Requires -Version 3.0

<#
  ConvertTo-SPClientAbsoluteUrl.ps1

  Copyright (c) 2017 karamem0

  This software is released under the MIT License.
  https://github.com/karamem0/SPClient/blob/master/LICENSE
#>

function ConvertTo-SPClientAbsoluteUrl {

<#
.SYNOPSIS
  Makes a absolute url.
.DESCRIPTION
  The ConvertTo-SPClientAbsoluteUrl function converts a server relative url to a server absolute url.
.PARAMETER ClientContext
  Indicates the client context. If not specified, uses a default context.
.PARAMETER Url
  Indicates the url.
.EXAMPLE
  ConvertTo-SPClientAbsoluteUrl "/path/to/list"
.INPUTS
  None or System.String
.OUTPUTS
  System.String
.LINK
  https://github.com/karamem0/SPClient/blob/master/doc/ConvertTo-SPClientAbsoluteUrl.md
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Microsoft.SharePoint.Client.ClientContext]
        $ClientContext = $SPClient.ClientContext,
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]
        $Url
    )

    process {
        if ($ClientContext -eq $null) {
            throw "Cannot bind argument to parameter 'ClientContext' because it is null."
        }
        if (-not $ClientContext.Site.IsPropertyAvailable('Url')) {
            Invoke-ClientContextLoad `
                -ClientContext $ClientContext `
                -ClientObject $ClientContext.Site `
                -Retrieval 'Url'
        }
        $SiteUrl = [uri]$ClientContext.Site.Url
        $RootUrl = $SiteUrl.GetLeftPart([System.UriPartial]::Authority)
        $AbsoluteUrl = New-Object System.Uri($RootUrl, $Url, [System.UriKind]::Absolute)
        Write-Output $AbsoluteUrl.AbsoluteUri
    }

}
