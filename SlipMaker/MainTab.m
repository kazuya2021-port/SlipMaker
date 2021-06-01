//
//  MainTab.m
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/07.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "MainTab.h"

@implementation MainTab

- (void)awakeFromNib
{
    dataArray = [NSMutableArray array];
    ctrl.content = dataArray;
    [dataTable registerForDraggedTypes:ARRAY(NSFilenamesPboardType)];
    [dataTable setTarget:self];
    [dataTable setDataSource:self];
    [dataTable setDelegate:self];
    [dataTable setDoubleAction:@selector(onDoubleClickTable:)];
    openFolder=@"";
}

- (void)onDoubleClickTable:(id)sender
{
    if([sender clickedRow] == -1) return;
    TableData* selData = [dataArray objectAtIndex:[sender clickedRow]];
    NSURL* fileURL = [NSURL fileURLWithPath:[Macros getCurDir:selData.filePath]];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:ARRAY(fileURL)];
}

#define MaruNumHead @"%E2%91%"
#define NumOffset 160 // 0xA0 => 1
//NSCharacterSet *allowedCharacters = [NSCharacterSet URLFragmentAllowedCharacterSet];
//maru = [codeStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
-(NSString*)convertNumToMaruNum:(int)num
{
    if(num > 50) return nil;
    NSString* maru = @"";
    int numOfst = NumOffset + (num - 1);
    NSString* codeStr = [MaruNumHead stringByAppendingString:[NSString stringWithFormat:@"%x",numOfst]];
    maru = [codeStr stringByRemovingPercentEncoding];
    return maru;
}

