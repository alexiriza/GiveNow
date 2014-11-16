//
//  GDViewController.m
//  GiveNow
//
//  Created by Alexander Iriza on 11/16/14.
//  Copyright (c) 2014 Alex Iriza. All rights reserved.
//

#import "GDViewController.h"
#import <Parse/Parse.h>

@interface GDViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation GDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    NSNumber *gdTotal = (NSNumber *)currentUser[@"gdTotal"];
    self.label.text = [NSString stringWithFormat:@"So far you have donated $%.2f to GiveDirectly.", [gdTotal doubleValue]];
}

@end
