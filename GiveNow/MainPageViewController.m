//
//  MainPageViewController.m
//  Give Now
//
//  Created by Emma Trefethen & Alexander Iriza on 11/14/14.
//  Copyright (c) 2014 Emma Trefethen & Alex Iriza. All rights reserved.
//

#import "MainPageViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface MainPageViewController ()
@property (strong, nonatomic) DwollaAPI *dwollaAPI;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *eaButton;
@property (weak, nonatomic) IBOutlet UIButton *gdButton;
@property (weak, nonatomic) IBOutlet UIButton *sciButton;
@property (weak, nonatomic) IBOutlet UIButton *donateButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dwollaAPI = [DwollaAPI sharedInstance];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.amountTextField.delegate = self;
    [self.amountTextField setTintColor:[UIColor clearColor]];
    
    self.donateButton.layer.cornerRadius = 8;

    NSString *userID = [self.dwollaAPI getAccountInfo].userID;
    
    [PFUser logInWithUsernameInBackground:userID password:@"" block:^(PFUser *user, NSError *error) {
        if (user == nil) {
            PFUser *user = [PFUser user];
            user.username = userID;
            user.password = @"";
            user[@"eaTotal"] = [NSNumber numberWithDouble:0.0];
            user[@"gdTotal"] = [NSNumber numberWithDouble:0.0];
            user[@"sciTotal"] = [NSNumber numberWithDouble:0.0];
            [user signUpInBackground];
        }
    }];
    
    self.logoutButton.hidden = YES;
    self.messageLabel.hidden = YES;
}

- (IBAction)logout:(UIButton *)sender {
    
    NSLog(@"%@", [NSNumber numberWithBool:[self.client isAuthorized]]);
    //[self.dwollaAPI clearAccessToken];
    [self.client logout];
    NSLog(@"%@", [NSNumber numberWithBool:[self.client isAuthorized]]);

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if (textField == self.amountTextField) {
        double currentValue;
        if ([[textField text] length] >= 1)
            currentValue = [[[textField text] substringFromIndex:1] doubleValue];
        else
            currentValue = 0.0;
        
        if (currentValue >= 1.00 && [string length]) {
            return NO;
        }
        
        double cents = round(currentValue * 100.0f);
        
        if ([string length]) {
            for (size_t i = 0; i < [string length]; i++) {
                unichar c = [string characterAtIndex:i];
                if (isnumber(c)) {
                    cents *= 10;
                    cents += c - '0';
                }
            }
        } else {
            // back Space
            cents = floor(cents / 10);
        }
        
        if (cents == 0.0)
            textField.text = @"";
        else
            textField.text = [NSString stringWithFormat:@"$%.2f", cents / 100.0f];

        return NO;
    } else {
        if ([[textField text] length] < 4 || ![string length])
            return YES;
        else
            return NO;
    }
}

- (IBAction)selectEADown:(UIButton *)sender {
    [self dismissKeyboard];
    self.gdButton.highlighted = NO;
    self.sciButton.highlighted = NO;
    self.gdButton.selected = NO;
    self.sciButton.selected = NO;
    self.eaButton.selected = !self.eaButton.selected;
}

