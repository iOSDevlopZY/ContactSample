//
//  HUDView+Extension.h
//  shangcheng
//
//  Created by wxl on 15/7/5.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Simple)
+ (id)showOnlyText:(NSString*)text;
+ (id)showIndicatorWithText:(NSString*)text;
+ (void)hide;
@end
