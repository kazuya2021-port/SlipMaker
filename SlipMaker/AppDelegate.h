//
//  AppDelegate.h
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/05.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TableData.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,NSWindowDelegate>
{
    IBOutlet ControllIllustrator* c;
    IBOutlet NSArrayController* ctrl;
}

@end

