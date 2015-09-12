//
//  PageContentViewController.h
//  PageView
//
//  Created by Felicia Ferreira on 8/20/15.
//  Copyright (c) 2015 Felicia Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

//stores the current page index or number yeah but
@property NSUInteger pageIndex;

//vc display an image and a tile
@property NSString *titleText;
@property NSString *imageFile;

@end
