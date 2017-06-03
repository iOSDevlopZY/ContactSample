//
//  ContactDetailViewController.h
//  ContactSample
//
//  Created by Developer_Yi on 2017/5/28.
//  Copyright © 2017年 medcare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactDetailViewController : UIViewController
@property (nonatomic,copy)NSString *contactName;
@property (nonatomic,copy)NSString *location;
@property (nonatomic,copy)NSString *contactPhone;
@property (nonatomic,strong)UIImage *contactImage;
@end
