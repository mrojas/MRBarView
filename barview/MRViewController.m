//
//  MRViewController.m
//  barview
//
//  Created by Matias Rojas on 03/04/14.
//  Copyright (c) 2014 Causania. All rights reserved.
//

#import "MRViewController.h"

@interface MRViewController () <MRBarViewDataSource>

@property (strong, nonatomic) IBOutlet MRBarView *barView;
@property (strong, nonatomic) IBOutlet UISwitch *animationsSwitch;

@end

@implementation MRViewController {
    NSArray *_colors;
    NSMutableArray *_labels;
    NSMutableArray *_values;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *ma = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 50; i++) {
        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [ma addObject:color];
    }
    _colors = ma;
    
    _labels = [NSMutableArray arrayWithObjects:@"Segment 1", @"Segment 2", @"Segment 3", @"Segment 4", nil];
    _values = [NSMutableArray arrayWithObjects:@10.0, @20.0, @23.0, @5.0, nil];
    
    _barView.roundedCorners = YES;
    _barView.labelColor = [UIColor colorWithRed:0.266 green:0.266 blue:0.266 alpha:1.0];
	_barView.datasource = self;
}

- (IBAction)addSegmentButtonPressed:(id)sender {
    if (_values.count < 50) {
        float rndValue = (((float)arc4random()/0x100000000)*(20.0-5.0)+5.0);
        [_values addObject:[NSNumber numberWithFloat:rndValue]];
        [_labels addObject:[NSString stringWithFormat:@"Segment %d", _values.count]];
        [_barView reloadData:_animationsSwitch.on];
    }
}

- (IBAction)removeSegmentButtonPressed:(id)sender {
    if (_values.count > 0) {
        [_values removeObjectAtIndex:_values.count-1];
        [_labels removeObjectAtIndex:_labels.count-1];
    }
    [_barView reloadData:_animationsSwitch.on];
}

- (NSInteger)numberOfSegmentsInBarView:(MRBarView *)barView {
    return _values.count;
}

- (CGFloat)barView:(MRBarView *)barView valueAtIndex:(NSInteger)index {
    return [[_values objectAtIndex:index] floatValue];
}

- (UIColor *)barView:(MRBarView *)barView colorAtIndex:(NSInteger)index {
    return [_colors objectAtIndex:index];
}

- (NSString *)barView:(MRBarView *)barView labelAtIndex:(NSInteger)index {
    return [_labels objectAtIndex:index];
}

@end
