//
//  AppDelegate.m
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/05.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *tbl;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    NSArray* dataArray = ctrl.arrangedObjects;
    if(dataArray.count  == 0) return YES;
    for(int i = 0; i < dataArray.count; i++){
        NSFileManager* fm = [NSFileManager defaultManager];
        NSString* folder = [Macros getCurDir:[[dataArray objectAtIndex:i] filePath]];
        if([fm fileExistsAtPath:folder]){
            [fm trashItemAtURL:[NSURL fileURLWithPath:folder] resultingItemURL:nil error:nil];
        }
    }
    return YES;
}

- (void)windowDidResize:(NSNotification *)notification;
{
    NSArray* arCol = [_tbl tableColumns];
    NSRect b = [[_window contentView] bounds];
    NSSize tblSize = NSMakeSize(b.size.width - 181, b.size.height);
    CGFloat colWidth = tblSize.width / 4;
    for(NSTableColumn* col in arCol){
        if([[col identifier] compare:@"State"]!=NSOrderedSame){
            [col setMinWidth:colWidth];
            [col setMaxWidth:colWidth];
        }
    }
    [_tbl viewWillDraw];
}
@end
