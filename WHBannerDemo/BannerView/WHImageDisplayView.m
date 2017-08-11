//
//  WHImageDisplayView.m
//  WHBannerDemo
//
//  Created by 王红 on 2017/8/11.
//  Copyright © 2017年 in-next. All rights reserved.
//

#define ImageNamed(fileName) [UIImage imageNamed:fileName]

#import "WHImageDisplayView.h"

#import "UIImageView+WebCache.h"

@interface WHImageDisplayView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIPageControl *mainPageControl;

@property (nonatomic, assign) CGFloat widthOfView;

@property (nonatomic, assign) CGFloat heightView;

@property (nonatomic, strong) NSArray *imageViewArray;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) UIViewContentMode imageViewcontentModel;

@property (nonatomic, strong) UIPageControl *imageViewPageControl;

@property (nonatomic, strong) TapImageViewButtonBlock block;

@end

@implementation WHImageDisplayView

#pragma -- 遍历构造器
+ (instancetype) zlImageViewDisplayViewWithFrame: (CGRect) frame
                                      WithImages: (NSArray *) images  placeHolderImv:(NSString *)strImvPlaceHolder{
    
    WHImageDisplayView *instance = [[WHImageDisplayView alloc] initWithFrame:frame WithImages:images placeHolderImv:strImvPlaceHolder];
    return instance;
    
}

- (instancetype)initWithFrame: (CGRect)frame
                   WithImages: (NSArray *) images placeHolderImv:(NSString *)strImvPlaceHolder {
    self = [super initWithFrame:frame];
    if (self) {
        //获取滚动视图的宽度
        _widthOfView = frame.size.width;
        
        //获取滚动视图的高度
        _heightView = frame.size.height;
        _imageViewArray = images;
        _scrollInterval = 5;
        
        _animationInterVale = 0.6;
        
        //当前显示页面
        _currentPage = 1;
        
        //        _imageViewcontentModel = UIViewContentModeScaleToFill;
        _imageViewcontentModel = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
        //初始化滚动视图
        [self initMainScrollView];
        
        //添加ImageView
        [self addImageviewsForMainScrollWithImages:images placeHolderImv:strImvPlaceHolder];
        
        //添加timer
        [self addTimerLoop];
        
        [self addPageControl];
        [self initImageViewButton];
        
        
    }
    return self;
    
}


- (void) addTapEventForImageWithBlock: (TapImageViewButtonBlock) block{
    if (_block == nil) {
        if (block != nil) {
            _block = block;
            
            //            [self initImageViewButton];
            
        }
    }
}


#pragma -- mark 初始化按钮
- (void) initImageViewButton{
    
    for ( int i = 0; i < _imageViewArray.count + 1; i ++) {
        
        CGRect currentFrame = CGRectMake(_widthOfView * i, 0, _widthOfView, _heightView);
        
        UIButton *tempButton = [[UIButton alloc] initWithFrame:currentFrame];
        [tempButton addTarget:self action:@selector(tapImageButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            tempButton.tag = _imageViewArray.count;
        } else {
            tempButton.tag = i;
        }
        
        [_mainScrollView addSubview:tempButton];
    }
    
}


- (void) tapImageButton: (UIButton *) sender{
    if (_block) {
        _block(sender.tag);
    }
}

#pragma -- mark 初始化ScrollView
- (void) initMainScrollView{
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _widthOfView, _heightView)];
    
    _mainScrollView.contentSize = CGSizeMake(_widthOfView, _heightView);
    
    _mainScrollView.pagingEnabled = YES;
    
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    
    _mainScrollView.showsVerticalScrollIndicator = NO;
    
    _mainScrollView.delegate = self;
    
    [self addSubview:_mainScrollView];
}

#pragma 添加PageControl
- (void) addPageControl{
    _imageViewPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _heightView - 20, _widthOfView, 20)];
    
    _imageViewPageControl.numberOfPages = _imageViewArray.count;
    
    _imageViewPageControl.currentPage = _currentPage - 1;
    
    _imageViewPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _imageViewPageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_imageViewPageControl];
}


