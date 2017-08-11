//
//  ViewController.m
//  WHBannerDemo
//
//  Created by 王红 on 2017/8/11.
//  Copyright © 2017年 in-next. All rights reserved.
//

#define SCREEN_RATE                                   (SCREEN_HEIGHT/568)
#define SCREEN_HEIGHT                                 ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH                                  ([UIScreen mainScreen].bounds.size.width)


#import "ViewController.h"

#import "WHImageDisplayView.h"

#import "WKWebVC.h"

@interface ViewController ()

@property (nonatomic, strong)   WHImageDisplayView *imageDisplayView;
@property (nonatomic, assign)   CGFloat            fbannerHeight;
@property (nonatomic, assign)   NSDictionary       *dicData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"banner";
    self.view.backgroundColor = [UIColor whiteColor];
    _fbannerHeight = 140*SCREEN_RATE;
    [self configData];
    
    [self createImg:_dicData];
}

#pragma mark 创建数据源
- (void)configData{
    _dicData = [NSDictionary dictionaryWithObjectsAndKeys:@[@{@"title":@"百度",@"url":@"http://baidu.com",@"img":@"http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg"},@{@"title":@"新浪",@"url":@"http://news.sina.com.cn",@"img":@"http://img.taopic.com/uploads/allimg/120222/34250-12022209414087.jpg"},@{@"title":@"图片",@"url":@"http://pic24.nipic.com/20120928/6062547_081856296000_2.jpg",@"img":@"http://pic24.nipic.com/20120928/6062547_081856296000_2.jpg"}],@"bannerArray", nil];
    
    
}

#pragma mark 创建子视图
-(void)createImg:(NSDictionary*)dicData
{
    
    [_imageDisplayView removeFromSuperview];
    
    //自定义的滚动播放的公告0
    NSMutableArray *arrayImg = [[NSMutableArray alloc]init];
    NSMutableArray *arrayCommonUrl = [[NSMutableArray alloc]init];
    NSMutableArray *arrayCommonTitle = [[NSMutableArray alloc]init];
    
    for(NSDictionary *dic in dicData[@"bannerArray"]){
        [arrayImg addObject:dic[@"img"]];
        [arrayCommonUrl addObject:dic[@"url"]];
        [arrayCommonTitle addObject:dic[@"title"]];
    }
    //初始化控件
    if (arrayImg.count == 0) {
        [arrayImg addObject:@"1"];
    }
    self.imageDisplayView  = [WHImageDisplayView zlImageViewDisplayViewWithFrame:CGRectMake(0, 0,SCREEN_WIDTH ,_fbannerHeight) WithImages:arrayImg placeHolderImv:@"defaultImvBg"];
    //把该视图添加到相应的父视图上
    [self.view addSubview:self.imageDisplayView];
    __weak typeof(self)weakSelf = self;
    [self.imageDisplayView addTapEventForImageWithBlock:^(NSInteger imageIndex) {
        if (imageIndex<=arrayCommonUrl.count) {
            WKWebVC *vcWeb = [[WKWebVC alloc]init];
            NSString *strTitle = @"首页";
            if(imageIndex >=1){
                strTitle = arrayCommonTitle[imageIndex - 1];
            }
            vcWeb.strTitle = strTitle;
            NSString *strUrl = [arrayCommonUrl objectAtIndex:imageIndex-1];
            if (strUrl.length>0) {
                vcWeb.strUrl = [arrayCommonUrl objectAtIndex:imageIndex-1];
                
                
                [weakSelf.navigationController pushViewController:vcWeb animated:YES];
            }
        }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
