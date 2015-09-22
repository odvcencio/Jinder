//
//  SettingsViewController.m
//  DelightMatchApp
//
#import <Parse/Parse.h>
#import "SettingsViewController.h"
#import "DelightNewsFeedViewController.h"
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LoginViewController.h"


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet TTRangeSlider *ageSlider;
@property (strong, nonatomic) NSNumber *minAge;
@property (strong, nonatomic) NSNumber *maxAge;

@property (nonatomic) NSNumber *selectedMinimum;
@property (nonatomic) NSNumber *selectedMaximum;

@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;


// segemted
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, assign) NSInteger oldSegmentedIndex;
@property (nonatomic, assign) NSInteger actualSegmentedIndex;

@end

@implementation SettingsViewController

//-------------------------------------------------------------Segue

- (IBAction)selectSettings:(id)sender {
    NSString * storyboardName = @"StoryboardNewsFeed";
    NSString * viewControllerID = @"NavBar";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    DelightNewsFeedViewController * controller = (DelightNewsFeedViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (IBAction)selectSettingsBack:(id)sender {
    NSString * storyboardName = @"StoryboardNewsFeed";
    NSString * viewControllerID = @"NavBar";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    DelightNewsFeedViewController * controller = (DelightNewsFeedViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:YES completion:nil];
    
}

//-------------------------------------------------------------End Segue

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    PFUser *current = [PFUser currentUser];
    
    self.ageSlider.delegate = self;
    self.ageSlider.minValue = 18;
    self.ageSlider.maxValue = 60;
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:current.objectId block:^(PFObject *user, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        int min = [[user objectForKey:@"minAge"] intValue];
        int max = [[user objectForKey:@"maxAge"] intValue];
    
    self.ageSlider.selectedMinimum = min;
    self.ageSlider.selectedMaximum = max;
        
    }];  // End of age range
    
 
   [self ageGetFromParse]; // Big numbers
    
    //-------------------------------------------------------------Split
    
    // segemted
    PFQuery *query1 = [PFQuery queryWithClassName:@"_User"];
    [query1 getObjectInBackgroundWithId:current.objectId block:^(PFObject *user1, NSError *error) {
    
    BOOL showMeMen = [user1[@"showMeMen"] boolValue];
    BOOL showMeWomen = [user1[@"showMeWomen"] boolValue];
    BOOL showMeBoth = [user1[@"showMeBoth"] boolValue];
        
        
        
        if (showMeMen == TRUE) {
            
      //      UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
         //   NSInteger selectedSegment0 = 0;
            self.actualSegmentedIndex = 0;
            _segmentedControl.selectedSegmentIndex = self.actualSegmentedIndex;
            
        } else if (showMeWomen == TRUE) {
            
            self.actualSegmentedIndex = 1;
            
            _segmentedControl.selectedSegmentIndex = self.actualSegmentedIndex;
            
        } else if (showMeBoth == TRUE) {
            
            self.actualSegmentedIndex = 2;
            _segmentedControl.selectedSegmentIndex = self.actualSegmentedIndex;

        }
    
//    self.oldSegmentedIndex = -1;
//    self.actualSegmentedIndex = self.segmentedControl.selectedSegmentIndex;
  //  self.actualSegmentedIndex = self.segmentedControl.selectedSegmentIndex;
    }];


}


-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum {
    if (sender == self.ageSlider){
        NSLog(@"Standard slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
       _minAge = [NSNumber numberWithInt: selectedMinimum];
       _maxAge = [NSNumber numberWithInt: selectedMaximum];
        [self ageSetToParse];
        
    }
    
}

-(void)ageSetToParse{
    PFUser *current = [PFUser currentUser];
    
    [current setObject:_minAge forKey:@"minAge"];
    [current setObject:_maxAge forKey:@"maxAge"];
    
    [current saveInBackground];
    
}


-(void)ageGetFromParse{
   PFUser *current = [PFUser currentUser];
    
    if (current) {
        // do stuff with the user
         PFQuery *query = [PFQuery queryWithClassName:@"_User"];
         [query getObjectInBackgroundWithId:current.objectId block:^(PFObject *user, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
           int min = [[user objectForKey:@"minAge"] intValue];
           int max = [[user objectForKey:@"maxAge"] intValue];
             
             NSString *strFromInt1 = [NSString stringWithFormat:@"%d", min];
             NSString *strFromInt2 = [NSString stringWithFormat:@"%d", max];
             
             
             self.minLabel.text = strFromInt1;
             self.maxLabel.text = strFromInt2;
            
            
            NSLog(@"%@", user);
            
            NSLog(@"%@", strFromInt1);
            NSLog(@"%@", strFromInt2);
            
        }];
    } else {
        // show the signup or login screen
    }
    
    

    
}



- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    
    if (selectedSegment == 0) {
        // Save currentUser likes men to Parse
    
        PFUser *user = [PFUser currentUser];
        
        user[@"showMeMen"] = @YES;
        user[@"showMeWomen"] = @NO;
        user[@"showMeBoth"] = @NO;
        
        [user saveInBackground];

    }
    
    if (selectedSegment == 1) {
        // Save currentUser likes women to Parse
        PFUser *user = [PFUser currentUser];
        
        user[@"showMeWomen"] = @YES;
        user[@"showMeMen"] = @NO;
        user[@"showMeBoth"] = @NO;
        
        [user saveInBackground];
        
    }
    
    if (selectedSegment == 2) {
        // Save currentUser likes both to Parse
        PFUser *user = [PFUser currentUser];
        
        user[@"showMeBoth"] = @YES;
        user[@"showMeMen"] = @NO;
        user[@"showMeWomen"] = @NO;
        
        [user saveInBackground];
        
    }
    
    
    // segmented
    self.oldSegmentedIndex = self.actualSegmentedIndex;
    self.actualSegmentedIndex = self.segmentedControl.selectedSegmentIndex;
    
}


// Log out

- (IBAction)logMeOut:(id)sender {
    
  //  [[PFSession activeSession] closeWithCompletionHandler:true];
    [PFUser logOut];
   // PFUser *currentUser = [PFUser currentUser];
    
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"LoginVC";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    LoginVC * controller = (LoginVC *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:YES completion:nil];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Parse Data

// Look at rough draft


#pragma mark - Helper Function










@end
