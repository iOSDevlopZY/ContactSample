//
//  AddContactViewController.m
//  ContactSample
//
//  Created by Developer_Yi on 2017/5/31.
//  Copyright © 2017年 medcare. All rights reserved.
//

#import "AddContactViewController.h"
#import <Contacts/Contacts.h>
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface AddContactViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UITextField *nameTF;
@property (nonatomic,strong)UITextField *nameTF1;
@property (nonatomic,strong)UITextField *telTF;
@property (nonatomic,strong)UIButton *rightBtn;
@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
#pragma mark -设置UI
- (void)setupUI {
    self.view.backgroundColor=[UIColor whiteColor];
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, screenWidth, 44)];
    titleView.backgroundColor=[UIColor whiteColor];
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 12, screenWidth*0.2, 20)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithRed:34/255.0f green:121/255.0f blue:238/255.0f alpha:1]forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.font=[UIFont systemFontOfSize:17];
    [titleView addSubview:leftBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.3, 12, screenWidth*0.4, 20)];
    titleLabel.text=@"新建联系人";
    titleLabel.font=[UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    
    self.rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(screenWidth*0.8, 12, screenWidth*0.2, 20)];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(Done) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.font=[UIFont boldSystemFontOfSize:17];
    [self.rightBtn setUserInteractionEnabled:NO];
    [titleView addSubview:self.rightBtn];
    [self.view addSubview:titleView];
    
    self.iconView=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth*0.05, 70, 50, 50 )];
    self.iconView.userInteractionEnabled=YES;
    UITapGestureRecognizer *reg=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(icon)];
    [self.iconView addGestureRecognizer:reg];
    self.iconView.layer.masksToBounds=YES;
    self.iconView.layer.cornerRadius=25;
    self.iconView.image=[UIImage imageNamed:@"AddIcon"];
    [self.view addSubview:self.iconView];
    
    self.nameTF=[[UITextField alloc]initWithFrame:CGRectMake(screenWidth*0.25, 60, screenWidth*0.7, 44)];
    self.nameTF.placeholder=@"姓氏";
    UIView *underLineOne=[[UIView alloc]initWithFrame:CGRectMake(screenWidth*0.25, 104, screenWidth*0.7, 0.5)];
    underLineOne.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:self.nameTF];
    [self.view addSubview:underLineOne];
    
    self.nameTF1=[[UITextField alloc]initWithFrame:CGRectMake(screenWidth*0.25, 110, screenWidth*0.7, 44)];
    self.nameTF1.placeholder=@"名字";
    UIView *underLineTwo=[[UIView alloc]initWithFrame:CGRectMake(screenWidth*0.25, 154, screenWidth*0.7, 0.5)];
    underLineTwo.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:self.nameTF1];
    [self.view addSubview:underLineTwo];
    
    UILabel *telLabel=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.07, 170, screenWidth*0.17, 43)];
    telLabel.text=@"电话";
    [self.view addSubview:telLabel];
    
    self.telTF=[[UITextField alloc]initWithFrame:CGRectMake(screenWidth*0.25, 170, screenWidth*0.65, 44)];
    [self.view addSubview:self.telTF];
    
    UIView *underLineThree=[[UIView alloc]initWithFrame:CGRectMake(screenWidth*0.07, 214, screenWidth*0.88, 0.5)];
    underLineThree.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:underLineThree];
    self.nameTF.delegate=self;
    self.nameTF1.delegate=self;
    self.telTF.delegate=self;
}
#pragma mark -取消
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^{
      
    }];
}
#pragma mark -完成
- (void)Done
{
    if([self.nameTF.text isEqualToString:@""]||self.nameTF.text==nil||[self.nameTF1.text isEqualToString:@"" ]||self.nameTF1.text==nil||[self.telTF.text isEqualToString:@""]||self.telTF.text==nil)
    {
        UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"" message:@"请将信息填写完整" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }
    else
    {
        //上传联系人
        CNMutableContact * contact = [[CNMutableContact alloc]init];
        if([self.iconView.image isEqual:[UIImage imageNamed:@"AddIcon"]])
        {
            contact.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"contactIcon"]);
        }
        else
        {
            contact.imageData = UIImagePNGRepresentation(self.iconView.image);
        }
                 //设置名字
                contact.givenName = self.nameTF1.text;
                 //设置姓氏
                contact.familyName = self.nameTF.text;
        
                contact.phoneNumbers = @[[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:self.telTF.text]]];
                 //    //初始化方法
                CNSaveRequest * saveRequest = [[CNSaveRequest alloc]init];
                 //    添加联系人（可以）
                [saveRequest addContact:contact toContainerWithIdentifier:nil];
                 //    写入
                 CNContactStore * store = [[CNContactStore alloc]init];
                 [store executeSaveRequest:saveRequest error:nil];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
}
#pragma mark -上传头像
- (void)icon
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.tintColor = [UIColor blackColor];
    //通过拍照上传图片
    UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    }];
    //从手机相册中选择上传图片
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:takingPicAction];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
   [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -相册代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //把newPhono设置成头像
    _iconView.image = newPhoto;
    //关闭当前界面，即回到主界面去
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - textField代理
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.nameTF.text!=nil||self.nameTF1.text!=nil||self.telTF.text!=nil)
    {
         [self.rightBtn setUserInteractionEnabled:YES];
         [self.rightBtn setTitleColor:[UIColor colorWithRed:34/255.0f green:121/255.0f blue:238/255.0f alpha:1]forState:UIControlStateNormal];
    }
}
@end
