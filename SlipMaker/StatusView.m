//
//  StatusView.m
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/22.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "StatusView.h"

@implementation StatusView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)setString:(NSString*)str{
    [statusString setStringValue:str];
}
@end
