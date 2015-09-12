//
//  ProfileViewController.h
//  DelightMatchApp
//
//  Created by Alex Cruz on 7/29/15.
//  Copyright (c) 2015 Felicia Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ProfileViewControllerDelegate <NSObject>

- (void)didPressLike;
- (void)didPressDislike;

@end


@interface ProfileViewController : UIViewController
@property (weak, nonatomic) id <ProfileViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *hometownLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutmeLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutMeDesc;
@property (strong, nonatomic) IBOutlet UILabel *interestLabel;
@property (strong, nonatomic) IBOutlet UILabel *interestDesc;
@property (strong, nonatomic) IBOutlet UILabel *mapOfInterestLabel;
@property (strong, nonatomic) IBOutlet UIImageView *interestImage;
@property (strong, nonatomic) IBOutlet UILabel *aboutMeImage;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@end
