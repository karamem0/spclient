﻿#Requires -Version 3.0

. "$($PSScriptRoot)\..\..\TestInitialize.ps1"

Describe 'Get-SPClientFile' {

    Context 'Success' {

        It 'Returns all files' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $Folder = $Web.GetFolderByServerRelativeUrl($TestConfig.FolderUrl)
            $Params = @{
                ParentFolder = $Folder
            }
            $Result = Get-SPClientFile @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.File'
        }

        It 'Returns a file by id' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $Params = @{
                ParentWeb = $Web
                Identity = $TestConfig.FileId
            }
            $Result = Get-SPClientFile @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.File'
        }

        It 'Returns a file by name' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $Folder = $Web.GetFolderByServerRelativeUrl($TestConfig.FolderUrl)
            $Params = @{
                ParentFolder = $Folder
                Name = $TestConfig.FileName
            }
            $Result = Get-SPClientFile @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.File'
        }

        It 'Returns a file by url' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $Params = @{
                ParentWeb = $Web
                Url = $TestConfig.FileUrl
            }
            $Result = Get-SPClientFile @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.File'
        }

    }

    Context 'Failure' {

        It 'Throws an error when the file could not be found by id' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $Throw = {
                $Params = @{
                    ParentWeb = $Web
                    Identity = '450E73AC-B10F-46F2-B219-9CB975557942'
                }
                $Result = Get-SPClientFile @Params
                $Result | Should Not BeNullOrEmpty
            }
            $Throw | Should Throw 'The specified file could not be found.'
        }

        It 'Throws an error when the file could not be found by name' {
            $Throw = {
                $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
                $Folder = $Web.GetFolderByServerRelativeUrl($TestConfig.FolderUrl)
                $Params = @{
                    ParentFolder = $Folder
                    Name = 'TestFile0.txt'
                }
                $Result = Get-SPClientFile @Params
                $Result | Should Not BeNullOrEmpty
            }
            $Throw | Should Throw 'The specified file could not be found.'
        }

        It 'Throws an error when the file could not be found by url' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $Throw = {
                $Params = @{
                    ParentWeb = $Web
                    Url = "$($TestConfig.FolderUrl)/TestFile0.txt"
                }
                $Result = Get-SPClientFile @Params
                $Result | Should Not BeNullOrEmpty
            }
            $Throw | Should Throw 'The specified file could not be found.'
        }

    }

}
