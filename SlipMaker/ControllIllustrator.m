//
//  ControllIllustrator.m
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/05.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "ControllIllustrator.h"

@implementation ControllIllustrator

- (void)awakeFromNib
{
    useApp = @"";
    NSArray* arFiles = [Macros getFileList:@"/Applications/" deep:NO onlyDir:YES];
    NSMutableArray* arApps = [NSMutableArray array];
    for(NSString* fol in arFiles)
    {
        if([Macros isExistString:fol searchStr:@"Adobe Illustrator"])
        {
            NSString* appPath = [@"/Applications/" stringByAppendingPathComponent:fol];
            NSArray* arContents = [Macros getFileList:appPath deep:NO onlyDir:YES];
            for(NSString* app in arContents)
            {
                if([app hasSuffix:@"app"]){
                    [arApps addObject:[appPath stringByAppendingPathComponent:app]];
                    break;
                }
            }
        }
    }
    if(arApps.count == 0)
    {
        NSAlert* al = [[NSAlert alloc] init];
        [al setInformativeText:@"Illustrator がインストールされていません"];
        [al runModal];
        return;
    }
    for(NSString* appPath in arApps)
    {
        if([Macros isExistString:appPath searchStr:@"CS6"]){
            useApp = appPath;
        }
    }
    if([useApp compare:@""]==NSOrderedSame){
        useApp = [arApps objectAtIndex:0];
    }
    useProcess = [[useApp stringByDeletingLastPathComponent] lastPathComponent];
}

- (void)initializeVariable:(NSMutableDictionary*)allPos
{
    upTitle = [allPos objectForKey:@"UP"];
    lowTitle = [allPos objectForKey:@"LOW"];
    authGeo = [allPos objectForKey:@"AUTH"];
}
- (NSAppleEventDescriptor*)executeScript:(NSString*) source
{
    [self runApplication];
    NSError* err;
    NSDictionary  *asErrDic = nil;
    [source writeToURL:[NSURL fileURLWithPath:@"/Applications/FACILIS Supremo/OutPDF/test.applescript"] atomically:NO encoding:NSUTF8StringEncoding error:&err];
    NSAppleScript* as = [[NSAppleScript alloc] initWithSource:source];
    NSAppleEventDescriptor* result = [as executeAndReturnError : &asErrDic ];
    if ( asErrDic ) {
        NSLog(@"%@",[asErrDic objectForKey:NSAppleScriptErrorMessage]);
        return nil;
    }
    return result;
}

-(void)waitReadFile
{
    NSString* ass = [NSString stringWithFormat:@""
                     "with timeout of (1 * 60 * 60) seconds\n"
                     "    tell application \"%@\"\n"
                     "        set chk to \"%@\"\n"
                     "        do javascript(file chk)\n"
                     "    end tell\n"
                     "end timeout",
                     useApp,
                     [RESPATH stringByAppendingPathComponent:@"checkOpened.jsx"]];
    while(1)
    {
        id res = [self executeScript:ass];
        if([[res stringValue] compare:@"true"] == NSOrderedSame)
        {
            break;
        }
        [NSThread sleepForTimeInterval:0.5];
    }
    return;
}

