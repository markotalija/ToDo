//
//  UIViewController+Utilities.h
//  ToDo
//
//  Created by Cubes School 6 on 5/20/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//  Kategorija koja moze da se koristi u svakoj aplikaciji, prosirenje bilo koje klase.

#import <UIKit/UIKit.h>

@interface UIViewController (Utilities)

- (void)presentErrorWithTitle:(NSString *)title andError:(NSString *)error;

@end