-(int)getNumberFromStr:(NSString*)str
{
    int ret = 0;
    NSRegularExpression* reg = [[NSRegularExpression alloc] initWithPattern:@"\\d+" options:0 error:nil];
    NSArray* matchs = [reg matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    for(NSTextCheckingResult* res in matchs)
    {
        NSString* regStr = [str substringWithRange:[res range]];
        if([regStr compare:@""] != NSOrderedSame)
        {
            ret = [regStr intValue];
        }
    }
    return ret;
}

-(NSString*)convertTitle:(NSString*)title
{
    NSString* ret = @"";
    NSString* pattern = @"(\\(\\d+\\))";
    NSRegularExpression* reg = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray* matchs = [reg matchesInString:title options:0 range:NSMakeRange(0, [title length])];
    for(NSTextCheckingResult* res in matchs)
    {
        if([[title substringWithRange:[res range]] compare:@""] != NSOrderedSame)
        {
            NSString* regStr = [title substringWithRange:[res range]];
            int num = [self getNumberFromStr:regStr];
            NSString* maruNum = [self convertNumToMaruNum:num];
            if(maruNum != nil)
            {
                ret = [title stringByReplacingCharactersInRange:[res range] withString:maruNum];
            }
            break;
        }
    }
    return ([ret compare:@""] == NSOrderedSame)? title:ret;
}

-(void)processIllustrator:(TableData**)data
{
    NSString* ngWords=@"NG:";
    NSWorkspace* sw = [NSWorkspace sharedWorkspace];
    [sw openFile:[*data filePath] withApplication:ILLUSTLATOR andDeactivate:NO];
    
    [illustrator waitReadFile];
    if(![illustrator deleteTemplateStringUp])
        [ngWords stringByAppendingString:@"テンプレートの上部書名削除失敗:"];
        //[*data setAddStatus:@"テンプレートの上部書名削除失敗"]

    if(![illustrator deleteTemplateStringDown])
        [ngWords stringByAppendingString:@"テンプレートの下部書名削除失敗:"];
    
    if(![illustrator deleteTemplateStringAuthor])
        [ngWords stringByAppendingString:@"テンプレートの著者削除失敗:"];
    
    NSString* title = [[*data bookTitle] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString* pre = [[*data preSub] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString* aft = [[*data afterSub] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    if(![illustrator addTitle:title preSub:pre afterSub:aft])
        [ngWords stringByAppendingString:@"書名追加失敗:"];
    
    if(![illustrator addAuthor:[*data author]])
        [ngWords stringByAppendingString:@"著者追加失敗:"];
    
    if([ngWords compare:@"NG:"]!=NSOrderedSame){
        [ngWords substringWithRange:NSMakeRange(0, ngWords.length - 2)];
        [*data setAddStatus:ngWords];
    }
}

- (NSString*)replaceHalfNumToFullNum:(NSString*)orgStr
{
    NSString* pattern = @"(\\d{4})";
    NSRegularExpression* reg = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray* matchs = [reg matchesInString:orgStr options:0 range:NSMakeRange(0, [orgStr length])];
    for(NSTextCheckingResult* res in matchs)
    {
        NSString* regStr = [orgStr substringWithRange:[res range]];
        
        if([regStr compare:@""] != NSOrderedSame)
        {
            NSMutableString* str = [[NSMutableString alloc] initWithString:regStr];
            CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformFullwidthHalfwidth, true);
            orgStr = [orgStr stringByReplacingOccurrencesOfString:regStr withString:str];
            break;
        }
    }
    return orgStr;
}
// タイトルの整形
- (NSString*)createTitleContent:(NSString*)content
{
    // ()の文字を丸数字に変える
    //NSString* retStr = [self convertTitle:content];
    NSString* retStr = content;
    // 4桁以上の半角数字は全角におきかえる(英数字を含まない場合)
    BOOL isEiji = NO;
    NSString* pattern = @"([a-z]|[A-Z])";
    NSRegularExpression* reg = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray* matchs = [reg matchesInString:retStr options:0 range:NSMakeRange(0, [retStr length])];
    for(NSTextCheckingResult* res in matchs)
    {
        NSString* regStr = [retStr substringWithRange:[res range]];
        
        if([regStr compare:@""] != NSOrderedSame)
        {
            isEiji=YES;
            break;
        }
    }
    if(!isEiji){
        retStr = [self replaceHalfNumToFullNum:retStr];
    }
    
    return retStr;
}

- (void)getInfo:(NSString*)txt data:(TableData* __autoreleasing *)data
{
    __block int lineNum = 0;
    [txt enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        NSString* trimmed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        trimmed = [trimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([trimmed compare:@""] != NSOrderedSame){
            lineNum++;
            NSString* topStr = [trimmed substringWithRange:NSMakeRange(0, 3)];
            BOOL isKoron = [Macros isExistString:trimmed searchStr:@":"];
            if(isKoron &&(
               [Macros isExistString:topStr searchStr:@"サブ"] ||
               [Macros isExistString:topStr searchStr:@"メイン"] ||
               [Macros isExistString:topStr searchStr:@"著者"]))
            {
                NSNumber* firstPos = [[Macros searchCharPosition:line searchChar:@":"] objectAtIndex:0];
                NSString* content = [line substringWithRange:NSMakeRange([firstPos intValue]+1, [line length] - [firstPos intValue] - 1)];
                if(lineNum==1)
                {
                    if([Macros isExistString:line searchStr:@"サブ"])
                        [*data setPreSub:[self createTitleContent:content]];
                    else if([Macros isExistString:line searchStr:@"メイン"])
                        [*data setBookTitle:[self createTitleContent:content]];
                    else
                        [*data setAddStatus:[NSString stringWithFormat:@"NG:(line:1)txt読み込みエラー, %@",line]];
                    
                }
                else if(lineNum==2)
                {
                    if([Macros isExistString:line searchStr:@"サブ"])
                        [*data setAfterSub:[self createTitleContent:content]];
                    else if([Macros isExistString:line searchStr:@"メイン"])
                        [*data setBookTitle:[self createTitleContent:content]];
                    else if([Macros isExistString:line searchStr:@"著者"])
                        [*data setAuthor:content];
                    else
                        [*data setAddStatus:[NSString stringWithFormat:@"NG:(line:2)txt読み込みエラー, %@",line]];
                }
                else if(lineNum==3)
                {
                    if([Macros isExistString:line searchStr:@"サブ"])
                        [*data setAfterSub:[self createTitleContent:content]];
                    else if([Macros isExistString:line searchStr:@"著者"])
                        [*data setAuthor:content];
                    else
                        [*data setAddStatus:[NSString stringWithFormat:@"NG:(line:3)txt読み込みエラー, %@",line]];
                }
                else if(lineNum==4){
                    if([Macros isExistString:line searchStr:@"著者"])
                        [*data setAuthor:content];
                    else
                        [*data setAddStatus:[NSString stringWithFormat:@"NG:(line:4)txt読み込みエラー, %@",line]];
                }
                else
                {
                    [*data setAddStatus:@"NG:5行以上の指定紙には未対応です"];
                }
            }
            
        }
    }];
    
    return;
}

- (void)unzip:(NSString*)inFile toFolder:(NSString*)folderPath
{
    NSString* command1 = [[[[@"unzip -o \"" stringByAppendingString:inFile]
                            stringByAppendingString:@"\" -d \""]
                           stringByAppendingString:folderPath]
                          stringByAppendingString:@"\""];
    NSArray* command = ARRAY(@"-c", command1);
    [Macros doShellScript:command];
}

-(void)openNyuukou:(NSString*)curDir
{
    NSArray* arFiles = [Macros getFileList:openFolder deep:NO onlyDir:NO];
    NSArray* arDir = [Macros getFileList:openFolder deep:NO onlyDir:YES];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* tmpDir = [RESPATH stringByAppendingPathComponent:@"tmp"];
    
    if(![fm fileExistsAtPath:tmpDir])
    {
        [fm createDirectoryAtPath:tmpDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        // zipを全て解凍
        for(NSString* file in arFiles)
        {
            if([file hasSuffix:@"zip"] || [file hasSuffix:@"ZIP"])
            {
                NSString* filePath = [openFolder stringByAppendingPathComponent:file];
                [self unzip:filePath toFolder:tmpDir];
                [self controlNyuukouData:[tmpDir stringByAppendingPathComponent:[Macros getFileName:file]]];
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    ctrl.content = dataArray;
                    [dataTable noteNumberOfRowsChanged];
                    [dataTable reloadData];
                });
            }
        }
        
        NSArray* arMelted = [Macros getFileList:tmpDir deep:NO onlyDir:YES];
        
        for(NSString* folder in arDir){
            BOOL isSameDir = NO;
            for(NSString* melt in arMelted){
                if([folder compare:melt] == NSOrderedSame){
                    isSameDir = YES;
                    break;
                }
            }
            if(!isSameDir){
                [fm copyItemAtPath:[openFolder stringByAppendingPathComponent:folder]
                            toPath:[tmpDir stringByAppendingPathComponent:folder]
                             error:nil];
                
                [self controlNyuukouData:[tmpDir stringByAppendingPathComponent:folder]];
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    ctrl.content = dataArray;
                    [dataTable noteNumberOfRowsChanged];
                    [dataTable reloadData];
                });
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [btnMake setNeedsDisplay];
            [btnClear setNeedsDisplay];
            [sts setString:@"読み込み完了"];
        });
    });
}

