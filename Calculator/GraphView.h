//
//  GraphView.h
//  Calculator
//
//  Created by Austin on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource
- (CGFloat)YValueForXValue:(CGFloat)x inGraphView:(GraphView*)sender;
- (void)persistScale:(CGFloat)scale forGraphView:(GraphView*)sender;
- (void)persistAxisOrigin:(CGFloat)x andY:(CGFloat)y forGraphView:(GraphView*)sender;
@end

@interface GraphView : UIView

@property(nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@property(nonatomic) CGFloat scale;
@property(nonatomic) CGPoint origin;

@end
