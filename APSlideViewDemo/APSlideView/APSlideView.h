//
//  APSlideView.h
//  APSlideViewDemo
//
//  Created by chengenluo on 16/9/6.
//  Copyright © 2016年 chengenluo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 滑动方向
 */
typedef enum {
    APSlideViewSlideDirectionLeft = 0x01,  //左边
    APSlideViewSlideDirectionRight = 0x02, //右边
    APSlideViewSlideDirectionTop = 0x03,   //上边
    APSlideViewSlideDirectionBottom = 0x04,//下方
} APSlideViewSlideDirection;

/**
 *  AP侧拉视图控制器
 *  
 *  @descritpion 用于弹出侧边浮动视图
 *               1.包含四个方向的侧边浮动,并附带有拖拽手势
                 2.视图包含有一个根控制器,控制器的布局由侧拉视图控制器控制
                 3.视图的大小由外部定义
                 4.可以控制是否启用拖拽手势
 
 *  @author apem
 */
@interface APSlideView : UIView

@property (nonatomic, assign) BOOL dragEnable; //default is YES
@property (nonatomic, assign) APSlideViewSlideDirection slideDirection; //default is Right Side
@property (nonatomic, strong) UIViewController *viewController; //根控制器

/**
 *  实例化
 *
 *  @param frame 布局
 *
 *  @return AP侧拉视图控制器对象
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  初始化配置
 */
- (void)initConfig;

/**
 *  初始化视图
 */
- (void)setup;

/**
 *  滑入视图
 *
 *  @param view          滑入的视图
 *  @param animated      是否动画
 *  @param completeBlock 结束回调
 */
- (void)slideInView:(UIView *)view animated:(BOOL)animated complete:(void(^)())completeBlock;

/**
 *  滑出
 *
 *  @param animated      是否动画
 *  @param completeBlock 结束回调
 */
- (void)slideOutWithAnimated:(BOOL)animated complete:(void(^)())completeBlock;

@end