-(void)controlNyuukouData:(NSString*)folderPath
{
    NSError* error = NULL;
    
    NSArray* arInternalFiles = [Macros getFileList:folderPath deep:YES onlyDir:NO];
    TableData* d = [TableData data];
    for(NSString* inFile in arInternalFiles)
    {
        if([inFile hasSuffix:@"txt"] || [inFile hasSuffix:@"TXT"])
        {
            NSString* txtStream;
            txtStream = [[NSString alloc] initWithContentsOfFile:[folderPath stringByAppendingPathComponent:inFile] usedEncoding:nil error:&error];
            /*NSStringEncoding encodings[] = {
                NSShiftJISStringEncoding,
                NSUTF8StringEncoding,
                NSUnicodeStringEncoding,
                NSASCIIStringEncoding,
                NSNEXTSTEPStringEncoding,
                NSJapaneseEUCStringEncoding,
                NSISOLatin1StringEncoding,
                NSSymbolStringEncoding,
                NSNonLossyASCIIStringEncoding,
                NSISOLatin2StringEncoding,
                NSWindowsCP1251StringEncoding,
                NSWindowsCP1252StringEncoding,
                NSWindowsCP1253StringEncoding,
                NSWindowsCP1254StringEncoding,
                NSWindowsCP1250StringEncoding,
                NSISO2022JPStringEncoding,
                NSMacOSRomanStringEncoding,
                NSUTF16StringEncoding,
                NSUTF16BigEndianStringEncoding,
                NSUTF16LittleEndianStringEncoding,
                NSUTF32StringEncoding,
                NSUTF32BigEndianStringEncoding,
                NSUTF32LittleEndianStringEncoding,
                0
            };
            NSStringEncoding *ptr = encodings;
            do  {
                //[folderPath stringByAppendingPathComponent:inFile] encoding:*ptr error:&error];
            } while (!txtStream && *(++ptr));
            
            */
            if(error != nil){
                
                NSLog(@"%@",[error localizedFailureReason]);
                NSLog(@"%@",[error localizedRecoverySuggestion]);
                NSLog(@"%@",[error localizedRecoveryOptions]);
                NSLog(@"%@",[error localizedDescription]);
                error=nil;
                NSStringEncoding encodings[] = {
                    NSShiftJISStringEncoding,
                    NSUTF8StringEncoding,
                    NSUnicodeStringEncoding,
                    NSASCIIStringEncoding,
                    NSNEXTSTEPStringEncoding,
                    NSJapaneseEUCStringEncoding,
                    NSISOLatin1StringEncoding,
                    NSSymbolStringEncoding,
                    NSNonLossyASCIIStringEncoding,
                    NSISOLatin2StringEncoding,
                    NSWindowsCP1251StringEncoding,
                    NSWindowsCP1252StringEncoding,
                    NSWindowsCP1253StringEncoding,
                    NSWindowsCP1254StringEncoding,
                    NSWindowsCP1250StringEncoding,
                    NSISO2022JPStringEncoding,
                    NSMacOSRomanStringEncoding,
                    NSUTF16StringEncoding,
                    NSUTF16BigEndianStringEncoding,
                    NSUTF16LittleEndianStringEncoding,
                    NSUTF32StringEncoding,
                    NSUTF32BigEndianStringEncoding,
                    NSUTF32LittleEndianStringEncoding,
                    0
                };
                NSStringEncoding *ptr = encodings;
                do  {
                    txtStream = [[NSString alloc] initWithContentsOfFile:[folderPath stringByAppendingPathComponent:inFile] encoding:*ptr error:&error];
                } while (!txtStream && *(++ptr));
                if(error != nil){
                    d.addStatus = @"NG:テキスト読み込みエラー";
                    break;
                }
            }
            [self getInfo:txtStream data:&d];
            if([d.filePath compare:@""] != NSOrderedSame) break;
        }
        else if([inFile hasSuffix:@"eps"] || [inFile hasSuffix:@"EPS"] ||
                [inFile hasSuffix:@"ai"] || [inFile hasSuffix:@"AI"]){
            d.filePath = [folderPath stringByAppendingPathComponent:inFile];
            if([d.bookTitle compare:@""] != NSOrderedSame) break;
        }
    }
    
    [dataArray addObject:d];
}

