//
//  ViewController.m
//  XJSwitch
//
//  Created by LXJ on 2017/11/24.
//  Copyright © 2017年 LianLuo. All rights reserved.
//

#import "ViewController.h"
#import "XJSwitch.h"

@interface ViewController ()<XJSwitchDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XJSwitch *switchView = [[XJSwitch alloc] initWithFrame:CGRectMake(100, 100, 50, 30)];
    switchView.borderOffColor = [UIColor groupTableViewBackgroundColor];
    switchView.circleOffColor = [UIColor groupTableViewBackgroundColor];
    switchView.onColor = [UIColor redColor];
    switchView.circleOnColor = [UIColor whiteColor];
    switchView.on = YES;
    switchView.animationDuration = 0.3f;
    switchView.delegate = self;
    [self.view addSubview:switchView];
}

- (void)animationDidStopForSwitch:(XJSwitch *)switchView {
    
}

- (void)valueDidChanged:(XJSwitch *)switchView on:(BOOL)on {
    if (on) {
        NSLog(@"开");
    } else {
        NSLog(@"关");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
