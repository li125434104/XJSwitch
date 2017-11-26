//
//  XJSwitch.h
//  XJSwitch
//
//  Created by LXJ on 2017/11/24.
//  Copyright © 2017年 LianLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XJSwitchDelegate;

@interface XJSwitch : UIView


/**
 switch on color
 */
@property (nonatomic, strong) UIColor *onColor;

/**
 switch off color
 */
@property (nonatomic, strong) UIColor *offColor;

/**
 dot on color
 */
@property (nonatomic, strong) UIColor *circleOnColor;

/**
 dot off color
 */
@property (nonatomic, strong) UIColor *circleOffColor;


/**
 border on color
 */
@property (nonatomic, strong) UIColor *borderOnColor;

/**
 border off color
 */
@property (nonatomic, strong) UIColor *borderOffColor;

/**
 dot moving time
 */
@property (nonatomic, assign) CGFloat animationDuration;


/**
 the switch status is or isn't on
 */
@property (nonatomic, assign) BOOL on;


@property (nonatomic, weak) id <XJSwitchDelegate> delegate;

@end

@protocol XJSwitchDelegate <NSObject>

@optional

- (void)animationDidStopForSwitch:(XJSwitch *)switchView;

- (void)valueDidChanged:(XJSwitch *)switchView on:(BOOL)on;

@end
