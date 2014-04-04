//
//  MRBarView.m
//  barview
//
//  Created by Matias Rojas on 03/04/14.
//  Copyright (c) 2014 Causania. All rights reserved.
//

#import "MRBarView.h"
#import <QuartzCore/QuartzCore.h>

#define kDefaultBarHeight 30.0
#define kDefaultBarMargin 10.0
#define kCircleRadius 10.0
#define kRoundedCornerRadius 5.0
#define kMarginBetweenLabels 3.0

@implementation MRBarView {
    UIView *_bar;
    NSMutableArray *_segments;
    CGFloat _barWidth;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self commonInit];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    self.clipsToBounds = YES;
    _barHeight = kDefaultBarHeight;
    _barBackgroundColor = [UIColor whiteColor];
    _labelColor = [UIColor blackColor];
    _labelFont = [UIFont systemFontOfSize:11.0];
    _barMargin = kDefaultBarMargin;
    _barWidth = self.frame.size.width-_barMargin*2;
    _bar = [[UIView alloc] initWithFrame:CGRectMake(_barMargin, _barMargin, _barWidth, _barHeight)];
    _bar.clipsToBounds = YES;
    _bar.backgroundColor = _barBackgroundColor;
}

- (void)setDatasource:(id<MRBarViewDataSource>)datasource {
    _datasource = datasource;
    [self reloadData:YES];
}

- (void)setRoundedCorners:(BOOL)roundedCorners {
    _roundedCorners = roundedCorners;
    if (_roundedCorners) {
        _bar.layer.cornerRadius = kRoundedCornerRadius;
        self.layer.cornerRadius = kRoundedCornerRadius;
    } else {
        _bar.layer.cornerRadius = 0.0;
        self.layer.cornerRadius = 0.0;
    }
}

- (void)setBarHeight:(CGFloat)barHeight {
    _barHeight = barHeight;
    CGRect frame = _bar.frame;
    frame.size.height = _barHeight;
    _bar.frame = frame;
    for (UIView *v in _segments) {
        CGRect f = v.frame;
        f.size.height = _barHeight;
        v.frame = f;
    }
}

- (void)setBarMargin:(CGFloat)barMargin {
    _barMargin = barMargin;
    CGRect frame = _bar.frame;
    frame.origin.x = _barMargin;
    frame.origin.y = _barMargin;
    _barWidth = self.frame.size.width - (_barMargin * 2);
    frame.size.height = _barHeight;
    frame.size.width = _barWidth;
    _bar.frame = frame;
}

- (void)reloadData:(BOOL)animated {
    if (_datasource) {
        // Clean view
        [_bar.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        NSInteger itemCount = [_datasource numberOfSegmentsInBarView:self];
        _segments = [NSMutableArray arrayWithCapacity:itemCount];
        CGFloat total = 0.0;
        
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:itemCount];
        
        for (NSInteger i = 0; i < itemCount; i++) {
            CGFloat value = [_datasource barView:self valueAtIndex:i];
            [values addObject:[NSNumber numberWithFloat:value]];
            total += value;
        }
        
        CGFloat sumWidth = 0.0;
        for (NSInteger i = 0; i < values.count; i++) {
            NSNumber *value = [values objectAtIndex:i];
            CGFloat width = value.floatValue / total * _barWidth;
            UIView *barSegment = [[UIView alloc] initWithFrame:CGRectMake(sumWidth, 0, width, _barHeight)];
            barSegment.backgroundColor = [_datasource barView:self colorAtIndex:i];
            [_segments addObject:barSegment];
            
            sumWidth += width;
            
            if (!animated) {
                [_bar addSubview:barSegment];
            }
        }
        
        [self addSubview:_bar];
        
        if (animated) {
            [self animateSegments:0];
        }
        
        [self addLabels];
    }
}

- (void)animateSegments:(NSInteger)index {
    if (_segments.count > 0 && _segments.count > index) {
        UIView *v = [_segments objectAtIndex:index];
        CGRect frame = v.frame;
        CGFloat width = frame.size.width;
        frame.size.width = 0;
        v.frame = frame;
        [_bar addSubview:v];
        frame.size.width = width;
        
        [UIView animateWithDuration:0.5/_segments.count delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionTransitionNone animations:^{
            v.frame = frame;
        } completion:^(BOOL finished) {
            [self animateSegments:index+1];
        }];
    }
}

- (void)addLabels {
    if (_datasource && [_datasource respondsToSelector:@selector(barView:labelAtIndex:)]) {
        CGFloat x = _bar.frame.origin.x;
        CGFloat y = _bar.frame.origin.y + _bar.frame.size.height + _barMargin;
        
        for (NSInteger i = 0; i < _segments.count; i++) {
            NSString *text = [_datasource barView:self labelAtIndex:i];
            if (text.length > 0) {
                UIView *segment = [_segments objectAtIndex:i];
                
                UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(x, y, kCircleRadius, kCircleRadius)];
                circle.backgroundColor = segment.backgroundColor;
                circle.layer.cornerRadius = kCircleRadius / 2;
                [self addSubview:circle];
                
                UILabel *l = [[UILabel alloc] init];
                l.backgroundColor = [UIColor clearColor];
                l.textColor = _labelColor;
                l.font = _labelFont;
                l.text = [_datasource barView:self labelAtIndex:i];
                [l sizeToFit];
                CGRect labelFrame = l.frame;
                labelFrame.origin.x = circle.frame.origin.x + circle.frame.size.width + kMarginBetweenLabels;
                
                if (labelFrame.origin.x + labelFrame.size.width > _bar.frame.origin.x + _bar.frame.size.width) {
                    // Next line
                    x = _bar.frame.origin.x;
                    y = circle.frame.origin.y + labelFrame.size.height + kMarginBetweenLabels;
                    CGRect frame = circle.frame;
                    frame.origin.x = x;
                    frame.origin.y = y;
                    circle.frame = frame;
                }
                
                labelFrame.origin.x = circle.frame.origin.x + circle.frame.size.width + kMarginBetweenLabels;
                labelFrame.origin.y = circle.frame.origin.y + (kCircleRadius / 2) - (labelFrame.size.height / 2.0);
                l.frame = labelFrame;
                [self addSubview:l];
                
                x = l.frame.origin.x + l.frame.size.width + kMarginBetweenLabels;
            }
        }
    }
}

@end
