//
//  LoginViewController.m
//  DelightMatchApp
//
//

#import "LoginViewController.h"
#import "DelightNewsFeedViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


#define USER_PROFILE @"profile"

#define USER_LOCATION @"location"

#define USER_BIRTHDAY @"birthday"
#define USER_EMAIL @"email"
#define USER_INTERESTED_IN @"interested_in"
#define USER_RELATIONSHIP_STATUS @"relationship_status"

@interface LoginVC () 


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
    
    
    
    
    //this is different
    
}

-(void) segueToMatchFeed{
    NSString * storyboardName = @"StoryboardNewsFeed";
    NSString * viewControllerID = @"DelightNewsFeedViewController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    DelightNewsFeedViewController * controller = (DelightNewsFeedViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self updateUserInformation];
        [self segueToMatchFeed];
        
    }
       // [self performSegueWithIdentifier:@"segueToProfile" sender:self];
    }



- (IBAction)loginButton:(UIButton *)sender {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_birthday", @"user_friends", @"user_likes"];
    
    //login pfuser
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error)
     {
         //user = [PFUser currentUser];
         [self.activityIndicator stopAnimating];
         self.activityIndicator.hidden=YES;
         
         
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
             [self segueToMatchFeed];
            // [self performSegueWithIdentifier:@"segueToProfile" sender:self];
         }
         
     }];
    
}

#pragma mark - requesting and setting user data

- (void)updateUserInformation {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,first_name,email,gender,birthday" forKey:@"fields"];
    PFUser *thisUser = [PFUser currentUser];
    
//    if ([FBSDKAccessToken currentAccessToken]){
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            NSDictionary *userDictionary = (NSDictionary *)result;
            
            //create URL
            NSString *facebookID = userDictionary[@"id"];
            
            self.storeAddress   = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] init];
            

            if (userDictionary[@"first_name"]) {
                userProfile[@"first_name"] =userDictionary[@"first_name"];
                
            }

            if (userDictionary[@"gender"]) {
                userProfile[@"gender"] = userDictionary[@"gender"];
            }
           if (userDictionary[@"birthday"]) {
                userProfile[@"birthday"] = userDictionary[@"birthday"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterShortStyle];
                NSDate *date = [formatter dateFromString:userDictionary[@"birthday"]];
                NSDate *now = [NSDate date];
                NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                int age = seconds / 31536000;
                userProfile[@"age"] = @(age);
            }
            if (userDictionary[@"email"]) {
                userProfile[@"email"] = userDictionary[@"email"];
            }
/*            if (userDictionary[USER_INTERESTED_IN]) {
                userProfile[kUserProfileInterestedInKey] = userDictionary[USER_INTERESTED_IN];
            }
            if (userDictionary[USER_RELATIONSHIP_STATUS]) {
                userProfile[KUserProfileRelationshipStatusKey] = userDictionary[USER_RELATIONSHIP_STATUS];
            }
 */
            
            [thisUser setObject:self.storeAddress forKey:@"picURL"];
            [thisUser setObject:userProfile[@"gender"] forKey:@"gender"];
            [thisUser setObject:userProfile[@"first_name"] forKey:@"firstName"];
            [thisUser setObject:userProfile[@"age"] forKey:@"age"];
            [thisUser setObject:userProfile[@"email"] forKey:@"email"];
            
            NSLog(@"%@", thisUser);
            
            [thisUser saveInBackground];
            //[self requestImage];
            
        }
        else {
            NSLog(@"Error in FB request: %@", error);
            }
        }];
    }

@end


