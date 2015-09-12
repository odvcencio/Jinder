//
//  EditProfile.h
//  DelightMatchApp
//
//

#import <UIKit/UIKit.h>

@interface EditProfile : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *editProfileImageView;
@property (strong, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (strong, nonatomic) IBOutlet UILabel *interestsLabel;
@property (strong, nonatomic) IBOutlet UILabel *interestsDesc;
@property (strong, nonatomic) IBOutlet UITextView *editAboutMeTextView;
@property (strong, nonatomic) IBOutlet UITextView *editAboutMeImage;
@property (strong, nonatomic) IBOutlet UIImageView *editinterestsImage;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;
- (IBAction)doneButton:(UIBarButtonItem *)sender;

@end
