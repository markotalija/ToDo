//
//  HomeViewController.m
//  ToDo
//
//  Created by Cubes School 6 on 4/8/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import "HomeViewController.h"
#import "TaskTableViewCell.h"
#import "MenuView.h"
#import "Task.h"
#import "DataManager.h"
#import "TaskDetailsViewController.h"
#import "WalkthroughViewController.h"
#import "WebViewController.h"
#import "Helpers.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MenuViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet MenuView *menuView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic)  NSMutableArray *itemsArray;
@property (strong, nonatomic) Task *selectedTask;
@end

@implementation HomeViewController

#pragma mark - Properties

- (NSMutableArray *)itemsArray {
    _itemsArray = [[DataManager sharedInstance] fetchEntity:NSStringFromClass([Task class])
                                                 withFilter:nil
                                                withSortAsc:YES
                                                     forKey:@"date"];
    
    return _itemsArray;
}

#pragma mark - UITableViewDataSource

// Ove tri metode uvek definisem kada imam tabelu. Prva je broj sekcija, druga broj redova u sekciji, treca je izgled celije. UVEK!!!

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    //Task *task = [self.itemsArray objectAtIndex:indexPath.row];
    //cell.task = task;
    
    cell.task = self.itemsArray[indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Task *task = [self.itemsArray objectAtIndex:indexPath.row];
        [[DataManager sharedInstance] deleteObjectInDatabase:task];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self refreshData];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Task *task = [self.itemsArray objectAtIndex:indexPath.row];
    self.selectedTask = task;
    [self performSegueWithIdentifier:@"TaskDetailsSegue" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - UIImagePickerController

- (void)pickImage {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose source:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }]];
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Private API

- (void)configureBadge {
    self.badgeImageView.alpha = (self.itemsArray.count == 0) ? 0.0f : 1.0;
    self.badgeLabel.alpha = (self.itemsArray.count == 0) ? 0.0f : 1.0;
    self.badgeLabel.text = [NSString stringWithFormat:@"%ld", self.itemsArray.count];
}

- (void)configureWelcomeLabel {
    if ([Helpers isMorning]) {
        self.welcomeLabel.text = @"Good Morning!";
    } else {
        self.welcomeLabel.text = @"Good Afternoon!";
    }
}

- (void)refreshData {
    [self.tableView reloadData];
    [self configureBadge];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureWelcomeLabel];
    
    self.userProfileImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickImage)];
    
    tap.numberOfTapsRequired = 1;
    
    self.userProfileImageView.clipsToBounds = YES;
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.width / 2;
    [self.userProfileImageView addGestureRecognizer:tap];
    
    //If NSUserDefaults exists, set NSData back to UIImage
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_IMAGE]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_IMAGE];
        
        //Setting image from *data
        self.userProfileImageView.image = [[UIImage alloc] initWithData:data];
        
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:WALKTHROUGH_PRESENTED]) {
        [self performSegueWithIdentifier:@"WalkthroughSegue" sender:self];
        
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    self.userProfileImageView.image = image;
    
    //Converting image to NSData
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:USER_IMAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MenuViewDelegate

- (void)menuViewOptionTapped:(MenuOption)option {
    switch (option) {
        case TASK_DETAILS_MENU_OPTION: {
            self.selectedTask = nil;
            [self performSegueWithIdentifier:@"TaskDetailsSegue" sender:nil];
        }  break;
            
        case ABOUT_MENU_OPTION: {
            [self performSegueWithIdentifier:@"AboutSegue" sender:nil];
        } break;
            
        case STATISTICS_MENU_OPTION: {
            [self performSegueWithIdentifier:@"StatisticsSegue" sender:nil];
        } break;
            
        case WALKTHROUGH_MENU_OPTION: {
            [self performSegueWithIdentifier:@"WalkthroughSegue" sender:nil];
        } break;
            
        default:
            break;
    }
}

#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AboutSegue"]) {
        WebViewController *webViewController = (WebViewController *)segue.destinationViewController;
        webViewController.urlString = CUBES_URL;
    }
    
    if ([segue.identifier isEqualToString:@"TaskDetailsSegue"]) {
        TaskDetailsViewController *taskDetailsViewController = (TaskDetailsViewController *)segue.destinationViewController;
        taskDetailsViewController.task = self.selectedTask;
    }
}

@end
