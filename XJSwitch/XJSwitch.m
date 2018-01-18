
//
//  XJSwitch.m
//  XJSwitch
//
//  Created by LXJ on 2017/11/24.
//  Copyright © 2017年 LianLuo. All rights reserved.
//

#import "XJSwitch.h"

NSString * const CircleMoveAnimationKey = @"CircleMoveAnimationKey";
NSString * const BackgroundColorAnimationKey = @"BackgroundColorAnimationKey";

@interface XJSwitch() <CAAnimationDelegate>

@property (nonatomic, strong) UIView *backgroundView;

/**
 *  dot layer
 */
@property (nonatomic, strong) CAShapeLayer *circleLayer;

/**
 *  dot radius
 */
@property (nonatomic, assign) CGFloat circleRadius;

/**
 *  paddingWidth
 */
@property (nonatomic, assign) CGFloat paddingWidth;

/**
 *  the faceLayer move distance
 */
@property (nonatomic, assign) CGFloat moveDistance;

/**
 *  whether is animated
 */
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation XJSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetUpView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSetUpView];
    }
    return self;
}


- (void)initSetUpView {
    /**
     *  check the switch width and height
     */
    NSAssert(self.frame.size.width >= self.frame.size.height, @"switch width must be tall！");
    
    /**
     *  init property
     */
    _onColor = [UIColor blueColor];
    _offColor = [UIColor whiteColor];
    _circleOnColor = [UIColor whiteColor];
    _circleOffColor = [UIColor grayColor];
    _borderOnColor = [UIColor whiteColor];
    _borderOffColor = [UIColor grayColor];
    
    _on = NO;
    
    _paddingWidth = self.frame.size.height * 0.15;
    _circleRadius = (self.frame.size.height - 2 * _paddingWidth) / 2;
    _animationDuration = 0.5f;
//    _animationManager = [[LLAnimationManager alloc] initWithAnimationDuration:_animationDuration];
    _moveDistance = self.bounds.size.width - (_paddingWidth + _circleRadius) * 2;
//    _on = NO;
    _isAnimating = NO;
    
    /**
     *  setting init property
     */
    self.backgroundView.backgroundColor = _offColor;
    self.backgroundView.layer.borderColor = _borderOffColor.CGColor;
    self.backgroundView.layer.borderWidth = 1.0;
    self.circleLayer.fillColor = _circleOffColor.CGColor;
//    self.faceLayerWidth = self.circleFaceLayer.frame.size.width;
    [self.circleLayer setNeedsDisplay];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSwitch)]];
}

#pragma mark - Action
- (void)handleTapSwitch {
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    
    CABasicAnimation *backViewColorAnimation = [self backgroundColorAnimationFromValue:(id)(_on ? _onColor : _offColor).CGColor toValue:(id)(_on ? _offColor : _onColor).CGColor];
    [_backgroundView.layer addAnimation:backViewColorAnimation forKey:BackgroundColorAnimationKey];
    
    CABasicAnimation *moveAnimation = [self moveAnimationWithFromPosition:_circleLayer.position toPosition:_on ? CGPointMake(_circleLayer.position.x - _moveDistance, _circleLayer.position.y) : CGPointMake(_circleLayer.position.x + _moveDistance, _circleLayer.position.y)];
    moveAnimation.delegate = self;
    [_circleLayer addAnimation:moveAnimation forKey:CircleMoveAnimationKey];

}

#pragma mark - Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [_circleLayer animationForKey:CircleMoveAnimationKey]) {
        
        _circleLayer.fillColor = _on ? _circleOffColor.CGColor : _circleOnColor.CGColor;
        [_circleLayer setNeedsDisplay];

        _backgroundView.layer.borderColor = _on ? _borderOffColor.CGColor : _borderOnColor.CGColor;

        if (_on) {
            _circleLayer.position = CGPointMake(_circleLayer.position.x - _moveDistance, _circleLayer.position.y);
            _on = NO;
        } else {
            _circleLayer.position = CGPointMake(_circleLayer.position.x + _moveDistance, _circleLayer.position.y);
            _on = YES;
        }
        _isAnimating = NO;
        
        // stop delegate
        if ([self.delegate respondsToSelector:@selector(animationDidStopForSwitch:)]) {
            [self.delegate animationDidStopForSwitch:self];
        }
        
        // valueChanged
        if ([self.delegate respondsToSelector:@selector(valueDidChanged:on:)]) {
            [self.delegate valueDidChanged:self on:self.on];
        }

    }
}

