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
        //segues to settings
        NSString * storyboardName = @"StoryboardSettings";
        NSString * viewControllerID = @"SettingsViewController";
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
        DelightNewsFeedViewController * controller = (DelightNewsFeedViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
        [self presentViewController:controller animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)userLinkFacebookCheck{
    PFUser *current = [PFUser currentUser];
    
    if ([PFFacebookUtils isLinkedWithUser:current]) {
        [self updateUserInformation];
        [self segueToMatchFeed];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [self userLinkFacebookCheck];
    [self updateUserInformation];
    }



- (IBAction)loginButton:(UIButton *)sender {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_birthday", @"user_friends"];
    
    //login pfuser
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error)
     {
         //hide activity indicator
         [self.activityIndicator stopAnimating];
         self.activityIndicator.hidden=YES;
         
         //check for facebook user
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
             
         } else if (user) {
             //login new user for the first time
             NSLog(@"here");
             [self updateUserInformation];
             [self segueToMatchFeed];
             
         }
         
     }];
    
}

#pragma mark - requesting and setting user data

- (void)updateUserInformation {
    
    //parameters dictionary
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,first_name,email,gender,birthday" forKey:@"fields"];
    
    //current user set
    PFUser *thisUser = [PFUser currentUser];

    //graph request to facebook to retrieve the parameters specified above
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters];
    //method call
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            //blank dictionary to hold variables from request
            NSDictionary *userDictionary = (NSDictionary *)result;
            
            //create URL
            NSString *facebookID = userDictionary[@"id"];
            
            self.storeAddress   = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            //keep facebook URL
            [thisUser setObject:self.storeAddress forKey:@"picURL"];
            
            //profile dictionary that we keep to pass through
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] init];
            
            //save name
            if (userDictionary[@"first_name"]) {
                userProfile[@"first_name"] =userDictionary[@"first_name"];
                [thisUser setObject:userProfile[@"first_name"] forKey:@"firstName"];
                
            }
            //save gender
            if (userDictionary[@"gender"]) {
                userProfile[@"gender"] = userDictionary[@"gender"];
                [thisUser setObject:userProfile[@"gender"] forKey:@"gender"];
            }
            //save birthday and calculate age
           if (userDictionary[@"birthday"]) {
                userProfile[@"birthday"] = userDictionary[@"birthday"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterShortStyle];
                NSDate *date = [formatter dateFromString:userDictionary[@"birthday"]];
                NSDate *now = [NSDate date];
                NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                int age = seconds / 31536000;
                userProfile[@"age"] = @(age);
               [thisUser setObject:userProfile[@"age"] forKey:@"age"];
            }
            //save email
            if (userDictionary[@"email"]) {
                userProfile[@"email"] = userDictionary[@"email"];
                [thisUser setObject:userProfile[@"email"] forKey:@"email"];
            }

            //save to parse
            [thisUser saveInBackground];
        }
        else {
            NSLog(@"Error in FB request: %@", error);
            }
        }];
    }

@end


