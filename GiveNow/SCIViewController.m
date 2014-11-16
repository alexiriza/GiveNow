//
//  SCIViewController.m
//  GiveNow
//
//  Created by Alexander Iriza on 11/16/14.
//  Copyright (c) 2014 Alex Iriza. All rights reserved.
//

#import "SCIViewController.h"
#import <Parse/Parse.h>

@interface SCIViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation SCIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    NSNumber *sciTotal = (NSNumber *)currentUser[@"sciTotal"];
    self.label.text = [NSString stringWithFormat:@"So far you have donated $%.2f to SCI.", [sciTotal doubleValue]];
}


@end
