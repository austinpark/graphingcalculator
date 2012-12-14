//
//  GraphingViewController.m
//  Calculator
//
//  Created by Austin on 12/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphingViewController.h"
#import "GraphView.h"

@interface GraphingViewController()
@property (weak, nonatomic) IBOutlet GraphView *graphView;

@end

@implementation GraphingViewController


@synthesize graphView = _graphView;
@synthesize programStack = _programStack;

- (void) setProgramStack:(NSMutableArray*)stack {
    if (_programStack == nil) {
        _programStack = [[NSMutableArray alloc] init];
    }
    if (stack != _programStack) {
        [_programStack removeAllObjects];
        _programStack = [stack mutableCopy];
    }
    
    [self.graphView setNeedsDisplay];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES; // support all orientations
}
@end
