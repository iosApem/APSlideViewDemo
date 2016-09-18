//
//  APSlideView.m
//  APSlideViewDemo
//
//  Created by chengenluo on 16/9/6.
//  Copyright © 2016年 chengenluo. All rights reserved.
//

#import "APSlideView.h"

#define D_APSlideViewSlideMinDistance 50 //最低滑动距离

@interface APSlideView ()<UIGestureRecognizerDelegate>
{
    CGPoint _startTouch;                                    //手指初始位置
    CGPoint _startOrigin;                                   //当前控件初始位置
}
@property (nonatomic, assign) BOOL isIn;                    //是否已经滑入 default is NO
@property (nonatomic,assign) BOOL isMoving;                 //是否正在滑动
@property (nonatomic, assign) CGFloat minSlideDistance;     //最小滑动距离 (用于判断是否收起视图)

@end

@implementation APSlideView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self initConfig];
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.viewController.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setViewController:(UIViewController *)viewController
{
    _viewController = viewController;
    
    [self addSubview:_viewController.view];
}

- (void)initConfig
{
    _isIn = NO;
    _dragEnable = YES;
    _slideDirection = APSlideViewSlideDirectionRight;
    _minSlideDistance = D_APSlideViewSlideMinDistance;
}

- (void)setup
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
}

- (void)slideInView:(UIView *)view animated:(BOOL)animated complete:(void(^)())completeBlock
{
    if(self.superview != nil) {
        [self removeFromSuperview];
    }
    [view addSubview:self];
    
    //如果还没有滑入则需要初始化开始布局
    if (self.isIn == NO) {
        CGRect slideOutRect = [self calculateSelfSlideOutLayout];
        self.frame = slideOutRect;
    }
    
    __weak typeof(self) weakSelf = self;
    
    //动画
    if (animated == YES) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect rect = [weakSelf calculateSelfSlideInLayout];
            weakSelf.frame = rect;
            
        } completion:^(BOOL finished) {
            weakSelf.isIn = YES;
            if(completeBlock) {
                completeBlock();
            }
        }];
        
    //非动画
    } else {
        
        CGRect rect = [weakSelf calculateSelfSlideInLayout];
        weakSelf.frame = rect;
        
        weakSelf.isIn = YES;
        if(completeBlock) {
            completeBlock();
        }
    }
}

- (void)slideOutWithAnimated:(BOOL)animated complete:(void(^)())completeBlock
{
    if (self.isIn == YES) {
        
        __weak typeof(self) weakSelf = self;
        //动画
        if (animated == YES) {
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                CGRect rect = [weakSelf calculateSelfSlideOutLayout];
                weakSelf.frame = rect;
                
            } completion:^(BOOL finished) {
                weakSelf.isIn = NO;
                [weakSelf removeFromSuperview];
                if(completeBlock) {
                    completeBlock();
                }
            }];
            
        //非动画
        } else {
            
            CGRect rect = [weakSelf calculateSelfSlideOutLayout];
            weakSelf.frame = rect;
            
            [weakSelf removeFromSuperview];
            weakSelf.isIn = NO;
            if(completeBlock) {
                completeBlock();
            }
            
        }
        
    }
}



#pragma mark - Gesture Recognizer

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recognizer
{
    
    UIView *view = self.superview;
    CGPoint touchPoint = [recognizer locationInView:view];
    
    //开始
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        
        _startTouch = touchPoint;
        _startOrigin = self.frame.origin;
        
    //结束
    } else if (recognizer.state == UIGestureRecognizerStateEnded){
        
        _isMoving = NO;
        //处理拖拽结束
        [self dealDragEndWithCurrentTouch:touchPoint startTouch:_startTouch];
        
    //变化
    } else if(recognizer.state == UIGestureRecognizerStateChanged) {
        
        //计算自己当前的布局
        CGRect rect =[self calcSelfCurrentFrameStartOrigin:_startOrigin startTouch:_startTouch currentTouch:touchPoint];
        self.frame = rect;
        
    //取消/失败
    } else if(recognizer.state == UIGestureRecognizerStateCancelled ||
              recognizer.state == UIGestureRecognizerStateFailed) {
        _isMoving = NO;
    }
        
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    BOOL shouldReceiveTouch = NO;
    if (self.dragEnable == YES) {
        shouldReceiveTouch = YES;
    } else {
        shouldReceiveTouch = NO;
    }
    return shouldReceiveTouch;
}

#pragma mark - set layout
/**
 *  设置self滑出布局
 */
