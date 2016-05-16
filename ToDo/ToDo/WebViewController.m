//
//  WebViewController.m
//  ToDo
//
//  Created by Cubes School 6 on 5/16/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@end

@implementation WebViewController

#pragma mark - Actions

- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private API

- (void)animateCloseButton {
    [UIView animateWithDuration:0.5 animations:^{
        self.closeButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.closeButton]];
        
        [self.animator addBehavior:gravityBehavior];
        
        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.closeButton]];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        [self.animator addBehavior:collisionBehavior];
        
        UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.closeButton]];
        elasticityBehavior.elasticity = 0.5;
        [self.animator addBehavior:elasticityBehavior];
        
    }];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.closeButton.alpha = 0.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self animateCloseButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end