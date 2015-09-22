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
    
    PFUser *userAtIndPath = self.profileUser;
    NSString *userAtIndPathName;
    NSString *userAtIndPathURL;
    
    userAtIndPathName = [userAtIndPath objectForKey:@"firstName"];
    userAtIndPathURL = [userAtIndPath objectForKey:@"picURL"];
    
   
    
    [self.imageHolder sd_setImageWithURL:[NSURL URLWithString:userAtIndPathURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             }];
    
    
    
    int age = [[userAtIndPath objectForKey:@"age"] intValue];
    NSString *strFromInt1 = [NSString stringWithFormat:@"%d", age];
    _ageLabel.text = strFromInt1;
    
    
    
    self.nameLabel.text = [NSString stringWithFormat:userAtIndPathName];
  }
}







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

- (IBAction)likeButton:(UIButton *)sender {
    
    PFUser *current = [PFUser currentUser];
    // Save here
    PFObject *likes = [PFObject objectWithClassName:@"UserLikes"];
    
    [likes setObject:current forKey:@"userID"];
    [likes setObject:self.profileUser forKey:@"userLiked"];
    
    [likes saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded){
            
        }else{
            NSLog(@"failed");
        }
    }];
    
    // Check for matches

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
        NSString *objectID = self.profileUser[@"objectId"];
    
        [dic setObject:objectID forKey:@"userID"];
    
        // cloud function
        [PFCloud callFunctionInBackground:@"match"
                           withParameters:dic
                                    block:^(NSString *total, NSError *error) {
                                        if (!error) {
                                            if ([total  isEqual:@"They fucking match"]) {
                                                NSString *what = @"Go to your inbox and say Hi";
                                                
                                                self.match.text = what;
                                            }
                
                                        }
                                    }];
  }

- (IBAction)dislikeButton:(UIButton *)sender {
    
    PFUser *selected = self.profileUser;
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
