MRBarView
=========

A single bar chart for iOS

###Installation

- Clone this github repo
- Add the MRBarView directory to your project

### Usage

MRBarView follows the usual data source pattern. You view controller should implement the protocol **MRBarViewDataSource**.
The following methods are mandatory:

- numberOfSegmentsInBarView: Determines how many segments are in the bar view. Example:
```Objective-C
- (NSInteger)numberOfSegmentsInBarView:(MRBarView *)barView {
    return 5;
}
```

- valueAtIndex: Returns the value for a given segment. Example:
```Objective-C
- (CGFloat)barView:(MRBarView *)barView valueAtIndex:(NSInteger)index {
    return 4.13;
}
```

- colorAtIndex: Returns the color for a given segment. Example:
```Objective-C
- (UIColor *)barView:(MRBarView *)barView colorAtIndex:(NSInteger)index {
    return [UIColor redColor];
}
```

Optionally, you can return a label for each segment. Labels are shown below the bar.

- labelAtIndex: Returns the label for a given segment. Example:
```Objective-C
- (NSString *)barView:(MRBarView *)barView labelAtIndex:(NSInteger)index {
    return @"Segment 1";
}
```

Notice that MRBarView will automatically calculate each segment's width in the bar by summing all the values provided by the datasource and calculating the proportion of each segment.

###Storyboards

In addition to using the bar view by doing [[MRBarView alloc] initWithFrame:...], if you are using storyboards you can simply drag a UIView into a view controller and set its class to MRBarView.


### Customization

The following properties are customizable:

- UIColor *barBackgroundColor: The background color of the bar. Default: white.
- UIFont *labelFont: Font for the labels. Default: system font, 14dp.
- UIColor *labelColor: Color for the labels. Default: Black.
- CGFloat barHeight: Height of the bar. Default: 35dp.
- CGFloat barMargin: The margin between the bar and the borders of the container. Default: 10dp.
- BOOL roundedCorners: Whether the bar and the container have rounded corners or not. Default: NO.

### Reloading

To reload the bar view call **reloadData:(BOOL)animated**
Check the sample project for documentation and usage options

### To-Do

- Better animations
- Provide a delegate protocol and allow the selection of segments
- Allow customization of segments (shadow, borders)
