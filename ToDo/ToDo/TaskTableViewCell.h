//
//  TaskTableViewCell.h
//  ToDo
//
//  Created by Cubes School 6 on 4/15/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *taskGroupView;
@property (strong, nonatomic) Task *task;
@end
