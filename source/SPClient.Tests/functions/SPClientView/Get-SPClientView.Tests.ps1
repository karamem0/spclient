﻿#Requires -Version 3.0

. "$($PSScriptRoot)\..\..\TestInitialize.ps1"

Describe 'Get-SPClientView' {

    Context 'Success' {

        It 'Gets all views' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($SPClient.TestConfig.WebId)
            $List = $Web.Lists.GetById($SPClient.TestConfig.ListId)
            $Params = @{
                ParentObject = $List
            }
            $Result = Get-SPClientView @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.View'
        }

        It 'Gets a view by id' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($SPClient.TestConfig.WebId)
            $List = $Web.Lists.GetById($SPClient.TestConfig.ListId)
            $Params = @{
                ParentObject = $List
                Identity = $SPClient.TestConfig.ViewId
            }
            $Result = Get-SPClientView @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.View'
        }

        It 'Gets a view by relative url' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($SPClient.TestConfig.WebId)
            $List = $Web.Lists.GetById($SPClient.TestConfig.ListId)
            $Params = @{
                ParentObject = $List
                Url = $SPClient.TestConfig.ViewUrl
            }
            $Result = Get-SPClientView @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.View'
        }

        It 'Gets a view by absolute url' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($SPClient.TestConfig.WebId)
            $List = $Web.Lists.GetById($SPClient.TestConfig.ListId)
            $Params = @{
                ParentObject = $List
                Url = $SPClient.TestConfig.RootUrl + $SPClient.TestConfig.ViewUrl
            }
            $Result = Get-SPClientView @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.View'
        }

        It 'Gets a view by title' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($SPClient.TestConfig.WebId)
            $List = $Web.Lists.GetById($SPClient.TestConfig.ListId)
            $Params = @{
                ParentObject = $List
                Title = $SPClient.TestConfig.ViewTitle
            }
            $Result = Get-SPClientView @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.View'
        }

        It 'Gets the default view' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($SPClient.TestConfig.WebId)
            $List = $Web.Lists.GetById($SPClient.TestConfig.ListId)
            $Params = @{
                ParentObject = $List
                Default = $true
            }
            $Result = Get-SPClientView @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.View'
        }

    }

    Context 'Failure' {

        It 'Throws an error when the view could not be found by id' {
            $Throw = {
                $Web = $SPClient.ClientContext.Site.OpenWebById($SPClient.TestConfig.WebId)
                $List = $Web.Lists.GetById($SPClient.TestConfig.ListId)
                $Params = @{
                    ParentObject = $List
                    Identity = '538BAEA3-24BE-4411-AA54-4700C5735AF7'
                }
                $Result = Get-SPClientView @Params
                $Result | Should Not BeNullOrEmpty
            }
            $Throw | Should Throw 'The specified view could not be found.'
        }

        It 'Throws an error when the view could not be found by url' {
            $Throw = {
                $Web = $SPClient.ClientContext.Site.OpenWebById($SPClient.TestConfig.WebId)
                $List = $Web.Lists.GetById($SPClient.TestConfig.ListId)
                $Params = @{
                    ParentObject = $List
                    Url = "$($SPClient.TestConfig.ListUrl)/TestView0.aspx"
                }
                $Result = Get-SPClientView @Params
                $Result | Should Not BeNullOrEmpty
            }
            $Throw | Should Throw 'The specified view could not be found.'
        }

        It 'Throws an error when the view could not be found by title' {
            $Throw = {
                $Web = $SPClient.ClientContext.Site.OpenWebById($SPClient.TestConfig.WebId)
                $List = $Web.Lists.GetById($SPClient.TestConfig.ListId)
                $Params = @{
                    ParentObject = $List
                    Title = 'Test View 0'
                }
                $Result = Get-SPClientView @Params
                $Result | Should Not BeNullOrEmpty
            }
            $Throw | Should Throw 'The specified view could not be found.'
        }

    }

}
