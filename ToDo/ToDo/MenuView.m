//
//  MenuView.m
//  ToDo
//
//  Created by Cubes School 6 on 5/18/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import "MenuView.h"

#define kButtonSize         30.0
#define kAnimationDuration  0.3
#define kOriginX            128.0

@interface MenuView()
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (nonatomic) BOOL menuOpened;
@end

@implementation MenuView

#pragma mark - Designated Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadViewFromNib];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self loadViewFromNib];
    }
    
    return self;
}

#pragma mark - Actions

- (IBAction)menuButtonTapped {
    if (self.menuOpened) {
        [self closeMenu];
    } else {
        [self openMenu];
    }
}

- (IBAction)menuOptionButtonTapped:(UIButton *)sender {
    [self closeMenu];
    
    //Delegate safety
    if ([self.delegate respondsToSelector:@selector(menuViewOptionTapped:)]) {
        [self.delegate menuViewOptionTapped:sender.tag];
    }
}

#pragma mark - Private API

- (void)loadViewFromNib {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    view.frame = self.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:view];
}

- (void)prepareMenu {
    self.label1.alpha = 0.0f;
    self.label2.alpha = 0.0f;
    self.label3.alpha = 0.0f;
    self.label4.alpha = 0.0f;
    
    [self configureButton:self.button1];
    [self configureButton:self.button2];
    [self configureButton:self.button3];
    [self configureButton:self.button4];
    
    //self.menuButton.layer.cornerRadius = self.menuButton.frame.size.width/2;
}

- (void)closeMenu {
    self.menuOpened = NO;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.button4.center = self.menuButton.center;
        self.button4.alpha = 1.0;
        self.label4.alpha = 0.0f;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.button3.center = self.menuButton.center;
            self.button3.alpha = 1.0;
            self.label3.alpha = 0.0f;
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.button2.center = self.menuButton.center;
            self.button2.alpha = 1.0;
            self.label2.alpha = 0.0f;
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.button1.center = self.menuButton.center;
            self.button1.alpha = 1.0;
            self.label1.alpha = 0.0f;
        }];
    });
}

- (void)openMenu {
    self.menuOpened = YES;
    
    self.button1.alpha = 1.0;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.button1.frame = CGRectMake(kOriginX, 22, kButtonSize, kButtonSize);
        self.button1.alpha = 1.0;
        self.label1.alpha = 1.0;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.button2.frame = CGRectMake(kOriginX, 60, kButtonSize, kButtonSize);
            self.button2.alpha = 1.0;
            self.label2.alpha = 1.0;
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.button3.frame = CGRectMake(kOriginX, 98, kButtonSize, kButtonSize);
            self.button3.alpha = 1.0;
            self.label3.alpha = 1.0;
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.button4.frame = CGRectMake(kOriginX, 136, kButtonSize, kButtonSize);
            self.button4.alpha = 1.0;
            self.label4.alpha = 1.0;
        }];
    });
}

- (void)configureButton:(UIButton *)button {
    button.alpha = 0.0f;
    button.center = self.menuButton.center;
    
    button.layer.cornerRadius = button.frame.size.width/2;
    
    button.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    button.layer.shadowOpacity = 1.0;
    button.layer.shadowOffset = CGSizeMake(0.05, 0.1);
}

#pragma mark - View lifecycle

- (void)layoutSubviews {
    [self prepareMenu];
}

@end
