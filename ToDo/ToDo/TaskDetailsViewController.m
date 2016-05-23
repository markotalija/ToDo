//
//  TaskDetailsViewController.m
//  ToDo
//
//  Created by Cubes School 6 on 5/20/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import "TaskDetailsViewController.h"
#import "DataManager.h"
#import <MapKit/MapKit.h>
#import "UIViewController+Utilities.h"

#define kRegionRadius 50000

@interface TaskDetailsViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *groupSelectorImageView;
@property (weak, nonatomic) IBOutlet UIView *completedView;
@property (weak, nonatomic) IBOutlet UIView *notCompletedView;
@property (weak, nonatomic) IBOutlet UIView *inProgressView;
@property (nonatomic) NSInteger group;
@end

@implementation TaskDetailsViewController

#pragma mark - Properties

- (void)setGroup:(NSInteger)group {
    _group = group;
    
    __block CGPoint point;
    
    switch (group) {
        case COMPLETED_TASK_GROUP:
            point = self.completedView.center;
            break;
            
        case NOT_COMPLETED_TASK_GROUP:
            point = self.notCompletedView.center;
            break;
            
        case IN_PROGRESS_TASK_GROUP:
            point = self.inProgressView.center;
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.groupSelectorImageView.center = point;
    }];
}

#pragma mark - Actions

- (IBAction)backButtonTapped {
    if ([self isEdited] && !self.task) {
        [self configureAlert];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)addButtonTapped {
    [self saveTask];
}

- (IBAction)mapButtonTapped:(UIButton *)sender {
    self.mapButton.selected = !self.mapButton.selected;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mapView.alpha = (self.mapButton.selected) ? 1.0 : 0.0f;
    }];
}

- (IBAction)groupButtonTapped:(UIButton *)sender {
    self.group = sender.tag;
}

#pragma mark - Private API

- (void)configureTextFieldPlaceholders {
    NSMutableDictionary *titleAttributes = [[NSMutableDictionary alloc] init];
    [titleAttributes setObject:[UIFont fontWithName:@"Avenir-Light" size:35.0]
                        forKey:NSFontAttributeName];
    [titleAttributes setObject:[UIColor whiteColor]
                        forKey:NSForegroundColorAttributeName];
    
    NSAttributedString *titlePlaceholder = [[NSAttributedString alloc] initWithString:self.titleTextField.placeholder
                                                                           attributes:titleAttributes];
    self.titleTextField.attributedPlaceholder = titlePlaceholder;
    
    NSMutableDictionary *descriptionAttributes = [[NSMutableDictionary alloc] init];
    [descriptionAttributes setObject:[UIFont fontWithName:@"Avenir-Book" size:14.0]
                        forKey:NSFontAttributeName];
    [descriptionAttributes setObject:kDescPlaceholderColor
                        forKey:NSForegroundColorAttributeName];
    
    NSAttributedString *descriptionPlaceholder = [[NSAttributedString alloc] initWithString:self.descriptionTextField.placeholder
                                                                           attributes:descriptionAttributes];
    self.descriptionTextField.attributedPlaceholder = descriptionPlaceholder;
}

- (void)configureAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save Task" message:@"Are you sure you want to go back without saving?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)isEdited {
    if (self.titleTextField.text.length > 0) {
        return YES;
    }
    
    return NO;
}

- (void)saveTask {
    if (self.titleTextField.text.length == 0) {
        [self presentErrorWithTitle:@"Validation" andError:@"Please add title"];
        return;
    }
    
    if (self.descriptionTextField.text.length == 0) {
        [self presentErrorWithTitle:@"Validation" andError:@"Please add short description"];
        return;
    }
    
    // If we have task object, we should perform update
    
    if (self.task) {
        self.task.heading = self.titleTextField.text;
        self.task.desc = self.descriptionTextField.text;
        self.task.group = [NSNumber numberWithInteger:self.group];
        [[DataManager sharedInstance] updateObject:self.task];
    } else {
        [[DataManager sharedInstance] saveTaskWithTitle:self.titleTextField.text
                                            description:self.descriptionTextField.text
                                                  group:self.group];
    }
    
    self.titleTextField.text = EMPTY_STRING;
    self.descriptionTextField.text = EMPTY_STRING;
    [self backButtonTapped];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName:CITY_CHANGED
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      self.cityLabel.text = [DataManager sharedInstance].userLocality;
                                                  }];
}

- (void)configureMap {
    
    //Hide map
    
    self.mapView.alpha = 0.0f;
    
    CLLocationCoordinate2D coordinate;
    
    //If task exists, adding pin to map
    
    if (self.task) {
        [self.mapView addAnnotation:self.task];
        
        coordinate = self.task.coordinate;
    } else {
        
        //If task doesn't exist, show user location
        
        self.mapView.showsUserLocation = YES;
        coordinate = [DataManager sharedInstance].userLocation.coordinate;
    }
    
    [self zoomMapToCoordinate:coordinate];
    
    if ([DataManager sharedInstance].userLocality.length > 0) {
        self.cityLabel.text = [DataManager sharedInstance].userLocality;
    }
}

- (void)fillData {
    self.titleTextField.text = self.task.heading;
    self.descriptionTextField.text = self.task.desc;
    self.group = [self.task.group integerValue];
    [self.mapView addAnnotation:self.task];
}

- (void)zoomMapToCoordinate:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, kRegionRadius * 2.0, kRegionRadius * 2.0);
    
    MKCoordinateRegion coordinateRegion = [self.mapView regionThatFits:region];
    [self.mapView setRegion:coordinateRegion animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTextFieldPlaceholders];
    [self registerForNotifications];
    [self configureMap];
    
    self.addButton.alpha = 0.0f;
    
    if (self.task) {
        [self fillData];
    } else {
        self.group = NOT_COMPLETED_TASK_GROUP;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [ UIView animateWithDuration:0.5 animations:^{
        self.addButton.alpha = 1.0;
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

@end
