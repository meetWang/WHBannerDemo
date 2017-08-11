//
//  WHImageDisplayView.h
//  WHBannerDemo
//
//  Created by 王红 on 2017/8/11.
//  Copyright © 2017年 in-next. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击图片的Block回调，参数当前图片的索引，也就是当前页数
typedef void(^TapImageViewButtonBlock)(NSInteger imageIndex);

@interface WHImageDisplayView : UIView


//切换图片的时间间隔，可选，默认为3s
@property (nonatomic, assign) CGFloat scrollInterval;

//切换图片时，运动时间间隔,可选，默认为0.7s
@property (nonatomic, assign) CGFloat animationInterVale;

//默认的图片
@property (nonatomic, copy) NSString *strImgPlaceholder;

// 图片轮播的index
@property (nonatomic, copy) void(^scrollviewEndScrollBlock)(NSInteger currentPage);


/**********************************
 *功能：便利初始化函数
 *frame：滚动视图的Frame, 要显示图片的数组
 *images：滚动视图, 要显示图片的数组
 *strImvPlaceHolder：默认的背景图
 *返回值：该类的对象
 **********************************/

+ (instancetype) zlImageViewDisplayViewWithFrame: (CGRect) frame
                                      WithImages: (NSArray *) images  placeHolderImv:(NSString *)strImvPlaceHolder;


/**********************************
 *功能：为每个图片添加点击时间
 *参数：点击按钮要执行的Block
 *返回值：无
 **********************************/
- (void) addTapEventForImageWithBlock: (TapImageViewButtonBlock) block;

@end
