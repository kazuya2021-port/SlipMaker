//
//  MyControll.m
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/21.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "MyControll.h"

@implementation MyControll
@synthesize dataArray;
- (void)awakeFromNib
{
    dataArray = [NSMutableArray array];
}
#pragma mark -
#pragma mark TableView DataSource
- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex
{
    NSMutableArray* arTmp = [[NSMutableArray alloc] initWithArray:dataArray];
    NSMutableArray* rowData = [[dataArray objectAtIndex:rowIndex] mutableCopy];
    NSMutableArray* setData = [[NSMutableArray alloc] initWithCapacity:0];
    
    if([[aTableColumn identifier] compare:@"PreSub"] == NSOrderedSame)
    {
        [setData addObject:anObject];
        [setData addObject:[rowData objectAtIndex:1]];
        [setData addObject:[rowData objectAtIndex:2]];
        [setData addObject:[rowData objectAtIndex:3]];
        [setData addObject:[rowData objectAtIndex:4]];
    }
    else if([[aTableColumn identifier] compare:@"Title"] == NSOrderedSame)
    {
        [setData addObject:[rowData objectAtIndex:0]];
        [setData addObject:anObject];
        [setData addObject:[rowData objectAtIndex:2]];
        [setData addObject:[rowData objectAtIndex:3]];
        [setData addObject:[rowData objectAtIndex:4]];
    }
    if([[aTableColumn identifier] compare:@"AfterSub"] == NSOrderedSame)
    {
        [setData addObject:[rowData objectAtIndex:0]];
        [setData addObject:[rowData objectAtIndex:1]];
        [setData addObject:anObject];
        [setData addObject:[rowData objectAtIndex:3]];
        [setData addObject:[rowData objectAtIndex:4]];
    }
    else if([[aTableColumn identifier] compare:@"Author"] == NSOrderedSame)
    {
        [setData addObject:[rowData objectAtIndex:0]];
        [setData addObject:[rowData objectAtIndex:1]];
        [setData addObject:[rowData objectAtIndex:2]];
        [setData addObject:anObject];
        [setData addObject:[rowData objectAtIndex:4]];
    }
    
    [arTmp replaceObjectAtIndex:rowIndex withObject:setData];
    dataArray = arTmp;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [dataArray count];
}

- (void)tableView:(NSTableView *)tableView
  willDisplayCell:(id)cell
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    /*if(tableView == dataTable)
     {
     if([Macros isExistString:[[dataArray objectAtIndex:row] objectAtIndex:0] searchStr:@"エラー"])
     {
     NSTextFieldCell* c = cell;
     [c setBackgroundColor:[NSColor redColor]];
     [c setDrawsBackground:YES];
     }
     else
     {
     NSTextFieldCell* c = cell;
     [c setBackgroundColor:[NSColor whiteColor]];
     [c setDrawsBackground:YES];
     }
     }*/
    
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(NSInteger)rowIndex
{
    
    if([[aTableColumn identifier] compare:@"PreSub"] == NSOrderedSame)
    {
        return [[dataArray objectAtIndex:rowIndex] objectAtIndex:0];
    }
    else if([[aTableColumn identifier] compare:@"Title"] == NSOrderedSame)
    {
        return [[dataArray objectAtIndex:rowIndex] objectAtIndex:1];
    }
    else if([[aTableColumn identifier] compare:@"AfterSub"] == NSOrderedSame)
    {
        return [[dataArray objectAtIndex:rowIndex] objectAtIndex:2];
    }
    else if([[aTableColumn identifier] compare:@"Author"] == NSOrderedSame)
    {
        return [[dataArray objectAtIndex:rowIndex] objectAtIndex:3];
    }
    else if([[aTableColumn identifier] compare:@"State"] == NSOrderedSame)
    {
        return [[dataArray objectAtIndex:rowIndex] objectAtIndex:4];
    }
    
    return nil;
}

- (NSString*)searchType:(NSArray*)types
{
    for(int i = 0; i < [types count]; i++)
    {
        if ([[types objectAtIndex:i] compare:NSFilenamesPboardType] == NSOrderedSame)
        {
            return NSFilenamesPboardType;
        }
    }
    return nil;
}

/*
 - (NSDragOperation)tableView:(NSTableView*)tv
 validateDrop:(id <NSDraggingInfo>)info
 proposedRow:(NSInteger)row
 proposedDropOperation:(NSTableViewDropOperation)op
 {
 NSDragOperation retOperation = NSDragOperationNone;
 NSArray* dataTypes = [[info draggingPasteboard] types];
 
 if ([[self searchType:dataTypes] compare:NSFilenamesPboardType] == NSOrderedSame)
 {
 // ファイル／フォルダドロップ時
 retOperation = NSDragOperationCopy;
 }
 return retOperation;
 }
 
 - (BOOL)tableView:(NSTableView *)aTableView
 acceptDrop:(id )info
 row:(NSInteger)row
 dropOperation:(NSTableViewDropOperation)operation
 {
 
 NSPasteboard* pboard = [info draggingPasteboard];
 NSArray* dataTypes = [pboard types];
 
 
 if ([[self searchType:dataTypes] compare:NSFilenamesPboardType] == NSOrderedSame)
 {
 // ファイル／フォルダドロップ時
 NSData* data = [pboard dataForType:NSFilenamesPboardType];
 NSError *error;
 NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
 NSArray* theFiles = [NSPropertyListSerialization propertyListWithData:data options:(NSPropertyListReadOptions)NSPropertyListImmutable format:&format error:&error];
 //NSMutableArray* setData = [NSMutableArray array];
 
 for(id file in theFiles)
 {
 if(![Macros isDirectory:file])
 {
 [fileData addObject:file];
 }
 else
 {
 NSArray* arFiles = [Macros getFileList:file deep:NO onlyDir:NO];
 for(id f in arFiles)
 {
 [fileData addObject:[file stringByAppendingPathComponent:f]];
 }
 }
 }
 [self setDataToTable:[fileData copy] table:aTableView];
 return YES;
 
 }
 return NO;
 }
 */
@end
