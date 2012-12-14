//
//  GraphView.m
//  Calculator
//
//  Created by Austin on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView() 
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
@end

@implementation GraphView

@synthesize origin = _origin;
@synthesize scale = _scale;

#define DEFAULT_SCALE 0.90

- (CGPoint)origin {
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width /2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    return midPoint;
}

- (CGFloat) scale {
    
    if (!_scale) {
        return DEFAULT_SCALE; // don't allow zero scale
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] setStroke];

    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin  scale:self.scale];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
