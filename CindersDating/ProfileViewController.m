//
//  ProfileViewController.m
//  DelightMatchApp
//
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import "DelightMatchApp/SDWebImage/UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "DelightNewsFeedViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageHolder;
@property (strong, nonatomic) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UILabel *match;

@end

@implementation ProfileViewController

#pragma mark IB Action methods

//back button

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    

if (self.profileUser) {
    
    
 //   PFObject *userAtIndPath = self.profileUser;
    
    PFUser *userAtIndPath = self.profileUser;
    
 //   self.profileUser = userAtIndPath.objectId;
    
    NSString *userAtIndPathName;
    NSString *userAtIndPathURL;
    
    userAtIndPathName = [userAtIndPath objectForKey:@"firstName"];
    userAtIndPathURL = [userAtIndPath objectForKey:@"picURL"];
    
   
    
    [self.imageHolder sd_setImageWithURL:[NSURL URLWithString:userAtIndPathURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 //
                             }];
    
    
    
    int age = [[userAtIndPath objectForKey:@"age"] intValue];
    NSString *strFromInt1 = [NSString stringWithFormat:@"%d", age];
    _ageLabel.text = strFromInt1;
    
    
    
    self.nameLabel.text = [NSString stringWithFormat:userAtIndPathName];
            

    
  }  // if statement
    
}  // viewdidload







#pragma mark Segue Back to New Feeds VC

-(void)handleBack:(id)sender{
NSString * storyboardName = @"StoryboardProfile";
NSString * viewControllerID = @"DelightNewsFeedViewController";
UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];

DelightNewsFeedViewController * controller = (DelightNewsFeedViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
[self presentViewController:controller animated:YES completion:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - Parse Data

// Display user Picture (up to 5) age, name, about.

#pragma mark- IB Actions 

//u1mFAQysC2

- (IBAction)likeButton:(UIButton *)sender {
    

    
    PFObject *selected = self.profileUser;
    PFUser *current = [PFUser currentUser];
    

    
    // Save here
    PFObject *likes = [PFObject objectWithClassName:@"UserLikes"];
    
    [likes setObject:current forKey:@"userID"];
    [likes setObject:selected forKey:@"userLiked"];
    
    
    [likes saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded){
            
        }else{
            NSLog(@"failed");
        }
    }];
    
    
    
    // Check for matches

      NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    
    
        [dic setObject:selected.objectId forKey:@"userID"];
    
        NSLog(@"the obj: %@", dic);
    
    
        // cloud function
        [PFCloud callFunctionInBackground:@"match"
                           withParameters:dic     //   @{@"userIDD": @"HL7SrF70wK"}
                                    block:^(NSString *total, NSError *error) {
                                        if (!error) {
                                            // ratings is 4.5
                                            if ([total  isEqual:@"They fucking match"]) {
                                              //  NSLog(@"is it object: %@", total);
                                                
                                                NSString *what = @"Go to your inbox and say Hi";
                                                
                                                self.match.text = what;
                                                
                                                
                                            }
                
                                        }
                                    }];
  }

- (IBAction)dislikeButton:(UIButton *)sender {
    
    PFObject *selected = self.profileUser;
    PFUser *current = [PFUser currentUser];
    
    // Save here
    PFObject *Dislike = [PFObject objectWithClassName:@"UserDisLikes"];
    
    [Dislike setObject:current forKey:@"userID"];
    [Dislike setObject:selected forKey:@"disLikedUserID"];
    
    [Dislike saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded){
            
        }else{
            NSLog(@"failed");
        }
    }];

}
 

@end
