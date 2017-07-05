//
//  ViewController.m
//  WSLPictureBrowser
//
//  Created by 王双龙 on 2017/6/14.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import "ViewController.h"
#import "WSLPictureBrowseView.h"


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController () <UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //网络gif图片URL
    NSMutableArray * urlArray = [NSMutableArray arrayWithArray:@[@"http://p2.pstatp.com/large/c14000603985b03fb49", @"http://easyread.ph.126.net/FV6Yi84CwrNIJjMQxWApKQ==/7916821270058126176.gif", @"http://img4.duitang.com/uploads/item/201511/26/20151126134454_3dURj.jpeg",@"http://img3.duitang.com/uploads/item/201505/20/20150520150637_aEiMU.gif"]];
    
    //本地图片名字
    NSMutableArray * nameArray = [NSMutableArray arrayWithArray:@[@"11.gif", @"12.gif", @"wang.jpeg", @"13.gif"]];
    
    //本地图片地址
    NSMutableArray * pathArray  = [NSMutableArray array];
    
    for (NSString * nameStr in nameArray) {
        
        NSArray * nameAndType = [nameStr componentsSeparatedByString:@"."];
        NSString * name = [nameAndType  firstObject];
        NSString * type = [nameAndType  lastObject];
        [pathArray addObject: [[NSBundle mainBundle] pathForResource:name ofType:type]];
        
    }
    
    
    WSLPictureBrowseView * browseView = [[WSLPictureBrowseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    browseView.backgroundColor = [UIColor blackColor];
//    browseView.urlArray = urlArray;
    browseView.viewController = self;
        browseView.pathArray = pathArray;
    //    browseView.nameArray = nameArray;
    
    [self.view addSubview:browseView];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
