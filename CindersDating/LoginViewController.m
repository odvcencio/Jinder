//
//  LoginViewController.m
//  DelightMatchApp
//
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


#define USER_PROFILE @"profile"
#define USER_ID @"id"
#define USER_NAME @"name"
#define USER_FIRST_NAME @"first_name"
#define USER_LOCATION @"location"
#define USER_GENDER @"gender"
#define USER_BIRTHDAY @"birthday"
#define USER_EMAIL @"email"
#define USER_INTERESTED_IN @"interested_in"
#define USER_RELATIONSHIP_STATUS @"relationship_status"

@interface LoginVC () //<NSURLConnectionDataDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *loginImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//object image buffer
//@property (strong, nonatomic) NSMutableData *imageData;

- (IBAction)loginButton:(UIButton *)sender;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.hidden = YES;
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self updateUserInformation];
    }
    
    NSLog(@" ");
    //this is different
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {

       // [self performSegueWithIdentifier:@"segueToProfile" sender:self];
    }



- (IBAction)loginButton:(UIButton *)sender {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_birthday", @"user_friends", @"user_likes"];
    
    //login pfuser
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error)
     {
         [self.activityIndicator stopAnimating];
         self.activityIndicator.hidden=YES;
         // PFUser *currentUser = [PFUser currentUser];
         if(!user) {
             NSLog(@"No user");
             if(!error) {
                 UIAlertView *alertView = [[UIAlertView alloc]
                                           initWithTitle:@"Log in error"message:@"The Facebook Login was Cancelled"delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                 [alertView show];
                 
             } else  {
                 
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error"message:[error description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                 [alertView show];
             }
             
         } else {
             
             NSLog(@"here");
             [self updateUserInformation];
            // [self performSegueWithIdentifier:@"segueToProfile" sender:self];
         }
         
     }];
    
}

#pragma mark - requesting and setting user data

- (void)updateUserInformation {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,first_name,email,gender,locale,birthday,picture" forKey:@"fields"];
    
    
    // if ([FBSDKAccessToken currentAccessToken]){
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"%@", result);
            NSDictionary *userDictionary = (NSDictionary *)result;
            
            //create URL
            NSString *facebookID = userDictionary[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            self.storeAddress   = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:15];
            
/*            if (userDictionary[USER_NAME]) {
                userProfile[kUserProfileNameKey] = userDictionary[USER_NAME];
            }
            if (userDictionary[USER_FIRST_NAME]) {
                userProfile[kUserProfileFirstNameKey] =userDictionary[USER_FIRST_NAME];
                
            }
            if (userDictionary[USER_LOCATION][USER_NAME]) {
                userProfile[kUserProfileLocationKey] = userDictionary[USER_LOCATION][USER_NAME];
            }
            if (userDictionary[USER_GENDER]) {
                userProfile[kUserProfileGenderKey] = userDictionary[USER_GENDER];
            }
            if (userDictionary[USER_BIRTHDAY]) {
                userProfile[kUserProfileBirthdayKey] = userDictionary[USER_BIRTHDAY];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterShortStyle];
                NSDate *date = [formatter dateFromString:userDictionary[USER_BIRTHDAY]];
                NSDate *now = [NSDate date];
                NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                int age = seconds / 31536000;
                userProfile[KUserProfileAgeKey] = @(age);
            }
            if (userDictionary[USER_EMAIL]) {
                userProfile[kUserProfileEmailKey] = userDictionary[USER_EMAIL];
            }
            if (userDictionary[USER_INTERESTED_IN]) {
                userProfile[kUserProfileInterestedInKey] = userDictionary[USER_INTERESTED_IN];
            }
            if (userDictionary[USER_RELATIONSHIP_STATUS]) {
                userProfile[KUserProfileRelationshipStatusKey] = userDictionary[USER_RELATIONSHIP_STATUS];
            }
            
            if ([pictureURL absoluteString]) {
                userProfile[KUserProfilePictureURLKey] = [pictureURL absoluteString];
            }
            
           
            [[PFUser currentUser] setObject:userProfile[@"gender"] forKey:@"gender"];
            [[PFUser currentUser] setObject:userProfile[@"first_name"] forKey:@"firstName"];
            
            
            [[PFUser currentUser] setObject:userProfile forKey:kUserProfileKey];
            [[PFUser currentUser] saveInBackground];
            //[self requestImage];
            
            NSString * storyboardName = @"Main";
            NSString * viewControllerID = @"InterestViewController";
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            InterestViewController * controller = (InterestViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
            [self presentViewController:controller animated:YES completion:nil];
        }*/
//        else {
//            NSLog(@"Error in FB request: %@", error);
        }
    }];
}
@end