- (IBAction)selectEAUp:(UIButton *)sender {
    if (self.eaButton.selected) {
        self.messageLabel.text = @"$1 = 0.58 deworming treatments";
    } else {
        self.messageLabel.text = @"";
    }
    [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
}

- (IBAction)selectGDDown:(UIButton *)sender {
    [self dismissKeyboard];
    self.eaButton.highlighted = NO;
    self.sciButton.highlighted = NO;
    self.eaButton.selected = NO;
    self.sciButton.selected = NO;
    self.gdButton.selected = !self.gdButton.selected;
}

- (IBAction)selectGDUp:(UIButton *)sender {
    if (self.gdButton.selected) {
        self.messageLabel.text = @"90\% goes directly to recipients";
    } else {
        self.messageLabel.text = @"";
    }
    [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
}

- (IBAction)selectSCIDown:(UIButton *)sender {
    [self dismissKeyboard];
    self.eaButton.highlighted = NO;
    self.gdButton.highlighted = NO;
    self.eaButton.selected = NO;
    self.gdButton.selected = NO;
    self.sciButton.selected = !self.sciButton.selected;
}

- (IBAction)selectSCIUp:(UIButton *)sender {
    if (self.sciButton.selected) {
        self.messageLabel.text = @"$1 = 0.62 deworming treatments";
    } else {
        self.messageLabel.text = @"";
    }
    [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
}

- (void)doHighlight:(UIButton*)b {
    if (b.selected)
        b.highlighted = YES;
}

- (void)dismissKeyboard
{
    [self.amountTextField resignFirstResponder];
}

- (void)resetUI
{
    self.amountTextField.text = @"";
    self.eaButton.highlighted = NO;
    self.gdButton.highlighted = NO;
    self.sciButton.highlighted = NO;
    self.eaButton.selected = NO;
    self.gdButton.selected = NO;
    self.sciButton.selected = NO;
    self.messageLabel.text = @"";
}

- (IBAction)donate:(UIButton *)sender {
    if (self.sciButton.highlighted) {
        UIAlertView *noSCIAlert = [[UIAlertView alloc] initWithTitle:@"SCI is not yet supported"
                                                             message:@""
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [noSCIAlert show];
    } else if (![[self.amountTextField text] length]) {
        UIAlertView *noMoneyAlert = [[UIAlertView alloc] initWithTitle:@"Please enter a non-zero amount"
                                                                    message:@""
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
        [noMoneyAlert show];
    } else if (!self.eaButton.highlighted && !self.gdButton.highlighted && !self.sciButton.highlighted) {
        UIAlertView *noneSelectedAlert = [[UIAlertView alloc] initWithTitle:@"Please select a charity"
                                                                    message:@""
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
        [noneSelectedAlert show];
        return;
    } else {
        UIAlertView *pinAlert = [[UIAlertView alloc] initWithTitle:@"Please enter your Dwolla PIN"
                                                             message:@""
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"OK", nil];
        
        pinAlert.delegate = self;
        pinAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [pinAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [pinAlert textFieldAtIndex:0].textAlignment = NSTextAlignmentCenter;
        [pinAlert textFieldAtIndex:0].placeholder = @"PIN";
        [pinAlert textFieldAtIndex:0].delegate = self;
        [pinAlert show];
    }
}

#define EA_DESTINATION_ID @"812-825-4787"
#define GD_DESTINATION_ID @"812-935-3775"

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        double doubleAmount = [[[self.amountTextField text] substringFromIndex:1] doubleValue];
        NSString *amount = [NSString stringWithFormat:@"%.2f", doubleAmount];
        
        NSString *selectedCharity;
        NSString *selectedCharityID;
        NSString *selectedCharityTotal;
        if (self.eaButton.highlighted) {
            selectedCharity = @"Evidence Action";
            selectedCharityID = EA_DESTINATION_ID;
            selectedCharityTotal = @"eaTotal";
        } else if (self.gdButton.highlighted) {
            selectedCharity = @"GiveDirectly";
            selectedCharityID = GD_DESTINATION_ID;
            selectedCharityTotal = @"gdTotal";
        }
        
        NSArray *fundingSources = [self.dwollaAPI getFundingSources];
        NSString *fundingSourceID;
        for (DwollaFundingSource *dfs in fundingSources) {
            if ([dfs.type isEqualToString:@"Checking"] && dfs.isVerified)
                fundingSourceID = dfs.sourceID;
        }
        
        if (fundingSourceID == nil) {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"No checking accounts attached."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
            [errorAlert show];
            return;
        }
        
        @try {
            [self.dwollaAPI sendMoneyWithPIN:[alertView textFieldAtIndex:0].text destinationID:selectedCharityID destinationType:@"Dwolla" amount:amount facilitatorAmount:@"0" assumeCosts:@"false" notes:@"" fundingSourceID:fundingSourceID];
            
            PFUser *currentUser = [PFUser currentUser];
            NSNumber *currentTotal = (NSNumber *)currentUser[selectedCharityTotal];
            currentUser[selectedCharityTotal] = [NSNumber numberWithDouble:([currentTotal doubleValue] + doubleAmount)];
            [currentUser save];
            
            UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                   message:[NSString stringWithFormat:@"You have donated $%@ to %@!", amount, selectedCharity]
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            [successAlert show];
            [self resetUI];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
            if ([exception.reason isEqualToString:@"Invalid account PIN"]) {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error - Invalid PIN"
                                                                     message:@""
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                [errorAlert show];
            } else {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:exception.reason
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                [errorAlert show];
            }
        }
    }
}

@end
