//
//  ProfileViewController.h
//  DelightMatchApp
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@protocol ProfileViewControllerDelegate <NSObject>

- (void)didPressLike;
- (void)didPressDislike;

@end

// @class DelightNewsFeedViewController;

@interface ProfileViewController : UIViewController

// Store Obj coming from Matchfeed
@property (strong, nonatomic) PFObject *profileUser;

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
