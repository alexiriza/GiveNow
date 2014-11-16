//
//  EAViewController.m
//  GiveNow
//
//  Created by Alexander Iriza on 11/16/14.
//  Copyright (c) 2014 Alex Iriza. All rights reserved.
//

#import "EAViewController.h"
#import <Parse/Parse.h>

@interface EAViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation EAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    NSNumber *eaTotal = (NSNumber *)currentUser[@"eaTotal"];
    self.label.text = [NSString stringWithFormat:@"So far you have donated $%.2f to Evidence Action.", [eaTotal doubleValue]];
}

@end
