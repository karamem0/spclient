#Requires -Version 3.0

# Remove-SPClientField.ps1
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

function Remove-SPClientField {

<#
.SYNOPSIS
  Deletes a field.
.PARAMETER ClientContext
  Indicates the client context.
  If not specified, uses the default context.
.PARAMETER ClientObject
  Indicates the field to delete.
.PARAMETER ParentObject
  Indicates the list which the field is contained.
.PARAMETER Identity
  Indicates the web GUID.
.PARAMETER Name
  Indicates the field title or internal name.
#>

    [CmdletBinding(DefaultParameterSetName = 'ClientObject')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'ClientObject')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Identity')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Name')]
        [Microsoft.SharePoint.Client.ClientContext]
        $ClientContext = $SPClient.ClientContext,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'ClientObject')]
        [Microsoft.SharePoint.Client.Field]
        $ClientObject,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Identity')]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Name')]
        [Microsoft.SharePoint.Client.List]
        $ParentObject,
        [Parameter(Mandatory = $false, ParameterSetName = 'Identity')]
        [Alias('Id')]
        [guid]
        $Identity,
        [Parameter(Mandatory = $true, ParameterSetName = 'Name')]
        [Alias('Title')]
        [string]
        $Name
    )

    process {
        if ($ClientContext -eq $null) {
            throw "Cannot bind argument to parameter 'ClientContext' because it is null."
        }
        if ($PSCmdlet.ParameterSetName -eq 'ClientObject') {
            if (-not $ClientObject.IsPropertyAvailable('Id')) {
                Invoke-SPClientLoadQuery `
                    -ClientContext $ClientContext `
                    -ClientObject $ClientObject
            }
        } else {
            $ClientObjectCollection = $ParentObject.Fields
            if ($PSCmdlet.ParameterSetName -eq 'Identity') {
                $ClientObject = $ClientObjectCollection.GetById($Identity)
                Invoke-SPClientLoadQuery `
                    -ClientContext $ClientContext `
                    -ClientObject $ClientObject `
                    -Retrievals $Retrievals
            }
            if ($PSCmdlet.ParameterSetName -eq 'Name') {
                $ClientObject = $ClientObjectCollection.GetByInternalNameOrTitle($Name)
                Invoke-SPClientLoadQuery `
                    -ClientContext $ClientContext `
                    -ClientObject $ClientObject `
                    -Retrievals $Retrievals
            }
        }
        $Xml = [xml]$ClientObject.SchemaXml
        $Xml.DocumentElement.SetAttribute('Hidden', 'FALSE')
        $Xml.DocumentElement.SetAttribute('ReadOnly', 'FALSE')
        $ClientObject.SchemaXml = $Xml.InnerXml
        $ClientObject.DeleteObject()
        $ClientContext.ExecuteQuery()
    }

}