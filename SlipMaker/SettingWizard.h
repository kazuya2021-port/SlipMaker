//
//  SettingWizard.h
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/05.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Setting.h"

@interface SettingWizard : NSObject
{
    IBOutlet NSWindow* win;
    IBOutlet NSTabView* tabview;
    
    IBOutlet Setting* set;
    IBOutlet ControllIllustrator* illustrator;
}
-(IBAction)openWizard:(id)sender;
-(IBAction)getUpPosTop:(id)sender;
-(IBAction)getUpPosDown:(id)sender;
-(IBAction)getLowPos:(id)sender;
-(IBAction)getAuthUpPos:(id)sender;
-(IBAction)getAuthLowPos:(id)sender;
@end
