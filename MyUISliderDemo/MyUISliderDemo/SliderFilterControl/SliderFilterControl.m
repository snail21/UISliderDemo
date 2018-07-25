//
//  SliderFilterControl.m
//  MyUISliderDemo
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 apple. All rights reserved.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "SliderFilterControl.h"
#import "SliderFilterButton.h"

#define LEFT_OFFSET 10
#define RIGHT_OFFSET 10
#define UIColorFromHex(hexValue) [UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

@interface SliderFilterControl () {
    
    SliderFilterButton *handler;
    CGPoint diffPoint;
    NSUInteger fontNums;
    float oneSlotSize;
    
    NSUInteger type;
    CGPoint pointsss;
}

@end

@implementation SliderFilterControl
@synthesize SelectedIndex, progressColor;

-(CGPoint)getCenterPointForIndex:(int) i{
    return CGPointMake((i/(float)(fontNums-1)) * (self.frame.size.width-RIGHT_OFFSET-LEFT_OFFSET) + LEFT_OFFSET, i==0?self.frame.size.height-20:self.frame.size.height-20);
}

-(CGPoint)fixFinalPoint:(CGPoint)pnt{
    if (pnt.x < LEFT_OFFSET-(handler.frame.size.width/2.f)) {
        pnt.x = LEFT_OFFSET-(handler.frame.size.width/2.f);
    }else if (pnt.x+(handler.frame.size.width/2.f) > self.frame.size.width-RIGHT_OFFSET){
        pnt.x = self.frame.size.width-RIGHT_OFFSET- (handler.frame.size.width/2.f);
    }
    return pnt;
}

- (id)initWithFrame:(CGRect)frame FontNums:(NSUInteger)fontNum {
    
    if (self = [super initWithFrame:frame]) {
        
        fontNums = fontNum;
        [self setBackgroundColor:[UIColor clearColor]];
        
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ItemSelected:)];
        [self addGestureRecognizer:gest];
        
        handler = [SliderFilterButton buttonWithType:UIButtonTypeCustom];
        [handler setFrame:CGRectMake(0, (self.frame.size.height - 20) / 2, 20, 20)];
        [handler setHandlerColor:self.progressColor];
        [handler addTarget:self action:@selector(TouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
        [handler addTarget:self action:@selector(TouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [handler addTarget:self action:@selector(TouchMove:withEvent:) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
        
        [self addSubview:handler];
        
        oneSlotSize = 1.f*(self.frame.size.width-LEFT_OFFSET-RIGHT_OFFSET-1)/(fontNum-1);
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    handler.layer.borderColor = progressColor.CGColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Fill Main Path
    
    CGContextSetFillColorWithColor(context, UIColorFromHex(0xD4DCE4).CGColor );
    
    CGContextFillRect(context, CGRectMake(LEFT_OFFSET, (rect.size.height-5) / 2, rect.size.width-RIGHT_OFFSET-LEFT_OFFSET, 5));
    
    CGContextSaveGState(context);
    
    if (type == 0) {
        //选中色
        CGContextRef contexts = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(contexts, self.progressColor.CGColor);
        CGContextFillRect(contexts, CGRectMake(LEFT_OFFSET, (rect.size.height-5) / 2, (rect.size.width-RIGHT_OFFSET-LEFT_OFFSET) / (fontNums -1) * SelectedIndex, 5));
        CGContextSaveGState(contexts);
    }
    else {
        //选中色
        CGContextRef contexts = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(contexts, self.progressColor.CGColor);
        CGContextFillRect(contexts, CGRectMake(LEFT_OFFSET, (rect.size.height-5) / 2, pointsss.x - 10, 5));
        CGContextSaveGState(contexts);
    }
    
    
    CGPoint centerPoint;
    int i;
    for (i = 0; i < fontNums; i++) {
        centerPoint = [self getCenterPointForIndex:i];
        
        //Draw Selection Circles
        
        CGContextSetFillColorWithColor(context, UIColorFromHex(0xD4DCE4).CGColor);
        
        CGContextFillEllipseInRect(context, CGRectMake(centerPoint.x - 8, (rect.size.height-15) / 2, 15, 15));
        
    }
    
    CGPoint centerPoints;
    for (int i = 0; i< SelectedIndex; i++) {
        centerPoints = [self getCenterPointForIndex:i];
        
        //Draw Selection Circles
        
        CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
        
        CGContextFillEllipseInRect(context, CGRectMake(centerPoints.x - 8, (rect.size.height-15) / 2, 15, 15));
    }
}

- (void) TouchDown: (UIButton *) btn withEvent: (UIEvent *) ev{
    CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
    diffPoint = CGPointMake(currPoint.x - btn.frame.origin.x, currPoint.y - btn.frame.origin.y);
    [self sendActionsForControlEvents:UIControlEventTouchDown];
}


-(void) animateHandlerToIndex:(int) index{
    CGPoint toPoint = [self getCenterPointForIndex:index];
    toPoint = CGPointMake(toPoint.x-(handler.frame.size.width/2.f), handler.frame.origin.y);
    toPoint = [self fixFinalPoint:toPoint];
    
    [UIView beginAnimations:nil context:nil];
    [handler setFrame:CGRectMake(toPoint.x, toPoint.y, handler.frame.size.width, handler.frame.size.height)];
    [UIView commitAnimations];
}

-(void) setSelectedIndex:(int)index{
    SelectedIndex = index;
    
    [self animateHandlerToIndex:index];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

-(int)getSelectedTitleInPoint:(CGPoint)pnt{
    return round((pnt.x-LEFT_OFFSET)/oneSlotSize);
}

-(void) ItemSelected: (UITapGestureRecognizer *) tap {
    SelectedIndex = [self getSelectedTitleInPoint:[tap locationInView:self]];
    [self setSelectedIndex:SelectedIndex];
    
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void) TouchUp: (UIButton*) btn{
    
    SelectedIndex = [self getSelectedTitleInPoint:btn.center];
    [self animateHandlerToIndex:SelectedIndex];
    [self setNeedsDisplay];
    type = 0;
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) TouchMove: (UIButton *) btn withEvent: (UIEvent *) ev {
    CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
    
//    NSLog(@"sdksjfj %@", NSStringFromCGPoint(currPoint));
    
    CGPoint toPoint = CGPointMake(currPoint.x-diffPoint.x, handler.frame.origin.y);
//    NSLog(@"sdksjfj %@", NSStringFromCGPoint(toPoint));
    toPoint = [self fixFinalPoint:toPoint];
//    NSLog(@"sdksjfj %@", NSStringFromCGPoint(toPoint));
    [handler setFrame:CGRectMake(toPoint.x, toPoint.y, handler.frame.size.width, handler.frame.size.height)];
    type = 1;
    pointsss = currPoint;
    SelectedIndex = [self getSelectedTitleInPoints:currPoint];
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventTouchDragInside];
}

-(int)getSelectedTitleInPoints:(CGPoint)pnt{
    return (pnt.x-LEFT_OFFSET)/oneSlotSize + 1;
}

-(void)dealloc{
    [handler removeTarget:self action:@selector(TouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    [handler removeTarget:self action:@selector(TouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [handler removeTarget:self action:@selector(TouchMove:withEvent: ) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
}

@end
