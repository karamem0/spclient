﻿#Requires -Version 3.0

. "$($PSScriptRoot)\..\..\TestInitialize.ps1"

Describe 'Get-SPClientListItem' {

    Context 'Success' {

        It 'Returns all list items' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
            }
            $Result = Get-SPClientListItem @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.ListItem'
        }

        It 'Returns list items with folder url' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                FolderUrl = "$($TestConfig.WebUrl)/$($TestConfig.ListInternalName)"
            }
            $Result = Get-SPClientListItem @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.ListItem'
        }

        It 'Returns list items with scope' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                Scope = 'Recursive'
            }
            $Result = Get-SPClientListItem @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.ListItem'
        }

        It 'Returns list items with view fields' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                ViewFields = @('ID', 'FileRef')
            }
            $Result = Get-SPClientListItem @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.ListItem'
        }

        It 'Returns list items with row limit' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                RowLimit = 2
            }
            $Result = Get-SPClientListItem @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.ListItem'
            $Result.Count | Should Be 2
        }

        It 'Returns list items with position' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                RowLimit = 2
            }
            $Result = Get-SPClientListItem @Params
            $Position = $Result.ListItemCollectionPosition
            while ($Position -ne $null) {
                $Params = @{
                    ParentList = $List
                    RowLimit = 2
                    Position = $Position
                }
                $Result = Get-SPClientListItem @Params
                $Result | Should Not BeNullOrEmpty
                $Result | Should BeOfType 'Microsoft.SharePoint.Client.ListItem'
                $Position = $Result.ListItemCollectionPosition
            }
        }

        It 'Returns list items with simple query' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                Query = `
                    '<Query>' + `
                    '<Where>' + `
                    '<Eq>' + `
                    '<FieldRef Name="Title"/>' + `
                    '<Value Type="Text">Test List Item 1</Value>' + `
                    '</Eq>' + `
                    '</Where>' + `
                    '</Query>'
            }
            $Result = Get-SPClientListItem @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.ListItem'
        }

        It 'Returns list items with complexed query' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                Query = `
                    '<Where>' + `
                    '<Eq>' + `
                    '<FieldRef Name="Title"/>' + `
                    '<Value Type="Text">Test List Item 1</Value>' + `
                    '</Eq>' + `
                    '</Where>' + `
                    '<OrderBy>' + `
                    '<FieldRef Name="Title" Ascending="FALSE"/>' + `
                    '</OrderBy>'
            }
            $Result = Get-SPClientListItem @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.ListItem'
        }

        It 'Returns a list item by id' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                Identity = $TestConfig.ListItemId
            }
            $Result = Get-SPClientListItem @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.ListItem'
        }

        It 'Returns a list item by guid' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                IdentityGuid = $TestConfig.ListItemUniqueId
            }
            $Result = Get-SPClientListItem @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.ListItem'
        }

    }

    Context 'Failure' {

        It 'Throws an error when the list could not be found by id' {
            $Throw = {
                $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
                $List = $Web.Lists.GetById($TestConfig.ListId)
                $Params = @{
                    ParentList = $List
                    Identity = -1
                }
                $Result = Get-SPClientListItem @Params
                $Result | Should Not BeNullOrEmpty
            }
            $Throw | Should Throw 'The specified list item could not be found.'
        }

        It 'Throws an error when the list could not be found by guid' {
            $Throw = {
                $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
                $List = $Web.Lists.GetById($TestConfig.ListId)
                $Params = @{
                    ParentList = $List
                    IdentityGuid = '95BBF208-A139-4E6B-BB8C-B7D1BC7CFB60'
                }
                $Result = Get-SPClientListItem @Params
                $Result | Should Not BeNullOrEmpty
            }
            $Throw | Should Throw 'The specified list item could not be found.'
        }

    }

}
