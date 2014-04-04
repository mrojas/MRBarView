//
//  MRBarView.h
//  barview
//
//  Created by Matias Rojas on 03/04/14.
//  Copyright (c) 2014 Causania. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRBarView;

/**
 *  Datasource for the single bar chart
 */
@protocol MRBarViewDataSource <NSObject>

@required

/**
 *  Retrieves the total count of segments in the bar view
 *
 *  @param barView The bar view
 *
 *  @return The total count of segments
 */
- (NSInteger)numberOfSegmentsInBarView:(MRBarView *)barView;

/**
 *  Gets the value at a specified index
 *
 *  @param barView The bar view
 *  @param index   The index
 *
 *  @return The value
 */
- (CGFloat)barView:(MRBarView *)barView valueAtIndex:(NSInteger)index;

/**
 *  Gets the color to represent a given segment
 *
 *  @param barView The bar view
 *  @param index   The index of the segment
 *
 *  @return The color of the segment
 */
- (UIColor *)barView:(MRBarView *)barView colorAtIndex:(NSInteger)index;

@optional

/**
 *  Gets the label for a given segment
 *
 *  @param barView The bar view
 *  @param index   The index of the segment
 *
 *  @return The label for the segment. Return nil or empty string to skip the label.
 */
- (NSString *)barView:(MRBarView *)barView labelAtIndex:(NSInteger)index;

@end

/**
 *  A single bar chart containing segments of different colors.
 */
@interface MRBarView : UIView

/**
 *  The datasource for this bar
 */
@property (nonatomic, strong) id<MRBarViewDataSource> datasource;

/**
 *  The background color of the bar. To change the background color of the container, simply use backgroundColor. Default: white.
 */
@property (nonatomic, strong) UIColor *barBackgroundColor;

/**
 *  The font to be used on the labels. Default: system font, 14dp
 */
@property (nonatomic, strong) UIFont *labelFont;

/**
 *  The color of the labels. Default: black
 */
@property (nonatomic, strong) UIColor *labelColor;

/**
 *  The height of the bar. Default: 35dp
 */
@property (nonatomic, assign) CGFloat barHeight;

/**
 *  Margin between the bar and the container. Applies to left, top and right borders. Default: 10dp
 */
@property (nonatomic, assign) CGFloat barMargin;

/**
 *  Whether the container and the bar have rounded corners or not. Default: NO
 */
@property (nonatomic, assign) BOOL roundedCorners;


/**
 *  Reloads the data in this bar.
 */
- (void)reloadData:(BOOL)animated;

@end