- (CGRect)calculateSelfSlideOutLayout
{
    CGRect rect = self.frame;
    UIView *superView = self.superview;
    //左
    if (self.slideDirection == APSlideViewSlideDirectionLeft) {
        
        rect.origin = CGPointMake(-rect.size.width, 0);
    //右
    } else if(self.slideDirection == APSlideViewSlideDirectionRight) {
        
        rect.origin = CGPointMake(superView.frame.size.width, 0);
        
    //上
    } else if(self.slideDirection == APSlideViewSlideDirectionTop) {
        
        rect.origin = CGPointMake(0, -rect.size.height);
    //下
    } else if(self.slideDirection == APSlideViewSlideDirectionBottom) {
        
        rect.origin = CGPointMake(0, superView.frame.size.height);
    }
    return rect;
}

/**
 *  计算滑入布局
 */
- (CGRect)calculateSelfSlideInLayout
{
    CGRect rect = self.frame;
    UIView *superView = self.superview;
    //左
    if (self.slideDirection == APSlideViewSlideDirectionLeft) {
        
        rect.origin = CGPointMake(0, rect.origin.y);
    //右
    } else if(self.slideDirection == APSlideViewSlideDirectionRight) {
        
        rect.origin = CGPointMake(superView.frame.size.width - rect.size.width, 0);
        
    //上
    } else if(self.slideDirection == APSlideViewSlideDirectionTop) {
        
        rect.origin = CGPointMake(0, 0);
    //下
    } else if(self.slideDirection == APSlideViewSlideDirectionBottom) {
        
        rect.origin = CGPointMake(0, superView.frame.size.height - rect.size.height);
    }
    return rect;
    
}

/**
 *  计算自己当前的布局
 *
 *  @param startOrigin  布局起始位置
 *  @param startTouch   手指开始的位置
 *  @param currentTouch 手指当前的位置
 *
 *  @return 自己当前的布局
 */
- (CGRect)calcSelfCurrentFrameStartOrigin:(CGPoint)startOrigin startTouch:(CGPoint)startTouch currentTouch:(CGPoint)currentTouch
{
    CGRect rect = self.frame;
    //左
    if (self.slideDirection == APSlideViewSlideDirectionLeft) {
        
        //相对移动距离
        CGFloat offset = startTouch.x - currentTouch.x;
        if(offset < 0) {
            offset = 0;
        }
        rect.origin = CGPointMake(startOrigin.x - offset, rect.origin.y);
    //右
    } else if(self.slideDirection == APSlideViewSlideDirectionRight) {
        
        //相对移动距离
        CGFloat offset = currentTouch.x - startTouch.x;
        if(offset < 0) {
            offset = 0;
        }
        rect.origin = CGPointMake(startOrigin.x + offset, rect.origin.y);
    //上
    } else if(self.slideDirection == APSlideViewSlideDirectionTop) {
        
        //相对移动距离
        CGFloat offset = startTouch.y - currentTouch.y;
        if(offset < 0) {
            offset = 0;
        }
        rect.origin = CGPointMake(rect.origin.x, startOrigin.y - offset);
        
    //下
    } else if(self.slideDirection == APSlideViewSlideDirectionBottom) {
        
        //相对移动距离
        CGFloat offset = currentTouch.y - startTouch.y;
        if(offset < 0) {
            offset = 0;
        }
        rect.origin = CGPointMake(rect.origin.x, startOrigin.y + offset);
    }
    
    return rect;
}

/**
 *  处理拖拽结束
 *
 *  @param currentTouch 手指当前位置
 *  @param startTouch   手指起始位置
 */
- (void)dealDragEndWithCurrentTouch:(CGPoint)currentTouch startTouch:(CGPoint)startTouch
{
    CGFloat offset = 0;
    
    //左
    if (self.slideDirection == APSlideViewSlideDirectionLeft) {
        offset = startTouch.x - currentTouch.x;
    //右
    } else if(self.slideDirection == APSlideViewSlideDirectionRight) {
        offset = currentTouch.x - startTouch.x;
    //上
    } else if(self.slideDirection == APSlideViewSlideDirectionTop) {
        offset = startTouch.y - currentTouch.y;
    //下
    } else if(self.slideDirection == APSlideViewSlideDirectionBottom) {
        offset = currentTouch.y - startTouch.y;
    }
    
    //如果位移大于最低滑动距离,滑出
    if (offset > self.minSlideDistance)
    {
        [self slideOutWithAnimated:YES complete:nil];
    //再次滑入
    } else {
        UIView *superView = self.superview;
        [self slideInView:superView animated:YES complete:nil];
    }
}

@end
