//
//  FSLineChart.m
//  FSLineChart
//
//  Created by Arthur GUIBERT on 30/09/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

//圆心
#define POINT_CIRCLE  5.0f

#import <QuartzCore/QuartzCore.h>
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"

@interface FSLineChart ()

@property (nonatomic, strong) NSMutableArray* data;

@property (nonatomic) CGFloat min;
@property (nonatomic) CGFloat max;
@property (nonatomic) CGMutablePathRef initialPath;
@property (nonatomic) CGMutablePathRef newPath;

@end

@implementation FSLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setDefaultParameters];
      
    }
    return self;
}

- (void)setChartData:(NSArray *)chartData
{
    
    
    
    _data = [NSMutableArray arrayWithArray:chartData];
    
    _min = MAXFLOAT;
    _max = -MAXFLOAT;
    for(int i=0;i<_data.count;i++) {
        NSNumber* number = _data[i];
        if([number floatValue] < _min)
            _min = [number floatValue];
        
        if([number floatValue] > _max)
            _max = [number floatValue];
    }
    
    _max = [self getUpperRoundNumber:_max forGridStep:_gridStep];
    
    // No data
    if(isnan(_max)) {
        _max = 1;
    }
    
    
    if(_labelForValue) {
        for(int i=0;i<_gridStep;i++) {
            CGPoint p = CGPointMake(_margin + _axisWidth, _axisHeight + _margin - (i + 1) * _axisHeight / _gridStep-10);
            
            NSString* text = _labelForValue(_max / _gridStep * (i + 1));
           
            CGRect rect = CGRectMake(_margin, p.y + 2, self.frame.size.width - _margin * 2 - 2.0f, 14);
            
            float width =
            [text
             boundingRectWithSize:rect.size
             options:NSStringDrawingUsesLineFragmentOrigin
             attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12.0f] }
             context:nil]
            .size.width;
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(-25, p.y+3, width + 2, 14)];
            label.text = text;
            label.font = [UIFont systemFontOfSize:12.0f];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.75f];
            [self addSubview:label];
        }
    }
    
    if(_labelForIndex) {
        float scale = 1.0f;
        int q = (int)_data.count / _gridStep;
        scale = (CGFloat)(q * _gridStep) / (CGFloat)(_data.count - 1);
        _dateArr = [[ManageVC sharedManage].dateArr objectAtIndex:0];
        for(int i=0;i<_gridStep;i++) {
//            NSInteger itemIndex = q * i+1;
//            NSLog(@"******%d",_gridStep);
//            if(itemIndex >= _data.count)
//            {
//                itemIndex = _data.count ;
//            }
            
            NSString* text = [[_dateArr objectAtIndex:i]substringFromIndex:5];
            CGPoint p = CGPointMake(_margin + i * (_axisWidth / _gridStep) * scale, _axisHeight + _margin);
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - 15.0f, p.y + 2, self.frame.size.width, 14)];
            label.text = text;
            label.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont boldSystemFontOfSize:10.0f];
            label.textColor = [UIColor blackColor];
            [self addSubview:label];

        }
    }
    
    
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self drawGrid];
    [self strokeChart];
  
   
}

- (void)drawGrid
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetLineWidth(ctx, 2);
    CGContextSetStrokeColorWithColor(ctx, [_axisColor CGColor]);
    
    // draw coordinate axis
    CGContextMoveToPoint(ctx, _margin, _margin);
    CGContextAddLineToPoint(ctx, _margin, _axisHeight + _margin +1);
    CGContextStrokePath(ctx);
    
    
    CGContextMoveToPoint(ctx, _margin, _axisHeight + _margin);
    CGContextAddLineToPoint(ctx, _axisWidth + _margin, _axisHeight + _margin);
    CGContextStrokePath(ctx);
    
   // float scale = 1.0f;
   // int q = (int)_data.count / _gridStep;
   // scale = (CGFloat)(q * _gridStep) / (CGFloat)(_data.count - 1);
 
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0f , self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    // draw pointer
    for (int i=0; i<_data.count; i++) {
        NSNumber* value = [_data objectAtIndex:i];
        float floatValue = value.floatValue;
        float height = floatValue*_axisHeight / _max+4;
        float width =self.frame.size.width/(_data.count-1+0.025*(_data.count+1))*i;

        CGContextSetStrokeColorWithColor(context, RGBACOLOR(69, 217, 117, 1).CGColor);
       CGContextAddEllipseInRect(context, CGRectMake(width+4, height, .5, .5));
        CGContextSetLineWidth(context, 4);
  
        CGContextDrawPath(context, kCGPathFillStroke);
 
    }


    

    // draw grid
