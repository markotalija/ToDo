//
//  WalkthroughCollectionViewCell.h
//  ToDo
//
//  Created by Cubes School 6 on 4/25/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalkthroughItem.h"

@interface WalkthroughCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) WalkthroughItem *walkthroughItem;
@end
