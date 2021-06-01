//
//  MainTab.h
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/07.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControllIllustrator.h"
#import "Setting.h"
#import "MyControll.h"
#import "TableData.h"
#import "StatusView.h"

@interface MainTab : NSObject <NSTableViewDelegate,NSTableViewDataSource>
{
    IBOutlet NSTextField* textAuth;
    IBOutlet NSTextField* textTitle;
    IBOutlet NSTextField* textSubTitlePre;
    IBOutlet NSTextField* textSubTitle;
    
    IBOutlet NSTableView* dataTable;
    IBOutlet NSArrayController* ctrl;
    NSMutableArray* dataArray;
    IBOutlet Setting* set;
    IBOutlet ControllIllustrator* illustrator;
    
    IBOutlet NSButton* btnClear;
    IBOutlet NSButton* btnMake;
    IBOutlet StatusView* sts;
    
    NSString* openFolder;
}

-(IBAction)openZip:(id)sender;
-(IBAction)clearTable:(id)sender;
-(IBAction)make:(id)sender;
@end