//    for(int i=0;i<_gridStep;i++) {
//        CGContextSetLineWidth(ctx, 0.5);
//        
//        CGPoint point = CGPointMake((1 + i) * _axisWidth / _gridStep * scale + _margin, _margin);
//        
//       CGContextMoveToPoint(ctx, point.x, point.y);
//        CGContextAddLineToPoint(ctx, point.x, _axisHeight + _margin);
//        CGContextStrokePath(ctx);
//        
//        
//        CGContextSetLineWidth(ctx, 2);
//        CGContextMoveToPoint(ctx, point.x - 0.5f, _axisHeight + _margin);
//        CGContextAddLineToPoint(ctx, point.x - 0.5f, _axisHeight + _margin + 5);
//        CGContextStrokePath(ctx);
//    }
//    
//    for(int i=0;i<_gridStep;i++) {
//        CGContextSetLineWidth(ctx, 0.5);
//        
//        CGPoint point = CGPointMake(_margin, (i) * _axisHeight / _gridStep + _margin);
//        
//        CGContextMoveToPoint(ctx, point.x, point.y);
//        CGContextAddLineToPoint(ctx, _axisWidth + _margin, point.y);
//        CGContextStrokePath(ctx);
//    }
    
}

- (void)strokeChart
{
    if([_data count] == 0) {
        NSLog(@"Warning: no data provided for the chart");
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *noPath = [UIBezierPath bezierPath];
    UIBezierPath* fill = [UIBezierPath bezierPath];
    UIBezierPath* noFill = [UIBezierPath bezierPath];
    
    CGFloat scale = _axisHeight / _max;
    NSLog(@"^^^^%f",scale);
    NSNumber* first = _data[0];
    
    for(int i=1;i<_data.count;i++) {
        NSNumber* last = _data[i - 1];
        NSNumber* number = _data[i];
        
        CGPoint p1 = CGPointMake(_margin + (i - 1) * (_axisWidth / (_data.count - 1)), _axisHeight + _margin - [last floatValue] * scale);
        
        CGPoint p2 = CGPointMake(_margin + i * (_axisWidth / (_data.count - 1)), _axisHeight + _margin - [number floatValue] * scale);
         
        [fill moveToPoint:p1];
        [fill addLineToPoint:p2];
        [fill addLineToPoint:CGPointMake(p2.x, _axisHeight + _margin)];
        [fill addLineToPoint:CGPointMake(p1.x, _axisHeight + _margin)];
        
        [noFill moveToPoint:CGPointMake(p1.x, _axisHeight + _margin)];
        [noFill addLineToPoint:CGPointMake(p2.x, _axisHeight + _margin)];
        [noFill addLineToPoint:CGPointMake(p2.x, _axisHeight + _margin)];
        [noFill addLineToPoint:CGPointMake(p1.x, _axisHeight + _margin)];
    }
    
    
    [path moveToPoint:CGPointMake(_margin, _axisHeight + _margin - [first floatValue] * scale)];
    [noPath moveToPoint:CGPointMake(_margin, _axisHeight + _margin)];
    
    for(int i=1;i<_data.count;i++) {
        NSNumber* number = _data[i];
        
        [path addLineToPoint:CGPointMake(_margin + i * (_axisWidth / (_data.count - 1)), _axisHeight + _margin - [number floatValue] * scale)];
        [noPath addLineToPoint:CGPointMake(_margin + i * (_axisWidth / (_data.count - 1)), _axisHeight + _margin)];
    }
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.frame = self.bounds;
    fillLayer.bounds = self.bounds;
    fillLayer.path = fill.CGPath;
    fillLayer.strokeColor = nil;
    fillLayer.fillColor = [_color colorWithAlphaComponent:0.25].CGColor;
    fillLayer.lineWidth = 0;
    fillLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:fillLayer];
    
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.bounds;
    pathLayer.bounds = self.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [_color CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 0.7;
    pathLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:pathLayer];
    
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = 0.25;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.fromValue = (id)noFill.CGPath;
    fillAnimation.toValue = (id)fill.CGPath;
    [fillLayer addAnimation:fillAnimation forKey:@"path"];
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = 0.25;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = (__bridge id)(noPath.CGPath);
    pathAnimation.toValue = (__bridge id)(path.CGPath);
    [pathLayer addAnimation:pathAnimation forKey:@"path"];
    
  
    
    
}

- (void)setDefaultParameters
{
    _color = [UIColor fsGreen];
    _gridStep = 7;
    _margin = 5.0f;
    _axisWidth = self.frame.size.width - 2 * _margin;
    _axisHeight = self.frame.size.height - 2 * _margin;
    _axisColor = [UIColor colorWithWhite:0.7 alpha:1.0];
}

- (CGFloat)getUpperRoundNumber:(CGFloat)value forGridStep:(int)gridStep
{
    // We consider a round number the following by 0.5 step instead of true round number (with step of 1)
    CGFloat logValue = log10f(value);
    CGFloat scale = powf(10, floorf(logValue));
    CGFloat n = ceilf(value / scale * 2);
    
    int tmp = (int)(n) % gridStep;
    
    if(tmp != 0) {
        n += gridStep - tmp;
    }
    
    return n * scale / 2.0f;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
