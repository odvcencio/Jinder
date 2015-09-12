//
//  ProfileViewController.m
//  DelightMatchApp
//
//  Created by Alex Cruz on 7/29/15.
//  Copyright (c) 2015 Felicia Ferreira. All rights reserved.
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

@interface ProfileViewController ()

@property PFUser *otherUser;

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


#pragma mark Map Interest IB Action to segue to Yelp Map VC

//mapinterest segue
- (IBAction)mapInterestButton:(UIButton *)sender {
  
    NSString * storyboardName = @"StoryboardProfile";
NSString * viewControllerID = @"YelpkMap";
UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//YelpMapViewController * controller = (YelpMapViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
  
//controller.bestFoods = @"asian";//self.popfood.text;
//controller.best_in_miles = self.hometownLabel.text;
    
 // self.view.window.rootViewController = controller;
    
//[controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];

//    [self presentViewController:controller animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem =
[[UIBarButtonItem alloc] initWithTitle:@"Back"
style:UIBarButtonItemStyleDone
target:self
action:@selector(handleBack:)];

   // PFQuery *query = [PFUser query];


    
    //getting the image from Parse/FaceBook
    
    PFQuery *query = [PFUser query];
    

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     
    {
        if ([objects count]>0) {
             
             _otherUser = objects[8];
//           PFUser *oUser = objects[7];

            
           // _otherUser = user;
            
          //  NSLog(@"%@",[user objectForKey:@"picURL"]);
          //  NSLog(@"%@",[user objectForKey:@"picURL"]);
          //  NSLog(@"%@",[user["picURL"]);
           // NSString *picURL = [user objectForKey:@"picURL"];
            NSString *picURL = @"https://sp.yimg.com/ib/th?id=JN.031gjiPzsFUwYlGCRGrVSQ&pid=15.1&P=0";
            
//            [self.profilePictureImageView sd_setImageWithURL:[NSURL URLWithString: picURL] placeholderImage:[UIImage imageNamed: @"placeholder.png"]];
            
            //self.hometownLabel.text = [NSString stringWithFormat:@"%@",user[kUserProfileKey][kUserProfileLocationKey]];
            self.hometownLabel.text = [NSString stringWithFormat:@"Few minutes away, Active User"];
            self.ageLabel.text = [NSString stringWithFormat:@"23"];
            self.aboutMeDesc.text =[NSString stringWithFormat:@"Nursing Student, Love the beach and cats!"];
            self.nameLabel.text= [NSString stringWithFormat:@"Ashley"];
            
            //  self.ageLabel.text = [NSString stringWithFormat:@"%@",user[kUserProfileKey][KUserProfileAgeKey]];
           // self.aboutMeDesc.text =[NSString stringWithFormat:@"%@", user[kUserTagLineKey]];
           // self.nameLabel.text= [NSString stringWithFormat:@"%@",user[kUserProfileKey][kUserProfileFirstNameKey]];
          
            
         } else NSLog(@"error in pictureURL getting the image data: %@", error);
    }];
    
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
