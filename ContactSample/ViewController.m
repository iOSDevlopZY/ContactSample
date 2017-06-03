//
//  ViewController.m
//  ContactSample
//
//  Created by Developer_Yi on 2017/5/24.
//  Copyright © 2017年 medcare. All rights reserved.
//

#import "ViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "MBProgressHUD+Simple.h"
#import "BMChineseSort.h"
#import "AddContactViewController.h"
#import "ContactDetailViewController.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *contactArr;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contactArr=[NSMutableArray array];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self getAuth];
    }); 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题栏
    self.navigationItem.title=@"通讯录";
    [self setBarBtnItem];
    [self getAuth];
    [self setupTableView];
}
#pragma mark - 获得授权
- (void)getAuth
{
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    //用户授权
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {//首次访问通讯录会调用
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) return;
            if (granted) {//允许
                [self fetchContactWithContactStore:contactStore];//访问通讯录
                    [self.tableView reloadData];
               
            }else{//拒绝
                UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"无访问通讯录权限" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertVC addAction:action];
            }
        }];
    }else{
        [self fetchContactWithContactStore:contactStore];//访问通讯录
            [self.tableView reloadData];
    
    }
}
#pragma mark - 设置标题按钮
- (void)setBarBtnItem
{
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    UIBarButtonItem *refreshBtn=[[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refresh)];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(Edit:)];
    self.navigationItem.leftBarButtonItem=leftBtn;
    self.navigationItem.rightBarButtonItems=@[refreshBtn,rightBtn];
}
#pragma mark - 设置TableView
- (void)setupTableView
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
}
#pragma mark - 添加联系人
- (void)addContact
{
    AddContactViewController *vc=[[AddContactViewController alloc]init];
    [self.navigationController presentViewController:vc animated:YES completion:^{
        
    }];
}
#pragma mark - 刷新按钮
- (void)refresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        CNContactStore *contactStore=[[CNContactStore alloc]init];
        [self fetchContactWithContactStore:contactStore];//访问通讯录
        [self.tableView reloadData];
       
    });
}
#pragma mark - 编辑按钮
- (void)Edit:(UIBarButtonItem*)btnItem
{
    self.tableView.editing=!self.tableView.editing;
    if(self.tableView.editing)
    {
        //要想修改标题必须把整个按钮替换掉
         UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(Edit:)];
        self.navigationItem.leftBarButtonItem=leftBtn;
    }
    else
    {
        //要想修改标题必须把整个按钮替换掉
         UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(Edit:)];
        self.navigationItem.leftBarButtonItem=leftBtn;

    }
}
#pragma  mark - 访问通讯录
- (void)fetchContactWithContactStore:(CNContactStore*)store
{

    if(self.contactArr.count>0)
    {
        self.contactArr=nil;
        self.contactArr=[NSMutableArray array];
    }
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {//有权限访问
        NSError *error = nil;
        //创建数组,必须遵守CNKeyDescriptor协议,放入相应的字符串常量来获取对应的联系人信息
        NSArray <id<CNKeyDescriptor>> *keysToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey,CNContactImageDataKey,CNContactPostalAddressesKey];
        //创建获取联系人的请求
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        //遍历查询
        [store enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            if (!error) {
                [self.contactArr addObject:contact];
                    self.indexArray = [BMChineseSort IndexWithArray:self.contactArr Key:@"familyName"];
                    self.letterResultArr = [BMChineseSort sortObjectArray:self.contactArr Key:@"familyName"];
                
            }else{  
                NSLog(@"error:%@", error.localizedDescription);  
            }  
        }];
    }else{//无权限访问  
        NSLog(@"无权限访问");
    }
}
#pragma mark - TableView数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [self.indexArray count]+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    else
    {
          return [[self.letterResultArr objectAtIndex:section-1] count];
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
        cell.imageView.image=[UIImage imageNamed:@"Apple"];
        cell.textLabel.text=@"Apple";
        cell.userInteractionEnabled=false;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"本机号码:%@",@"+86 157-0542-7487"];
        return cell;
    }
    else
    {
        CNContact *contact=[[self.letterResultArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",contact.familyName,contact.givenName];
        return cell;
        
    }
}
#pragma mark- 每行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section!=0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CNContact *contact=[[self.letterResultArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        ContactDetailViewController *vc=[[ContactDetailViewController alloc]init];
        vc.contactName=[NSString stringWithFormat:@"%@ %@",contact.familyName,contact.givenName];
        CNLabeledValue *phoneNumber=[contact.phoneNumbers firstObject];
        CNPhoneNumber *phoneNum=phoneNumber.value;
        vc.contactPhone=phoneNum.stringValue;
        if(contact.imageData==nil||[contact.imageData isKindOfClass:[NSNull class]])
        {
            vc.contactImage=[UIImage imageNamed:@"contactIcon"];
        }
        else
        {
            vc.contactImage=[UIImage imageWithData:contact.imageData];
        }
        CNLabeledValue *address=[contact.postalAddresses firstObject];
        CNPostalAddress *contactAddress=address.value;
        vc.location=contactAddress.street;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 行高等设置
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 80;
    }
    else
    {
        return 40;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{if(section==0)
{
    return 0;
}
else
{
    return 25;
}
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==0)
    {
        return 0;
    }
    else
    {
        return 0;
    }
}
#pragma mark - 编辑删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
#pragma mark - 中文删除按钮
- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * a = @"删除";
    return a;
}
#pragma mark - 删除按钮回调事件
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section!=0)
    {
        CNMutableContact *deleteContact=[[[self.letterResultArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row]mutableCopy];
        // 创建联系人请求
        CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
        [saveRequest deleteContact:deleteContact];
        // 写入操作
        CNContactStore *store = [[CNContactStore alloc] init];
        NSError *error  = nil;
        [store executeSaveRequest:saveRequest error:&error];
        [self.letterResultArr removeObject: [[self.letterResultArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row]];
        [self.tableView reloadData];
    }
    [MBProgressHUD showOnlyText:@"删除成功，请点击刷新"];
}
#pragma mark - 头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexArray objectAtIndex:section-1];
}
#pragma mark - index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
#pragma mark - 点击右侧索引表时点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
@end
