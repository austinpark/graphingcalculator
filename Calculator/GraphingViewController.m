//
//  GraphingViewController.m
//  Calculator
//
//  Created by Austin on 12/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphingViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphingViewController() <GraphViewDataSource>
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation GraphingViewController


@synthesize graphView = _graphView;
@synthesize program = _program;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem 
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.splitViewController.presentsWithGesture = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES; // support all orientations
}


- (void) refreshGraphView {
    if (!self.program) return;
    
    if (!self.graphView) return;
    
    NSString *description = [CalculatorBrain descriptionOfProgram:self.program];
    
    CGFloat scale = [[NSUserDefaults standardUserDefaults] floatForKey:[@"scale." stringByAppendingString:description]];
    
    CGFloat xOrigin = [[NSUserDefaults standardUserDefaults] floatForKey:[@"x." stringByAppendingString:description]];
    
    CGFloat yOrigin = [[NSUserDefaults standardUserDefaults] floatForKey:[@"y." stringByAppendingString:description]];
    
    if (scale) self.graphView.scale = scale;
    
    if (xOrigin && yOrigin) {
        CGPoint origin;
        
        origin.x = xOrigin;
        origin.y = yOrigin;
        
        self.graphView.origin = origin;
    }
    
    [self.graphView setNeedsDisplay];
}

- (void) setProgram:(id)program {
    
    _program = program;
    
    self.title = [NSString stringWithFormat:@"y = %@", [CalculatorBrain descriptionOfProgram:program]];
                      
    [self refreshGraphView];
}

- (void) setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    
    self.graphView.dataSource = self;
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self.graphView action:@selector(pinch:)]];
    
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self.graphView action:@selector(pan:)]];
    
    UITapGestureRecognizer* tabRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self.graphView action:@selector(tripleTap:)];
    
    tabRecognizer.numberOfTapsRequired = 3;
    
    [self.graphView addGestureRecognizer:tabRecognizer];
    
    [self refreshGraphView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)viewDidUnload {
    [self setGraphView:nil];
    [self setGraphView:nil];
    [super viewDidUnload];
}

- (void) persistScale:(CGFloat)scale forGraphView:(GraphView*)sender {
    
    [[NSUserDefaults standardUserDefaults] setFloat:scale forKey:[@"scale." stringByAppendingString:[CalculatorBrain descriptionOfProgram:self.program]]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CGFloat)YValueForXValue:(CGFloat)x inGraphView:(GraphView*)sender {
    
    NSNumber* xValue = [NSNumber numberWithFloat:x];
    
    double y = [CalculatorBrain runProgram:self.program usingVariableValues:[NSDictionary dictionaryWithObject:xValue forKey:@"x"]];
    
    return y;
}

- (void)persistAxisOrigin:(CGFloat)x andY:(CGFloat)y forGraphView:(GraphView*)sender {
    
    NSString *description = [CalculatorBrain descriptionOfProgram:self.program];
    
    [[NSUserDefaults standardUserDefaults] setFloat:x forKey:[@"x." stringByAppendingString:description]];
    
    [[NSUserDefaults standardUserDefaults] setFloat:y forKey:[@"y." stringByAppendingString:description]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
