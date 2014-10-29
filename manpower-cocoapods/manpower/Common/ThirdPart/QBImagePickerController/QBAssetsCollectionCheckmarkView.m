//
//  QBAssetsCollectionCheckmarkView.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2014/01/01.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionCheckmarkView.h"

@interface QBAssetsCollectionCheckmarkView(){
    UITapGestureRecognizer *tapGestureRecognizer;
}
@end

@implementation QBAssetsCollectionCheckmarkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // View settings
        self.backgroundColor = [UIColor clearColor];
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCheckmark:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        _animated = YES;
        _bounced = YES;
    }
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(24.0, 24.0);
}

- (void)check{
    _checked = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkmarkViewShouldCheck:)]) {
        _checked = [self.delegate checkmarkViewShouldCheck:self];
    }
    [self setNeedsDisplay];
    
    if (_animated) {
//        NSLog(@"%@",NSStringFromCGRect(self.frame));
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
//        NSLog(@"%@",NSStringFromCGRect(self.frame));

        [UIView animateWithDuration:0.2 animations:^{
            CGAffineTransform transform;
            transform = _bounced ? CGAffineTransformMakeScale(0.8, 0.8) : CGAffineTransformMakeScale(1, 1);
            self.transform = transform;

        } completion:^(BOOL finished){
            if (_bounced) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            }
//            NSLog(@"%@",NSStringFromCGRect(self.frame));
        }];
    }
    
    if (_checked) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkmarkViewDidCheck:)]) {
            [self.delegate checkmarkViewDidCheck:self];
        }
    }
}

- (void)uncheck{
    _checked = NO;
    [self setNeedsDisplay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkmarkViewDidUncheck:)]) {
        [self.delegate checkmarkViewDidUncheck:self];
    }
}

- (void)selectCheckmark:(UITapGestureRecognizer*)tap{
    _checked = !_checked;
    if (_checked) {
        [self check];
    }else{
        [self uncheck];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);


    if (_checked) {
        // Body
//        [UIColor colorWithRed:10.0/255 green:233/255 blue:100/255.0 alpha:1];
        CGContextSetRGBFillColor(context, 20.0/255.0, 233.0/255.0, 100.0/255.0, 1.0);
        CGContextFillEllipseInRect(context, CGRectInset(self.bounds, 1.0, 1.0));
    }else{
        CGContextSetRGBFillColor(context, 0, 0, 0, 0.1);
        CGContextFillEllipseInRect(context, CGRectInset(self.bounds, 1.0, 1.0));
        
        // Border
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextSetLineWidth(context, 1);
        CGContextAddEllipseInRect(context, CGRectInset(self.bounds, 2.0, 2.0));
    }
        
    // Checkmark
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 1.2);
    
    CGContextMoveToPoint(context, 6.0, 12.0);
    CGContextAddLineToPoint(context, 10.0, 16.0);
    CGContextAddLineToPoint(context, 18.0, 8.0);
    
    CGContextStrokePath(context);
}


-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    [super hitTest:point withEvent:event];
    NSLog(@"======%@",NSStringFromCGPoint(point));
    if (CGRectContainsPoint(CGRectMake(-6, -6, 36, 36), point)) {
        return self;
    }
    return nil;
}
@end
