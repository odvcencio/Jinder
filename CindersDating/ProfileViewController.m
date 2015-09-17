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




@property PFUser *otherUser;

@property (weak, nonatomic) IBOutlet UIImageView *imageHolder;

// @property (strong, nonatomic) UIImageView *imageHolder;
//
@property (strong, nonatomic) NSDictionary *dict;

// @property(strong, nonatomic) NSString *saveIdHere;

@end

@implementation ProfileViewController

#pragma mark IB Action methods

//back button

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem =
[[UIBarButtonItem alloc] initWithTitle:@"Back"
style:UIBarButtonItemStyleDone
target:self
action:@selector(handleBack:)];

   // PFQuery *query = [PFUser query];

    NSObject *profileViewController;
    NSLog(@"%@", profileViewController);
    

if (self.profileUser) {
    
    
    PFObject *userAtIndPath = self.profileUser;
    
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
    
    PFUser *current = [PFUser currentUser];
  //  self.objectId = query;
 //       NSString *theActualId = self.objectId.get("objectId");
  //  NSArray *profileSelected = [query findObjects];
    
  //   PFQuery *user = [PFUser query];
//    [query getUserObjectWithId:@"HL7SrF7OwK"];
//     self.theActualId = query[@"objectId"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
        
        
        [dic setObject:_otherUser.objectId forKey:@"userID"];
    
        
        NSLog(@"the obj: %@", dic);
    
    
        
        [PFCloud callFunctionInBackground:@"match"
                           withParameters:dic     //   @{@"userIDD": @"HL7SrF70wK"}
                                    block:^(NSString *total, NSError *error) {
                                        if (!error) {
                                            // ratings is 4.5
                                            NSLog(@"is it object: %@", total);
                                            // avgPoint = object;
                                        }
                                    }];
        PFObject *likes = [PFObject objectWithClassName:@"UserLikes"];
    
        [likes setObject:current forKey:@"userID"];
        [likes setObject:_otherUser forKey:@"userLiked"];
    
    
        [likes saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if(succeeded){
    
            }else{
                NSLog(@"failed");
            }
        }];
    
    
    
    
 //   [user getObjectInBackgroundWithId:@"HL7SrF70wK"];
    
  //  [user whereKey:@"objectId" equalTo:@"HL7SrF7OwK"];
    
//    NSString *objectid = [self.objectId];
    
//    NSLog(@"The object id is: %@", objectid);
    
 //   NSString *objectId = user;
    
   //  NSString *objectID = users;
   //    self.senderId = user.objectId;
    
  //     self.oId = user.objectId;
    
      // self.theActualId = results[0].objectId;
    

    
    
    
    
//    [query getObjectInBackgroundWithId:@"HL7SrF7OwK" block:^(PFObject *user, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
//         NSString *objectId = user.objectId;
//        NSLog(@"Your user: %@", user);
//        NSLog(@"Your: %@", objectId);
        
 
    
    
        
 
        
        
//    }];
    
//    NSString *objectIds = *objectIds;
//    NSLog(@"Your obj id: %@", objectIds);
    
   }
    
    
//    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
//    //NSString *playerName = User[@"playerName"];
//    
//    NSString *objectId = _user.objectId;
//    
//    [query getObjectInBackgroundWithId:@"HL7SrF7OwK"];
    
  // PFObject *profileID = [otherUser valueForKey:@"HL7SrF7OwK"];
    

  // PFUser *user = @"HL7SrF7OwK";
   // NSString *objectId = object.objectId;
//    NSString *objectId = [myObject HL7SrF7OwK];
    
//    PFUser *currentUser = [PFUser currentUser];
    
    

    
//    [PFCloud callFunctionInBackground:@"match"
//                       withParameters:@{@"userID": @""}
//                                block:^(NSObject *object, NSError *error) {
//                                    if (!error) {
//                                        // ratings is 4.5
//                                        NSLog(@"is it object: %@", object);
//                                        // avgPoint = object;
//                                    }
//                                }];
    
    
    


/*- (IBAction)cloudlikeButton:(UIButton *)sender {

//    [PFCloud callFunctionInBackground:@"hello"
//                   withParameters:@{@"iLike": @"u1mFAQysC2"}
//     
//                            block:^(NSArray *iLike, NSError *error) {
//                                if (!error) {
//                                    // ratings is 4.5
//                                    NSArray *check = iLike;
//                                    NSLog(@"is it check: %@", check);
//                              }
//                           }];
    
    [PFCloud callFunctionInBackground:@"hello"
                       withParameters:@{@"objectID": @"u1mFAQysC2"}
     
                                block:^(id object, NSError *error) {
                                    if (!error) {
                                        // ratings is 4.5
                                        NSLog(@"is it object: %@", object);
                                       // avgPoint = object;
                                    }
                                }];
}
*/
/*
- (IBAction)likeButton:(UIButton *)sender {
 //   [self.delegate didPressLike];
 
    PFObject *likeActivity = [PFObject objectWithClassName:kActivityClassKey];
    [likeActivity setObject:kActivityTypeLikeKey forKey:kActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    }];

    
    
    
//    PFQuery *queryForLike = [PFQuery queryWithClassName:kActivityClassKey];
//    [queryForLike whereKey:kActivityTypeKey equalTo:kActivityTypeLikeKey];
//    [queryForLike whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
    
    
    
    
    
    
    
    
    PFQuery *userLikes = [PFQuery queryWithClassName:@"UserLikes"];
    
    [[PFUser currentUser] setObject:@"likes" forKey:@"iLike"];
    
    [userLikes setValue:[PFUser currentUser] forKey:@"userID"];
    
  //  [userLikes setObject:[PFUser currentUser] forKey:@"userID"];
    
    [userLikes whereKey:@"iLike" containedIn:<#(NSArray * __nonnull)#>]
    
    [userLikes whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
    
    
    
    
    
    
    
    
    
    
    
}
  */






- (IBAction)dislikeButton:(UIButton *)sender {
    [self.delegate didPressDislike];
    /*
    PFQuery *queryForDislike = [PFQuery queryWithClassName:kActivityClassKey];
    [queryForDislike whereKey:kActivityTypeKey equalTo:kActivityTypeDislikeKey];
    [queryForDislike whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];}
*/
}
@end
