//
//  Toolbars.m
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/05.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "Toolbars.h"

@implementation Toolbars
@synthesize window = _window;

#pragma mark -
#pragma mark initialize

- (void)awakeFromNib
{
    // NSToolbarのインスタンスを作ります
    toolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbarForSlipMaker"];
    
    // ツールバーを設定します
    [toolbar setDelegate:self];
    [toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
    [toolbar setAllowsUserCustomization:YES];
    
    [_window setToolbar:toolbar];
}

#pragma mark -
#pragma mark Toolbar SelectorFunction
- (void)OpenSettingWindow:(id)sender
{
    [tab selectTabViewItemWithIdentifier:@"setting"];
}

- (void)MainTab:(id)sender
{
    [tab selectTabViewItemWithIdentifier:@"main"];
}

#pragma mark -
#pragma mark NSToolbar delegate methods

static NSString*    openSettingIdentifier = @"openSetting";
static NSString*    openXLSIdentifier = @"openExcel";

- (NSArray*)validToolBarItems
{
    return ARRAY(openXLSIdentifier,
                 openSettingIdentifier,
                 NSToolbarSpaceItemIdentifier,
                 NSToolbarCustomizeToolbarItemIdentifier);
}
- (NSArray*)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
    // 識別子の配列を返します
    return [self validToolBarItems];
}

- (NSArray*)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar_
{
    return [self validToolBarItems];
}

- (NSArray*)toolbarSelectableItemIdentifiers:(NSToolbar*)toolbar_
{
    return [self validToolBarItems];
}

- (NSToolbarItem*)toolbar:(NSToolbar*)toolbar
    itemForItemIdentifier:(NSString*)itemId
willBeInsertedIntoToolbar:(BOOL)willBeInserted
{
    // NSToolbarItem を作ります
    NSToolbarItem*  toolbarItem;
    toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemId];
    [toolbarItem setTarget:self];
    
    // NSToolbarItemを設定します
    if ([itemId compare:openSettingIdentifier] == NSOrderedSame) {
        [toolbarItem setLabel:@"設定"];
        [toolbarItem setImage:[NSImage imageNamed:@"Config.png"]];
        [toolbarItem setAction:@selector(OpenSettingWindow:)];
    }
    if ([itemId compare:openXLSIdentifier] == NSOrderedSame) {
        [toolbarItem setLabel:@"メイン"];
        [toolbarItem setImage:[NSImage imageNamed:@"Graph.png"]];
        [toolbarItem setAction:@selector(MainTab:)];
    }
    
    return toolbarItem;
}

- (IBAction)openTemplate:(id)sender
{
    [posPanel makeKeyAndOrderFront:self];
}
@end