-(IBAction)openZip:(id)sender
{
    [sts setString:@""];
    NSArray* arOpenFolder = [Macros openFileDialog:@"ボーズの入稿ファイルが格納されているフォルダを選んで下さい" title:@"Open Zip Folder" multiple:NO selectFile:NO selectDir:YES];
    if(arOpenFolder.count == 0) return;
    
    openFolder = [arOpenFolder objectAtIndex:0];
    [self openNyuukou:openFolder];
    
}

-(IBAction)clearTable:(id)sender
{
    if(dataArray.count  == 0) return;
    for(int i = 0; i < dataArray.count; i++){
        NSFileManager* fm = [NSFileManager defaultManager];
        NSString* folder = [Macros getCurDir:[[dataArray objectAtIndex:i] filePath]];
        if([fm fileExistsAtPath:folder]){
            [fm trashItemAtURL:[NSURL fileURLWithPath:folder] resultingItemURL:nil error:nil];
        }
    }
    [dataArray removeAllObjects];
    ctrl.content = dataArray;
    [dataTable noteNumberOfRowsChanged];
    [dataTable reloadData];
    [sts setString:@""];
}

-(IBAction)make:(id)sender
{
    [sts setString:@""];
    NSArray* arContent = [[ctrl arrangedObjects] copy];
    NSFileManager* fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:[RESPATH stringByAppendingPathComponent:@"funcs.jsx"]]){
        [set append:self];
    }
    if([[[set UpperX1] stringValue] compare:@""] == NSOrderedSame ||
       [[[set UpperY1] stringValue] compare:@""] == NSOrderedSame ||
       [[[set UpperX2] stringValue] compare:@""] == NSOrderedSame ||
       [[[set UpperY2] stringValue] compare:@""] == NSOrderedSame ||
       [[[set LowerX1] stringValue] compare:@""] == NSOrderedSame ||
       [[[set LowerY1] stringValue] compare:@""] == NSOrderedSame ||
       [[[set LowerX2] stringValue] compare:@""] == NSOrderedSame ||
       [[[set LowerY2] stringValue] compare:@""] == NSOrderedSame ||
       [[[set AuthUpperX] stringValue] compare:@""] == NSOrderedSame ||
       [[[set AuthUpperY] stringValue] compare:@""] == NSOrderedSame ||
       [[[set AuthLowerX] stringValue] compare:@""] == NSOrderedSame ||
       [[[set AuthLowerY] stringValue] compare:@""] == NSOrderedSame)
    {
        NSAlert* al = [[NSAlert alloc] init];
        [al setInformativeText:@"初期設定が行われていません"];
        [al setMessageText:@"テンプレートの設定を行ってください"];
        [al runModal];
    }
    NSMutableDictionary* table = [NSMutableDictionary dictionary];
    AdobeGeometric* upper = [AdobeGeometric geometric];
    upper.x1 = [[set UpperX1] floatValue];
    upper.x2 = [[set UpperX2] floatValue];
    upper.y1 = [[set UpperY1] floatValue];
    upper.y2 = [[set UpperY2] floatValue];
    AdobeGeometric* lower = [AdobeGeometric geometric];
    lower.x1 = [[set LowerX1] floatValue];
    lower.x2 = [[set LowerX2] floatValue];
    lower.y1 = [[set LowerY1] floatValue];
    lower.y2 = [[set LowerY2] floatValue];
    AdobeGeometric* authGeo = [AdobeGeometric geometric];
    authGeo.x1 = [[set AuthUpperX] floatValue];
    authGeo.y1 = [[set AuthUpperY] floatValue];
    authGeo.x2 = [[set AuthLowerX] floatValue];
    authGeo.y2 = [[set AuthLowerY] floatValue];
    [table setObject:upper forKey:@"UP"];
    [table setObject:lower forKey:@"LOW"];
    [table setObject:authGeo forKey:@"AUTH"];
    [illustrator initializeVariable:table];
    
    BOOL isSame = ([[set samePath] state] == NSOnState)?YES:NO;
    NSString* savePath = @"";
    if(isSame){
        savePath = openFolder;
    }else{
        savePath = [[set savePath] stringValue];
    }
    NSMutableArray* finData = [NSMutableArray array];
    NSMutableArray* erDic=[NSMutableArray array];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [sts setString:@"作成中...."];
        });
        
        for(TableData* data in arContent){
            TableData* cpyData = [data copy];
            [self processIllustrator:&cpyData];
            if([data.addStatus compare:cpyData.addStatus] != NSOrderedSame){
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:data forKey:@"original"];
                [dic setObject:cpyData forKey:@"rep"];
                [erDic addObject:dic];
            }
            else{
                NSString* saveFilePath = [savePath stringByAppendingPathComponent:[Macros getFileName:data.filePath]];
                if([fm fileExistsAtPath:saveFilePath]){
                    [fm trashItemAtURL:[NSURL fileURLWithPath:saveFilePath] resultingItemURL:nil error:nil];
                }
                [illustrator saveCurrentFile:[savePath stringByAppendingPathComponent:[Macros getFileName:data.filePath]]];
                [fm trashItemAtURL:[NSURL fileURLWithPath:[Macros getCurDir:data.filePath]] resultingItemURL:nil error:nil];
                [finData addObject:data];
            }
        }
        dispatch_semaphore_signal(semaphore);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [sts setString:@"作成完了"];
        });
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    for(TableData* d in finData){
        [dataArray removeObject:d];
    }
    for(TableData* d in erDic){
        [dataArray replaceObjectAtIndex:[dataArray indexOfObject:d] withObject:d];
    }
    ctrl.content =dataArray;
    [dataTable noteNumberOfRowsChanged];
    [dataTable reloadData];
}

