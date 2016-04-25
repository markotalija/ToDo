//
//  WalkthroughItem.m
//  ToDo
//
//  Created by Cubes School 6 on 4/25/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import "WalkthroughItem.h"

@implementation WalkthroughItem

- (instancetype)initWithText:(NSString *)text andImage:(UIImage *)image {
    if (self = [super init]) {
        self.text = text;
        self.image = image;
    }
    
    return self;
}

@end
