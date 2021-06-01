//
//  Toolbars.h
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/05.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Toolbars : NSObject <NSToolbarDelegate>
{
    NSWindow                *window;
    IBOutlet NSPanel        *posPanel;
    NSToolbar               *toolbar;
    IBOutlet NSTabView      *tab;
}
@property (nonatomic, weak) IBOutlet NSWindow   *window;
- (IBAction)openTemplate:(id)sender;
@end
