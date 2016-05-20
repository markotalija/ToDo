//
//  MenuView.h
//  ToDo
//
//  Created by Cubes School 6 on 5/18/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MenuOption) {
    TASK_DETAILS_MENU_OPTION = 1,
    ABOUT_MENU_OPTION,
    STATISTICS_MENU_OPTION,
    WALKTHROUGH_MENU_OPTION
};

@protocol MenuViewDelegate <NSObject>
@required
- (void)menuViewOptionTapped:(MenuOption)option;
@end

@interface MenuView : UIView
@property (weak, nonatomic) IBOutlet id<MenuViewDelegate> delegate;
@end
