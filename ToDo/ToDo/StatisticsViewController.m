//
//  StatisticsViewController.m
//  ToDo
//
//  Created by Cubes School 6 on 5/20/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController ()
@property (weak,nonatomic) IBOutlet UILabel *completedPercentageLabel;
@property (weak,nonatomic) IBOutlet UILabel *notCompletedPercentageLabel;
@property (weak,nonatomic) IBOutlet UILabel *inProgressPercentageLabel;
@property (weak,nonatomic) IBOutlet UILabel *completedCountLabel;
@property (weak,nonatomic) IBOutlet UILabel *notCompletedCountLabel;
@property (weak,nonatomic) IBOutlet UILabel *inProgressCountLabel;
@end

@implementation StatisticsViewController

#pragma mark - Actions
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
