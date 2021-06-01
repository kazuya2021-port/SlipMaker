//
//  StatusView.h
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/22.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusView : NSView
{
    IBOutlet NSTextField* statusString;
}
-(void)setString:(NSString*)str;
@end
