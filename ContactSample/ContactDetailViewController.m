//
//  ContactDetailViewController.m
//  ContactSample
//
//  Created by Developer_Yi on 2017/5/28.
//  Copyright © 2017年 medcare. All rights reserved.
//

#import "ContactDetailViewController.h"
#import <MapKit/MapKit.h>
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface ContactDetailViewController ()<MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *phoneRemindLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *LocationLabel;
@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

#pragma mark - 设置UI
- (void)setupUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2-75, screenHeight*0.15, 150, 150)];
    self.imageView.layer.masksToBounds=YES;
    self.imageView.layer.cornerRadius=75;
    self.imageView.image=self.contactImage;
    self.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    
    self.label=[[UILabel alloc]initWithFrame:CGRectMake(0, screenHeight*0.1+150, screenWidth, screenHeight*0.2)];
    self.label.text=self.contactName;
    self.label.font=[UIFont systemFontOfSize:25];
    self.label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
    self.phoneRemindLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, screenHeight*0.52, screenWidth*0.4, screenHeight*0.1)];
    self.phoneRemindLabel.text=@"电话号码";
    self.phoneRemindLabel.textColor=[UIColor colorWithRed:76/255.0f green:182/255.0f blue:248/255.0f alpha:1];
    self.phoneRemindLabel.font=[UIFont systemFontOfSize:17];
    self.phoneRemindLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:self.phoneRemindLabel];
    
    self.phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.5, screenHeight*0.52, screenWidth*0.45, screenHeight*0.1)];
    self.phoneLabel.text=self.contactPhone;
    self.phoneLabel.font=[UIFont systemFontOfSize:18];
    self.phoneLabel.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:self.phoneLabel];
    
    self.LocationLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, screenHeight*0.66, screenWidth*0.4, screenHeight*0.1)];
    self.LocationLabel.text=@"地理位置";
    self.LocationLabel.textColor=[UIColor colorWithRed:76/255.0f green:182/255.0f blue:248/255.0f alpha:1];
    [self.view addSubview:self.LocationLabel];
    
    self.mapView=[[MKMapView alloc]initWithFrame:CGRectMake(screenWidth*0.6, screenHeight*0.62, 100, 100)];
    //设置地图的显示风格
    self.mapView.mapType = MKMapTypeStandard;
    //设置地图可缩放
    self.mapView.zoomEnabled = YES;
    //设置地图可滚动
    self.mapView.scrollEnabled = YES;
    //设置地图可旋转
    self.mapView.rotateEnabled = YES;
    //设置显示用户显示位置
    self.mapView.showsUserLocation = YES;
    //为MKMapView设置delegate
    self.mapView.delegate = self;
    [self geocode];
    [self.view addSubview:self.mapView];
    
    
    UIButton *callBtn=[[UIButton alloc]initWithFrame:CGRectMake(screenWidth*0.1, screenHeight*0.8, screenHeight*0.15, screenHeight*0.15)];
    callBtn.layer.masksToBounds=YES;
    callBtn.layer.cornerRadius=screenHeight*0.075;
    [callBtn setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    callBtn.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [callBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callBtn];
    UIButton *SMS=[[UIButton alloc]initWithFrame:CGRectMake(screenWidth*0.65, screenHeight*0.82, screenHeight*0.09, screenHeight*0.09)];
    SMS.layer.masksToBounds=YES;
    SMS.layer.cornerRadius=screenHeight*0.045;
    [SMS setImage:[UIImage imageNamed:@"SMS"] forState:UIControlStateNormal];
    SMS.imageView.contentMode=UIViewContentModeScaleToFill;
    [SMS addTarget:self action:@selector(SMS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SMS];
}

#pragma mark -打电话
- (void)call
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.contactPhone]] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
}
#pragma mark -发短信
- (void)SMS
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.contactPhone]] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
}
#pragma mark -解析地址
- (void)geocode

{
    CLGeocoder *geocode = [[CLGeocoder alloc] init];
    
    [geocode geocodeAddressString:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        
        if ([placemarks count ] > 0) {
            //移除目前地图上得所有标注点
            [_mapView removeAnnotations:_mapView.annotations];
            
        }
        
        for (int i = 0; i< [placemarks count]; i++) {
            CLPlacemark * placemark = placemarks[i];
            
         
            //调整地图位置和缩放比例,第一个参数是目标区域的中心点，第二个参数：目标区域南北的跨度，第三个参数：目标区域的东西跨度，单位都是米
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 1000, 1000);
            //重新设置地图视图的显示区域
            [_mapView setRegion:viewRegion animated:YES];
            // 实例化 MapLocation 对象
             MKPointAnnotation *annotion = [[MKPointAnnotation alloc]init];
            annotion.coordinate=placemark.location.coordinate;
            //把标注点MapLocation 对象添加到地图视图上，一旦该方法被调用，地图视图委托方法mapView：ViewForAnnotation:就会被回调
            [_mapView addAnnotation:annotion];
        }
        
        
    }];
}
#pragma mark mapView Delegate 地图 添加标注时 回调
- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
    // 获得地图标注对象
    MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PIN_ANNOTATION"];
    }
    // 设置大头针标注视图为紫色
    annotationView.pinColor = MKPinAnnotationColorPurple ;
    // 标注地图时 是否以动画的效果形式显示在地图上
    annotationView.animatesDrop = YES ;
    // 用于标注点上的一些附加信息
    annotationView.canShowCallout = YES ;
    return annotationView;
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}
@end
