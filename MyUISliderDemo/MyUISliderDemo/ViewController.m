//
//  ViewController.m
//  MyUISliderDemo
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"
#import "SliderFilterControl.h"

#define UIColorFromHex(hexValue) [UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SliderFilterControl *filter = [[SliderFilterControl alloc]initWithFrame:CGRectMake(30, 200, self.view.frame.size.width - 60, 30) FontNums:5];
    [filter addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];
    [filter setProgressColor:UIColorFromHex(0x00C28D)];
    [self.view addSubview:filter];
}

-(void)filterValueChanged:(SliderFilterControl *) sender{

    NSLog(@"dddd %d",sender.SelectedIndex);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
