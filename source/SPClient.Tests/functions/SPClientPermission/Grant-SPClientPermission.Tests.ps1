﻿#Requires -Version 3.0

. "$($PSScriptRoot)\..\..\TestInitialize.ps1"

Describe 'Grant-SPClientPermission' {

    Context 'Success' {

        BeforeEach {
            try {
                $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
                $List = New-Object Microsoft.SharePoint.Client.ListCreationInformation
                $List.Title = 'TestList0'
                $List.TemplateType = 100
                $List = $Web.Lists.Add($List)
                $List.Title = 'Test List 0'
                $List.Update()
                $SPClient.ClientContext.Load($List)
                $SPClient.ClientContext.ExecuteQuery()
            } catch {
                Write-Host $_ -ForegroundColor Yellow 
            }
        }

        AfterEach {
            try {
                $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
                $List = $Web.Lists.GetByTitle('Test List 0')
                $List.DeleteObject()
                $SPClient.ClientContext.ExecuteQuery()
            } catch {
                Write-Host $_ -ForegroundColor Yellow 
            }
        }

        It 'Grants a permission by role name' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetByTitle('Test List 0')
            $List.BreakRoleInheritance($false, $false)
            $Group = Get-SPClientGroup -Identity $TestConfig.GroupId
            $Params = @{
                ClientObject = $List
                Member = $Group
                Roles = 'Full Control'
            }
            $Result = Grant-SPClientPermission @Params
            $Result | Should Not BeNullOrEmpty
        }

        It 'Grants a permission by role type' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetByTitle('Test List 0')
            $List.BreakRoleInheritance($false, $false)
            $Group = $Web.SiteGroups.GetById($TestConfig.GroupId)
            $Params = @{
                ClientObject = $List
                Member = $Group
                Roles = [Microsoft.SharePoint.Client.RoleType]::Administrator
            }
            $Result = Grant-SPClientPermission @Params
            $Result | Should Not BeNullOrEmpty
        }

        It 'Grants permissions by role name collection' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetByTitle('Test List 0')
            $List.BreakRoleInheritance($false, $false)
            $Group = $Web.SiteGroups.GetById($TestConfig.GroupId)
            $Params = @{
                ClientObject = $List
                Member = $Group
                    Roles = @(
                        'Read'
                        'Contribute'
                        'Edit'
                        'Full Control'
                    )
            }
            $Result = Grant-SPClientPermission @Params
            $Result | Should Not BeNullOrEmpty
        }

        It 'Grants permissions by role type collection' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetByTitle('Test List 0')
            $List.BreakRoleInheritance($false, $false)
            $Group = $Web.SiteGroups.GetById($TestConfig.GroupId)
            $Params = @{
                ClientObject = $List
                Member = $Group
                    Roles = @(
                        [Microsoft.SharePoint.Client.RoleType]::Reader
                        [Microsoft.SharePoint.Client.RoleType]::Contributor
                        [Microsoft.SharePoint.Client.RoleType]::Editor
                        [Microsoft.SharePoint.Client.RoleType]::Administrator
                    )
            }
            $Result = Grant-SPClientPermission @Params
            $Result | Should Not BeNullOrEmpty
        }

    }

    Context 'Failure' {

        It 'Throws an error when has not unique permission' {
            $Throw = {
                $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
                $List = $Web.Lists.GetById($TestConfig.ListId)
                $Group = $Web.SiteGroups.GetById($TestConfig.GroupId)
                $Params = @{
                    ClientObject = $List
                    Member = $Group
                    Roles = 'Full Control'
                }
                $Result = Grant-SPClientPermission @Params
                $Result | Should Not BeNullOrEmpty
            }
            $Throw | Should Throw 'This operation is not allowed on an object that inherits permissions.'
        }

    }

}