-(void)runApplication
{
    NSString* ass = [NSString stringWithFormat:@""
                     "if application \"%@\" is not running then\n"
                     "    tell application \"%@\"\n"
                     "    end tell\n"
                     "end if\n",
                     useApp,
                     useApp];
    NSDictionary  *asErrDic = nil;
    NSAppleScript* as = [[NSAppleScript alloc] initWithSource:ass];
    [ass writeToURL:[NSURL fileURLWithPath:@"/Applications/FACILIS Supremo/OutPDF/test.applescript"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    [as executeAndReturnError : &asErrDic ];
    if ( asErrDic ) {
        NSLog(@"%@",[asErrDic objectForKey:NSAppleScriptErrorMessage]);
        return;
    }
    return;
}
// 著者
-(BOOL)addAuthor:(NSString*)author
{
    NSString* scriptPath = [RESPATH stringByAppendingPathComponent:@"placeAuthor.jsx"];
    NSString* ass = [NSString stringWithFormat:@""
                     "with timeout of (1 * 60 * 60) seconds\n"
                     "    tell application \"%@\"\n"
                     "        set val to (do javascript (file \"%@\") with arguments {\"%@\", %.11lf, %.11lf, %.11lf, %.11lf})\n"
                     "    end tell\n"
                     "    return val\n"
                     "end timeout",
                     useApp,
                     scriptPath,
                     author,
                     authGeo.x1, authGeo.y1, authGeo.x2, authGeo.y2];
    NSAppleEventDescriptor* res = [self executeScript:ass];
    
    if([[res stringValue] compare:@"NG"]==NSOrderedSame){
        return NO;
    }
    
    return YES;
}

// 書名
-(BOOL)addTitle:(NSString*)title preSub:(NSString*)pre afterSub:(NSString*)aft
{
    NSString* scriptPath = [RESPATH stringByAppendingPathComponent:@"placeTitle.jsx"];
    NSString* ass = [NSString stringWithFormat:@""
                     "with timeout of (1 * 60 * 60) seconds\n"
                     "    tell application \"%@\"\n"
                     "        set val to (do javascript (file \"%@\") with arguments {\"%@\", \"%@\", \"%@\", %.11lf, %.11lf, %.11lf, %.11lf, %.11lf, %.11lf, %.11lf, %.11lf, %.11lf, %.11lf})\n"
                     "    end tell\n"
                     "    return val\n"
                     "end timeout",
                     useApp, scriptPath,
                     pre, title, aft,
                     upTitle.x1, upTitle.y1, upTitle.x2, upTitle.y2,
                     lowTitle.x1, lowTitle.y1, lowTitle.x2, lowTitle.y2,
                     authGeo.y1, authGeo.x1];
    NSAppleEventDescriptor* res = [self executeScript:ass];
    
    if([[res stringValue] compare:@"NG"]==NSOrderedSame){
        return NO;
    }
    
    return YES;
}

-(void)minWindow
{
    NSString* ass = [NSString stringWithFormat:@""
                     "tell application \"System Events\"\n"
                     "  tell process \"%@\"\n"
                     "      try\n"
                     "          click menu item \"ウィンドウを最小化\" of menu \"アレンジ\" of menu item \"アレンジ\" of menu \"ウィンドウ\" of menu bar item \"ウィンドウ\" of menu bar 1\n"
                     "      end try\n"
                     "  end tell\n"
                     "end tell\n",
                     useProcess];
    [self executeScript:ass];
    
}

-(BOOL)deleteTemplateStringUp
{
    //[self minWindow];
    NSString* scriptPath = [RESPATH stringByAppendingPathComponent:@"deleteTemplate.jsx"];
    NSString* ass = [NSString stringWithFormat:@""
                     "with timeout of (1 * 60 * 60) seconds\n"
                     "    tell application \"%@\"\n"
                     "        set val to (do javascript (file \"%@\") with arguments {%.11lf, %.11lf, %.11lf, %.11lf})\n"
                     "    end tell\n"
                     "    return val\n"
                     "end timeout",
                     useApp,
                     scriptPath,
                     upTitle.x1, upTitle.y1, upTitle.x2, upTitle.y2];
    
    NSAppleEventDescriptor* res = [self executeScript:ass];
    if([[res stringValue] compare:@"NG"]==NSOrderedSame){
        return NO;
    }

    return YES;
}

-(BOOL)deleteTemplateStringDown
{
    NSString* scriptPath = [RESPATH stringByAppendingPathComponent:@"deleteTemplate.jsx"];
    NSString* ass = [NSString stringWithFormat:@""
                     "with timeout of (1 * 60 * 60) seconds\n"
                     "    tell application \"%@\"\n"
                     "        set val to (do javascript (file \"%@\") with arguments {%.11lf, %.11lf, %.11lf, %.11lf})\n"
                     "    end tell\n"
                     "    return val\n"
                     "end timeout",
                     useApp,
                     scriptPath,
                     lowTitle.x1, lowTitle.y1, lowTitle.x2, (double)684.0]; // 下部の数字消してしまうため
    
    NSAppleEventDescriptor* res = [self executeScript:ass];
    
    if([[res stringValue] compare:@"NG"]==NSOrderedSame){
        return NO;
    }
    
    return YES;
}

-(BOOL)deleteTemplateStringAuthor
{
    NSString* scriptPath = [RESPATH stringByAppendingPathComponent:@"deleteTemplate.jsx"];
    NSString* ass = [NSString stringWithFormat:@""
                     "with timeout of (1 * 60 * 60) seconds\n"
                     "    tell application \"%@\"\n"
                     "        set val to (do javascript (file \"%@\") with arguments {%.11lf, %.11lf, %.11lf, %.11lf})\n"
                     "    end tell\n"
                     "    return val\n"
                     "end timeout",
                     useApp,
                     scriptPath,
                     authGeo.x1, authGeo.y1+2, authGeo.x2, authGeo.y2];
    
    NSAppleEventDescriptor* res = [self executeScript:ass];
    
    if([[res stringValue] compare:@"NG"]==NSOrderedSame){
        return NO;
    }
    
    return YES;
}

-(void)saveCurrentFile:(NSString*)savePath
{
    NSString* ass = [NSString stringWithFormat:@""
                     "with timeout of (1 * 60 * 60) seconds\n"
                     "    tell application \"%@\"\n"
                     "      save current document in file \"%@\" as eps with options ¬\n"
                     "      {class:EPS save options ¬\n"
                     "      , embed all fonts:true }\n"
                     "      close current document saving no\n"
                     "    end tell\n"
                     "end timeout",
                     useApp,
                     savePath];
    
    [self executeScript:ass];
    
    return;
}

-(AdobeGeometric*)getPosition
{
    NSString* ass = [NSString stringWithFormat:@""
                     "with timeout of (1 * 60 * 60) seconds\n"
                     "    tell application \"%@\"\n"
                     "        do javascript (\"\n"
                     "        #target \\\"illustrator\\\"\n"
                     "        app.coordinateSystem = CoordinateSystem.ARTBOARDCOORDINATESYSTEM;\n"
                     "        (function(){\n"
                     "            var docs = app.documents;\n"
                     "            try{\n"
                     "                if(docs.length != 1){\n"
                     "                    throw new Error(\\\"ドキュメントは一つだけ開いて下さい\\\");\n"
                     "                }\n"
                     "                var objs = docs[0].selection;\n"
                     "                if(objs.length != 0){\n"
                     "                    var totalGeo = objs[0].geometricBounds;\n"
                     "                    for(i = 0; i < objs.length; i++){\n"
                     "                            if(totalGeo[0] > objs[i].geometricBounds[0]){\n"
                     "                                totalGeo[0] = objs[i].geometricBounds[0];}\n"
                     "                            if((totalGeo[1]*-1) > (objs[i].geometricBounds[1]*-1)){\n"
                     "                                totalGeo[1] = objs[i].geometricBounds[1];}\n"
                     "                            if(totalGeo[2] < objs[i].geometricBounds[2]){\n"
                     "                                totalGeo[2] = objs[i].geometricBounds[2];}\n"
                     "                            if((totalGeo[3]*-1) < (objs[i].geometricBounds[3]*-1)){\n"
                     "                                totalGeo[3] = objs[i].geometricBounds[3];}\n"
                     "                    }\n"
                     "                    return totalGeo;\n"
                     "                }else{\n"
                     "                    throw new Error(\\\"オブジェクトが選択されていません\\\");\n"
                     "                }\n"
                     "            }catch(e){\n"
                     "                alert(e.message, \\\"スクリプト警告\\\", true);\n"
                     "            }\n"
                     "        })()\")\n"
                     "    end tell\n"
                     "end timeout",
                     useApp];
    NSString* retStr = [[self executeScript:ass] stringValue];
    NSArray* arGeoBounds = [retStr componentsSeparatedByString:@","];
    AdobeGeometric* ret = [[AdobeGeometric alloc] init];
    ret.x1 = [[arGeoBounds objectAtIndex:0] doubleValue];
    ret.x2 = [[arGeoBounds objectAtIndex:2] doubleValue];
    ret.y1 = [[arGeoBounds objectAtIndex:1] doubleValue] * -1;
    ret.y2 = [[arGeoBounds objectAtIndex:3] doubleValue] * -1;
    return ret;
}
@end
