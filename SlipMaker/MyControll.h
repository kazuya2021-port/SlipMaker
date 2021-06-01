//
//  MyControll.h
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/21.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyControll : NSArrayController<NSTableViewDataSource>
{
    NSMutableArray* dataArray;
}
@property (nonatomic, copy) NSMutableArray* dataArray;
@end
