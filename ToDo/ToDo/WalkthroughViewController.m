//
//  WalkthroughViewController.m
//  ToDo
//
//  Created by Cubes School 6 on 4/22/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import "WalkthroughViewController.h"
#import "Constants.h"

@interface WalkthroughViewController ()
@end

@implementation WalkthroughViewController

#pragma mark - Actions

- (IBAction)closeButtonTapped:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WALKTHROUGH_PRESENTED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
