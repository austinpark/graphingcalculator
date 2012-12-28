//
//  GraphView.m
//  Calculator
//
//  Created by Austin on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize origin = _origin;
@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 100.0

- (CGPoint)origin {
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width /2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    return midPoint;
}

- (void) setOrigin:(CGPoint)origin {
    if (_origin.x == origin.x && _origin.y == origin.y) return;
    
    _origin = origin;
    
    [self.dataSource persistAxisOrigin:_origin.x andY:_origin.y forGraphView:self];
    
    [self setNeedsDisplay];
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
        
        [self.dataSource persistScale:_scale forGraphView:self];
        
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

- (CGRect)graphBounds {
    return self.bounds;
}

- (CGPoint)fromViewCoordinateToGraphCoordinate:(CGPoint)coordinate {
    
    CGPoint graphCoordinate;
    
    graphCoordinate.x = (coordinate.x - self.origin.x) / self.scale;
    graphCoordinate.y = (self.origin.y - coordinate.y) / self.scale;
    
    return graphCoordinate;
}

- (CGPoint) fromGraphCoordinateToViewCoordinate:(CGPoint) coordinate {
    CGPoint viewCoordinate;
    
    viewCoordinate.x = (coordinate.x * self.scale) + self.origin.x;
    viewCoordinate.y = self.origin.y - (coordinate.y * self.scale);
    
    return viewCoordinate;
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

    //draw axis
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] setStroke];
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin  scale:self.scale];
    
    //Setting the graph line
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor]CGColor]);
    
    CGContextBeginPath(context);
    
    CGFloat startingX = self.graphBounds.origin.x;
    CGFloat endingX = self.graphBounds.origin.x + self.graphBounds.size.width;
    CGFloat increment = 1/self.contentScaleFactor;
    
    BOOL firstPoint = YES;
    
    for (CGFloat x = startingX; x <= endingX; x += increment) {
        
        CGPoint coordinate;
        coordinate.x = x;
        coordinate = [self fromViewCoordinateToGraphCoordinate:coordinate];
        coordinate.y = [self.dataSource YValueForXValue:coordinate.x inGraphView:self];
        coordinate = [self fromGraphCoordinateToViewCoordinate:coordinate];
        coordinate.x = x;
        
        if (coordinate.y == NAN || coordinate.y == INFINITY || coordinate.y == -INFINITY)
            continue;
        
        if (firstPoint) {
            CGContextMoveToPoint(context, coordinate.x, coordinate.y);
            firstPoint = NO;
        }
        
        CGContextAddLineToPoint(context, coordinate.x, coordinate.y);
        
    }
    
    CGContextStrokePath(context);

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
