﻿#Requires -Version 3.0

. "$($PSScriptRoot)\..\..\TestInitialize.ps1"

Describe 'New-SPClientFolder' {

    Context 'Success' {

        AfterEach {
            try {
                $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
                $Folder = $Web.GetFolderByServerRelativeUrl("$($TestConfig.FolderUrl)/TestFolder")
                $Folder.DeleteObject()
                $SPClient.ClientContext.ExecuteQuery()
            } catch {
                Write-Host $_ -ForegroundColor Yellow 
            }
        }

        It 'Creates a new folder' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $Folder = $Web.GetFolderByServerRelativeUrl($TestConfig.FolderUrl)
            $Params = @{
                ParentFolder = $Folder
                Name = 'TestFolder0'
            }
            $Result = New-SPClientFolder @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.Folder'
            $Result.Name | Should Be 'TestFolder0'
        }

    }

}