#pragma mark - Setter & Getter

- (void)setOnColor:(UIColor *)onColor {
    _onColor = onColor;
    if (_on) {
        _backgroundView.backgroundColor = onColor;
    }
}

- (void)setOffColor:(UIColor *)offColor {
    _offColor = offColor;
    if (!_on) {
        _backgroundView.backgroundColor = offColor;
    }
}

- (void)setCircleOnColor:(UIColor *)circleOnColor {
    _circleOnColor = circleOnColor;
    if (_on) {
        _circleLayer.fillColor = circleOnColor.CGColor;
        [self.circleLayer setNeedsDisplay];
    }
}

- (void)setCircleOffColor:(UIColor *)circleOffColor {
    _circleOffColor = circleOffColor;
    if (!_on) {
        _circleLayer.fillColor = circleOffColor.CGColor;
        [self.circleLayer setNeedsDisplay];
    }
}

- (void)setBorderOnColor:(UIColor *)borderOnColor {
    _borderOnColor = borderOnColor;
    if (_on) {
        _backgroundView.layer.borderColor = borderOnColor.CGColor;
    }
}

- (void)setBorderOffColor:(UIColor *)borderOffColor {
    _borderOffColor = borderOffColor;
    if (!_on) {
        _backgroundView.layer.borderColor = borderOffColor.CGColor;
    }
}

- (void)setAnimationDuration:(CGFloat)animationDuration {
    _animationDuration = animationDuration;
}

- (void)setOn:(BOOL)on {
    if ((_on && on)||(!_on && !on)) {
        return;
    }
    _on = on;
    
    if (on) {
        
        [self.backgroundView.layer removeAllAnimations];
        self.backgroundView.backgroundColor = _onColor;
        [self.circleLayer removeAllAnimations];
        self.circleLayer.position = CGPointMake(self.circleLayer.position.x + _moveDistance, self.circleLayer.position.y);
        self.circleLayer.fillColor = _circleOnColor.CGColor;
        [self.circleLayer setNeedsDisplay];
        
    } else {
        
        [self.backgroundView.layer removeAllAnimations];
        self.backgroundView.backgroundColor = _offColor;
        [self.circleLayer removeAllAnimations];
        self.circleLayer.position = CGPointMake(self.circleLayer.position.x - _moveDistance, self.circleLayer.position.y);
        self.circleLayer.fillColor = _circleOffColor.CGColor;
        [self.circleLayer setNeedsDisplay];
        
    }
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _backgroundView.layer.cornerRadius = self.bounds.size.height / 2;
        _backgroundView.layer.masksToBounds = YES;
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        [_circleLayer setFrame:CGRectMake(_paddingWidth, (self.bounds.size.height - _circleRadius * 2) / 2, _circleRadius * 2, _circleRadius *2)];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:_circleLayer.bounds];
        _circleLayer.path = circlePath.CGPath;
        [self.layer addSublayer:_circleLayer];
    }
    return _circleLayer;
}

#pragma mark - Animation
/**
 *  faceLayer move animation
 */
- (CABasicAnimation *)moveAnimationWithFromPosition:(CGPoint)fromPosition toPosition:(CGPoint)toPosition {
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
    moveAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    moveAnimation.duration = _animationDuration;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeForwards;
    return moveAnimation;
}

/**
 *  layer background color animation
 */
- (CABasicAnimation *)backgroundColorAnimationFromValue:(NSValue *)fromValue toValue:(NSValue *)toValue {
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.fromValue = fromValue;
    colorAnimation.toValue = toValue;
    colorAnimation.duration = _animationDuration;
    colorAnimation.removedOnCompletion = NO;
    colorAnimation.fillMode = kCAFillModeForwards;
    return colorAnimation;
}

@end