#pragma mark -
#pragma mark TableView DataSource
- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex
{
    NSMutableArray* arTmp = [[NSMutableArray alloc] initWithArray:dataArray];
    TableData* rowData = [dataArray objectAtIndex:rowIndex];
    
    if([[aTableColumn identifier] compare:@"PreSub"] == NSOrderedSame)
    {
        rowData.preSub = anObject;
    }
    else if([[aTableColumn identifier] compare:@"Title"] == NSOrderedSame)
    {
        rowData.bookTitle = anObject;
    }
    if([[aTableColumn identifier] compare:@"AfterSub"] == NSOrderedSame)
    {
        rowData.afterSub = anObject;
    }
    else if([[aTableColumn identifier] compare:@"Author"] == NSOrderedSame)
    {
        rowData.author = anObject;
    }
    
    [arTmp replaceObjectAtIndex:rowIndex withObject:rowData];
    dataArray = arTmp;
    ctrl.content = dataArray;
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
    if(tableView == dataTable){
        if([Macros isExistString:[[dataArray objectAtIndex:row] addStatus] searchStr:@"NG"]){
            NSTextFieldCell* c = cell;
            [c setBackgroundColor:[NSColor redColor]];
            [c setDrawsBackground:YES];
        }else
        {
            NSTextFieldCell* c = cell;
            [c setBackgroundColor:[NSColor whiteColor]];
            [c setDrawsBackground:YES];
        }
     }
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(NSInteger)rowIndex
{
    
    if([[aTableColumn identifier] compare:@"PreSub"] == NSOrderedSame)
    {
        return [[dataArray objectAtIndex:rowIndex] preSub];
    }
    else if([[aTableColumn identifier] compare:@"Title"] == NSOrderedSame)
    {
        return [[dataArray objectAtIndex:rowIndex] bookTitle];
    }
    else if([[aTableColumn identifier] compare:@"AfterSub"] == NSOrderedSame)
    {
        return [[dataArray objectAtIndex:rowIndex] afterSub];
    }
    else if([[aTableColumn identifier] compare:@"Author"] == NSOrderedSame)
    {
        return [[dataArray objectAtIndex:rowIndex] author];
    }
    else if([[aTableColumn identifier] compare:@"State"] == NSOrderedSame)
    {
        return [[dataArray objectAtIndex:rowIndex] addStatus];
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

- (BOOL)isContainZip:(NSString*)path
{
    BOOL isZip = NO;
    NSArray* arFiles = [Macros getFileList:path deep:NO onlyDir:NO];
    for(NSString* file in arFiles){
        if([file hasSuffix:@"zip"]){
            isZip = YES;
            break;
        }
    }
    return isZip;
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
        NSString* tmpDir = [RESPATH stringByAppendingPathComponent:@"tmp"];
        NSFileManager* fm = [NSFileManager defaultManager];
        BOOL isStatus = NO;
        [sts setString:@""];
        for(id file in theFiles)
        {
            if([Macros isDirectory:file])
            {
                if([self isContainZip:file]){
                    openFolder = file;
                    [self openNyuukou:openFolder];
                    isStatus=NO;
                }
                else{
                    openFolder = [Macros getCurDir:file];
                    NSArray* arFiles = [Macros getFileList:file deep:NO onlyDir:NO];
                    if(arFiles.count == 2){
                        [fm copyItemAtPath:file toPath:[tmpDir stringByAppendingPathComponent:[Macros getFileName:file]] error:nil];
                        [self controlNyuukouData:[tmpDir stringByAppendingPathComponent:[Macros getFileName:file]]];
                        ctrl.content = dataArray;
                        [dataTable noteNumberOfRowsChanged];
                        [dataTable reloadData];
                    }
                    isStatus=YES;
                }
            }
            else
            {
                openFolder = [Macros getCurDir:file];
                if([file hasSuffix:@"zip"] || [file hasSuffix:@"ZIP"]){
                    [self unzip:file toFolder:tmpDir];
                    [self controlNyuukouData:[tmpDir stringByAppendingPathComponent:[Macros getFileName:file]]];
                    ctrl.content = dataArray;
                    [dataTable noteNumberOfRowsChanged];
                    [dataTable reloadData];
                }
                isStatus=YES;
            }
        }
        if(isStatus) [sts setString:@"読み込み完了"];
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark NSTableView Delegate
- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    return YES;
}
@end
