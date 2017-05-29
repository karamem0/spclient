﻿#Requires -Version 3.0

. "$($PSScriptRoot)\..\..\TestInitialize.ps1"

Describe 'New-SPClientFieldLookup' {

    Context 'Success' {

        AfterEach {
            try {
                $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
                $List = $Web.Lists.GetById($TestConfig.ListId)
                $Field = $List.Fields.GetByInternalNameOrTitle('TestField0')
                $SPClient.ClientContext.Load($Field)
                $SPClient.ClientContext.ExecuteQuery()
                $Xml = [xml]$Field.SchemaXml
                $Xml.DocumentElement.SetAttribute('Hidden', 'FALSE')
                $Field.SchemaXml = $Xml.InnerXml
                $Field.DeleteObject()
                $SPClient.ClientContext.ExecuteQuery()
            } catch {
                Write-Host $_ -ForegroundColor Yellow 
            }
        }

        It 'Creates a new field with mandatory parameters' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                Name = 'TestField0'
                LookupList = $TestConfig.ListId
                LookupField = $TestConfig.FieldName
            }
            $Result = New-SPClientFieldLookup @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.FieldLookup'
            $Result.InternalName | Should Be 'TestField0'
            $Result.Id | Should Not BeNullOrEmpty
            $Result.Title | Should Be 'TestField0'
            $Result.Description | Should BeNullOrEmpty
            $Result.Required | Should Be $false
            $Result.EnforceUniqueValues | Should Be $false
            $Result.LookupList | Should Be "{$($TestConfig.ListId)}"
            $Result.LookupField | Should Be $TestConfig.FieldName
            $Result.RelationshipDeleteBehavior | Should Be 'None'
        }

        It 'Creates a new field with all parameters' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                Name = 'TestField0'
                Identity = '2F992681-3273-4C8C-BACD-8B7A9BBA0EE4'
                Title = 'Test Field 0'
                Description = 'Test Field 0'
                Required = $true
                EnforceUniqueValues = $true
                AllowMultipleValues = $false
                LookupList = $TestConfig.ListId
                LookupField = $TestConfig.FieldName
                RelationshipDeleteBehavior = 'Cascade'
                AddToDefaultView = $true
            }
            $Result = New-SPClientFieldLookup @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.FieldLookup'
            $Result.InternalName | Should Be 'TestField0'
            $Result.Id | Should Be '2F992681-3273-4C8C-BACD-8B7A9BBA0EE4'
            $Result.Title | Should Be 'Test Field 0'
            $Result.Description | Should Be 'Test Field 0'
            $Result.Required | Should Be $true
            $Result.AllowMultipleValues | Should Be $false
            $Result.EnforceUniqueValues | Should Be $true
            $Result.LookupList | Should Be "{$($TestConfig.ListId)}"
            $Result.LookupField | Should Be $TestConfig.FieldName
            $Result.RelationshipDeleteBehavior | Should Be 'Cascade'
        }

        It 'Creates a new field which allows multiple value' {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Params = @{
                ParentList = $List
                Name = 'TestField0'
                EnforceUniqueValues = $false
                AllowMultipleValues = $true
                LookupList = $TestConfig.ListId
                LookupField = $TestConfig.FieldName
            }
            $Result = New-SPClientFieldLookup @Params
            $Result | Should Not BeNullOrEmpty
            $Result | Should BeOfType 'Microsoft.SharePoint.Client.FieldLookup'
            $Result.InternalName | Should Be 'TestField0'
            $Result.Id | Should Not BeNullOrEmpty
            $Result.Title | Should Be 'TestField0'
            $Result.Description | Should BeNullOrEmpty
            $Result.Required | Should Be $false
            $Result.AllowMultipleValues | Should Be $true
            $Result.EnforceUniqueValues | Should Be $false
            $Result.LookupList | Should Be "{$($TestConfig.ListId)}"
            $Result.LookupField | Should Be $TestConfig.FieldName
            $Result.RelationshipDeleteBehavior | Should Be 'None'
        }

    }

}