#pragma -- mark 给ScrollView添加ImageView
-(void) addImageviewsForMainScrollWithImages: (NSArray *) images{
    //设置ContentSize
    _mainScrollView.contentSize = CGSizeMake(_widthOfView * (images.count+1), _heightView);
    
    _imageViewArray = images;
    
    for ( int i = 0; i < _imageViewArray.count + 1; i ++) {
        
        CGRect currentFrame = CGRectMake(_widthOfView * i, 0, _widthOfView, _heightView);
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:currentFrame];
        
        tempImageView.contentMode = _imageViewcontentModel;
        
        tempImageView.clipsToBounds = YES;
        
        NSString *imageName;
        
        if (i == 0) {
            imageName = [_imageViewArray lastObject];
        } else {
            imageName = _imageViewArray[i - 1];
        }
        [tempImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:(self.strImgPlaceholder&&self.strImgPlaceholder.length > 0)?ImageNamed(self.strImgPlaceholder):ImageNamed(@"home_BackGround")];
        
        
        [_mainScrollView addSubview:tempImageView];
    }
    _mainScrollView.contentOffset = CGPointMake(_widthOfView, 0);
    
}

- (void) addTimerLoop{
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
    }
}

-(void) changeOffset{
    
    _currentPage ++;
    
    if (_currentPage == _imageViewArray.count + 1) {
        _currentPage = 1;
    }
    
    if(_imageViewArray.count >1){
        [UIView animateWithDuration:_animationInterVale animations:^{
            _mainScrollView.contentOffset = CGPointMake(_widthOfView * _currentPage, 0);
        } completion:^(BOOL finished) {
            if (_currentPage == _imageViewArray.count) {
                _mainScrollView.contentOffset = CGPointMake(0, 0);
            }
        }];
        
    }
    
    _imageViewPageControl.currentPage = _currentPage - 1;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x / _widthOfView;
    
    if(currentPage == 0){
        _mainScrollView.contentOffset = CGPointMake(_widthOfView * _imageViewArray.count, 0);
        _imageViewPageControl.currentPage = _imageViewArray.count;
        _currentPage = _imageViewArray.count;
    }
    
    if (_currentPage + 1 == currentPage || currentPage == 1) {
        _currentPage = currentPage;
        
        if (_currentPage == _imageViewArray.count + 1) {
            _currentPage = 1;
        }
        
        if (_currentPage == _imageViewArray.count) {
            _mainScrollView.contentOffset = CGPointMake(0, 0);
        }
        
        _imageViewPageControl.currentPage = _currentPage - 1;
        [self resumeTimer];
        
        NSLog(@"右边currentPage%li page：%li",currentPage,_currentPage);
    }
    
    
    if (_currentPage - 1 == currentPage || currentPage == 1) {
        _currentPage = currentPage;
        
        if (_currentPage == _imageViewArray.count + 1) {
            _currentPage = 1;
        }
        
        if (_currentPage == _imageViewArray.count) {
            _mainScrollView.contentOffset = CGPointMake(0, 0);
        }
        
        _imageViewPageControl.currentPage = _currentPage - 1;
        [self resumeTimer];
        
        NSLog(@"左边currentPage%li page：%li",currentPage,_currentPage);
    }
}

#pragma 暂停定时器
-(void)resumeTimer{
    
    if (![_timer isValid]) {
        return ;
    }
    
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollInterval-_animationInterVale]];
    
}

#pragma -- mark 给ScrollView添加ImageView
-(void) addImageviewsForMainScrollWithImages: (NSArray *) images placeHolderImv:(NSString *)strPlaceHolderImv{
    //设置ContentSize
    _mainScrollView.contentSize = CGSizeMake(_widthOfView * (images.count+1), _heightView);
    
    _imageViewArray = images;
    
    for ( int i = 0; i < _imageViewArray.count + 1; i ++) {
        
        CGRect currentFrame = CGRectMake(_widthOfView * i, 0, _widthOfView, _heightView);
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:currentFrame];
        
        tempImageView.contentMode = _imageViewcontentModel;
        
        tempImageView.clipsToBounds = YES;
        
        NSString *imageName;
        
        if (i == 0) {
            imageName = [_imageViewArray lastObject];
        } else {
            imageName = _imageViewArray[i - 1];
        }
        [tempImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:ImageNamed(strPlaceHolderImv)];
        
        [_mainScrollView addSubview:tempImageView];
    }
    _mainScrollView.contentOffset = CGPointMake(_widthOfView, 0);
    
}
@end
