//
//  GraphingViewController.h
//  Calculator
//
//  Created by Austin on 12/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonProtocol.h"

@interface GraphingViewController : UIViewController <SplitViewBarButtonProtocol>

@property (nonatomic, strong)  id program;

@end
