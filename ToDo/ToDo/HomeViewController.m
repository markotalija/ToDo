//
//  HomeViewController.m
//  ToDo
//
//  Created by Cubes School 6 on 4/8/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import "HomeViewController.h"
#import "TaskTableViewCell.h"
#import "Constants.h"
#import "MenuView.h"
#import "TaskTableViewCell.h"
#import "Task.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MenuViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet MenuView *menuView;
@end

@implementation HomeViewController

#pragma mark - Properties

#pragma mark - Actions

#pragma mark - UITableViewDataSource

// Ove tri metode uvek definisem kada imam tabelu. Prva je broj sekcija, druga broj redova u sekciji, treca je izgled celije. UVEK!!!

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.taskTitleLabel.text = [NSString stringWithFormat:@"Red %ld", indexPath.row + 1];
    
    switch (indexPath.row) {
        case COMPLETED_TASK_GROUP:
            cell.taskGroupView.backgroundColor = kTurquoiseColor;
            break;
            
        case NOT_COMPLETED_TASK_GROUP:
            cell.taskGroupView.backgroundColor = kOrangeColor;
            break;
            
        case IN_PROGRESS_TASK_GROUP:
            cell.taskGroupView.backgroundColor = kPurpleColor;
            break;
            
        default:
            cell.taskGroupView.backgroundColor = kTurquoiseColor;
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

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

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:WALKTHROUGH_PRESENTED]) {
        [self performSegueWithIdentifier:@"WalkthroughSegue" sender:self];
        
    }
    
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
    
}

@end
