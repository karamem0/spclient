# Remove-SPClientContentType

## SYNOPSIS
Deletes the content type.

## SYNTAX

### ClientObject (Default)
```
Remove-SPClientContentType [-ClientContext <ClientContext>] [-ClientObject] <ContentType>
```

### Name
```
Remove-SPClientContentType [-ClientContext <ClientContext>] [-ParentObject] <SPClientContentTypeParentPipeBind>
 -Name <String>
```

### Identity
```
Remove-SPClientContentType [-ClientContext <ClientContext>] [-ParentObject] <SPClientContentTypeParentPipeBind>
 -Identity <String>
```

## DESCRIPTION
The Remove-SPClientContentType function removes the content type from the site.

## EXAMPLES

### -------------------------- Example 1 --------------------------
```
Remove-SPClientContentType $contentType
```

### -------------------------- Example 2 --------------------------
```
Remove-SPClientContentType $web -Identity "0X01009BD26CA6BE114008A9D56E68022DD1A7"
```

### -------------------------- Example 3 --------------------------
```
Remove-SPClientContentType $web -Name "Custom Content Type"
```

## PARAMETERS

### -ClientContext
Indicates the client context.
If not specified, uses a default context.

```yaml
Type: ClientContext
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: $SPClient.ClientContext
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientObject
Indicates the content type to delete.

```yaml
Type: ContentType
Parameter Sets: ClientObject
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ParentObject
Indicates the site or list which the content type is contained.

```yaml
Type: SPClientContentTypeParentPipeBind
Parameter Sets: Name, Identity
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Identity
Indicates the content type ID.

```yaml
Type: String
Parameter Sets: Identity
Aliases: Id

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Indicates the content type name.

```yaml
Type: String
Parameter Sets: Name
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None or Microsoft.SharePoint.Client.ContentType or SPClient.SPClientContentTypeParentPipeBind

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[https://github.com/karamem0/SPClient/blob/master/doc/Remove-SPClientContentType.md](https://github.com/karamem0/SPClient/blob/master/doc/Remove-SPClientContentType.md)

