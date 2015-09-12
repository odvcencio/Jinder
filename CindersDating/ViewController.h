//
//  ViewController.h
//  PageView
//
//  Created by Felicia Ferreira on 8/20/15.
//  Copyright (c) 2015 Felicia Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"
#import "LoginViewController.h"

@interface ViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkThrough:(UIButton *)sender;
- (IBAction)loginFaceBook:(UIButton *)sender;

//add property to hold the UIPageCVC, images and titles ok

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@end

