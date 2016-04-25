//
//  WalkthroughCollectionViewCell.m
//  ToDo
//
//  Created by Cubes School 6 on 4/25/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import "WalkthroughCollectionViewCell.h"

@implementation WalkthroughCollectionViewCell

- (void)setWalkthroughItem:(WalkthroughItem *)walkthroughItem {
    _walkthroughItem = walkthroughItem;
    
    self.textLabel.text = walkthroughItem.text;
    self.imageView.image = walkthroughItem.image;
}

@end
