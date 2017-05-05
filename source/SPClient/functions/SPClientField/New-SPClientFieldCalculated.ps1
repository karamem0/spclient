#Requires -Version 3.0

# New-SPClientFieldCalculated.ps1
#
# Copyright (c) 2017 karamem0
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

function New-SPClientFieldCalculated {

<#
.SYNOPSIS
  Creates a new field whose value is calculated based on other columns.
.PARAMETER ClientContext
  Indicates the client context.
  If not specified, uses the default context.
.PARAMETER ParentObject
  Indicates the list which a field to be created.
.PARAMETER Name
  Indicates the internal name.
.PARAMETER Title
  Indicates the title.
.PARAMETER Identity
  Indicates the field GUID.
.PARAMETER Description
  Indicates the description.
.PARAMETER Fomula
  Indicates the formula.
.PARAMETER OutputType
  Indicates the data type of the return value.
    - Text
    - Number
    - Currency
    - DateTime
    - Boolean
.PARAMETER Decimals
  Indicates the number of decimals.
  This parameter is used when OutputType is 'Number' or 'Currency'.
.PARAMETER Percentage
  Indicates a value whether the field shows as percentage.
  This parameter is used when OutputType is 'Number'.
.PARAMETER LocaleId 
  Indicates the language code identifier (LCID).
  This parameter is used when OutputType is 'Currency'.
.PARAMETER DateFormat
  Indicates the datetime display format.
  This parameter is used when OutputType is 'DateTime'.
.PARAMETER AddToDefaultView
  If true, the field is add to default view.
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Microsoft.SharePoint.Client.ClientContext]
        $ClientContext = $SPClient.ClientContext,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [Microsoft.SharePoint.Client.List]
        $ParentObject,
        [Parameter(Mandatory = $true)]
        [string]
        $Name,
        [Parameter(Mandatory = $false)]
        [string]
        $Title = $Name,
        [Parameter(Mandatory = $false)]
        [guid]
        $Identity,
        [Parameter(Mandatory = $false)]
        [string]
        $Description,
        [Parameter(Mandatory = $true)]
        [string]
        $Formula,
        [Parameter(Mandatory = $true)]
        [string[]]
        $FieldRefs,
        [Parameter(Mandatory = $true)]
        [ValidateSet('Text', 'Number', 'Currency', 'DateTime', 'Boolean')]
        [string]
        $OutputType,
        [Parameter(Mandatory = $false)]
        [int]
        $Decimals,
        [Parameter(Mandatory = $false)]
        [bool]
        $Percentage,
        [Parameter(Mandatory = $false)]
        [int]
        $LocaleId,
        [Parameter(Mandatory = $false)]
        [ValidateSet('DateOnly', 'DateTime')]
        [string]
        $DateFormat,
        [Parameter(Mandatory = $false)]
        [bool]
        $AddToDefaultView
    )

    process {
        if ($ClientContext -eq $null) {
            throw "Cannot bind argument to parameter 'ClientContext' because it is null."
        }
        $XmlDocument = New-Object System.Xml.XmlDocument
        $FieldElement = $XmlDocument.AppendChild($XmlDocument.CreateElement('Field'))
        $FieldElement.SetAttribute('Type', 'Calculated')
        $FieldElement.SetAttribute('ReadOnly', 'TRUE')
        $FieldElement.SetAttribute('Name', $Name)
        $FieldElement.SetAttribute('DisplayName', $Title)
        if ($MyInvocation.BoundParameters.ContainsKey('Identity')) {
            $FieldElement.SetAttribute('ID', $Identity)
        }
        if ($MyInvocation.BoundParameters.ContainsKey('Description')) {
            $FieldElement.SetAttribute('Description', $Description)
        }
        if ($MyInvocation.BoundParameters.ContainsKey('Formula')) {
            $FormulaElement = $XmlDocument.CreateElement('Formula')
            $FormulaElement.InnerText = $Formula
            $FieldElement.AppendChild($FormulaElement) | Out-Null
        }
        if ($MyInvocation.BoundParameters.ContainsKey('FieldRefs')) {
            $FieldRefsElement = $XmlDocument.CreateElement('FieldRefs')
            $FieldRefs | ForEach-Object {
                $FieldRefElement = $XmlDocument.CreateElement('FieldRef')
                $FieldRefElement.SetAttribute('Name', $_)
                $FieldRefsElement.AppendChild($FieldRefElement) | Out-Null
            }
            $FieldElement.AppendChild($FieldRefsElement) | Out-Null
        }
        if ($MyInvocation.BoundParameters.ContainsKey('OutputType')) {
            $FieldElement.SetAttribute('ResultType', $OutputType)
        }
        if ($MyInvocation.BoundParameters.ContainsKey('Decimals')) {
            $FieldElement.SetAttribute('Decimals', $Decimals)
        }
        if ($MyInvocation.BoundParameters.ContainsKey('Percentage')) {
            $FieldElement.SetAttribute('Percentage', $Percentage.ToString().ToUpper())
        }
        if ($MyInvocation.BoundParameters.ContainsKey('LocaleId')) {
            $FieldElement.SetAttribute('LCID', $LocaleId)
        }
        if ($MyInvocation.BoundParameters.ContainsKey('DateFormat')) {
            $FieldElement.SetAttribute('Format', $DateFormat)
        }
        $AddFieldOptions = [Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint
        $ClientObject = $ParentObject.Fields.AddFieldAsXml($XmlDocument.InnerXml, $AddToDefaultView, $AddFieldOptions)
        Invoke-SPClientLoadQuery `
            -ClientContext $ClientContext `
            -ClientObject $ClientObject
        $ClientObject = Convert-SPClientField `
            -ClientContext $ClientContext `
            -ClientObject $ClientObject
        Write-Output $ClientObject
    }

}