# New-SPClientView

## SYNOPSIS
Creates a new view.

## SYNTAX

```
New-SPClientView [-ClientContext <ClientContext>] [-ParentObject] <SPClientViewParentPipeBind> -Name <String>
 [-Title <String>] [-ViewFields <String[]>] [-Query <String>] [-RowLimit <Int32>] [-Paged <Boolean>]
 [-SetAsDefaultView <Boolean>] [-ViewType <String>] [-PersonalView <Boolean>] [-Retrieval <String>]
```

## DESCRIPTION
The New-SPClientView function adds a new view to the list.

## EXAMPLES

### -------------------------- Example 1 --------------------------
```
New-SPClientView -Name "CustomView" -Title "Custom View" -ViewFields "ID", "Title"
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

### -ParentObject
Indicates the list which a view to be created.

```yaml
Type: SPClientViewParentPipeBind
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
Indicates the internal name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
Indicates the title.
If not specified, uses the internal name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: $Name
Accept pipeline input: False
Accept wildcard characters: False
```

### -ViewFields
Indicates the collection of view columns.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
Indicates the XML representation of the query.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RowLimit
Indicates the number of items.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Paged
Indicates a value whether the view is a paged view.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetAsDefaultView
Indicates a value whether the view is the default view.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ViewType
{{Fill ViewType Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: Html
Accept pipeline input: False
Accept wildcard characters: False
```

### -PersonalView
Indicates a value whether the view is a personal view.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Retrieval
Indicates the data retrieval expression.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None or SPClient.SPClientViewParentPipeBind

## OUTPUTS

### Microsoft.SharePoint.Client.View

## NOTES

## RELATED LINKS

[https://github.com/karamem0/SPClient/blob/master/doc/New-SPClientView.md](https://github.com/karamem0/SPClient/blob/master/doc/New-SPClientView.md)

