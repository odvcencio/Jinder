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

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, assign) NSInteger oldSegmentedIndex;
@property (nonatomic, assign) NSInteger actualSegmentedIndex;

@end

@implementation SettingsViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleAgeDisplay];
}

-(void)viewDidAppear:(BOOL)animated{
}

-(void)handleAgeDisplay{
    
    PFUser *current = [PFUser currentUser];
    
    self.ageSlider.delegate = self;
    self.ageSlider.minValue = 18;
    self.ageSlider.maxValue = 60;
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:current.objectId block:^(PFObject *user, NSError *error) {
        int min = [[user objectForKey:@"minAge"] intValue];
        int max = [[user objectForKey:@"maxAge"] intValue];
        
        self.ageSlider.selectedMinimum = min;
        self.ageSlider.selectedMaximum = max;
        
    }];
    
    
    [self ageGetFromParse];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"_User"];
    [query1 getObjectInBackgroundWithId:current.objectId block:^(PFObject *user1, NSError *error) {
        
        BOOL showMeMen = [user1[@"showMeMen"] boolValue];
        BOOL showMeWomen = [user1[@"showMeWomen"] boolValue];
        BOOL showMeBoth = [user1[@"showMeBoth"] boolValue];
        
        
        
        if (showMeMen == TRUE) {
            self.actualSegmentedIndex = 0;
            _segmentedControl.selectedSegmentIndex = self.actualSegmentedIndex;
            
        } else if (showMeWomen == TRUE) {
            self.actualSegmentedIndex = 1;
            _segmentedControl.selectedSegmentIndex = self.actualSegmentedIndex;
            
        } else if (showMeBoth == TRUE) {
            self.actualSegmentedIndex = 2;
            _segmentedControl.selectedSegmentIndex = self.actualSegmentedIndex;
            
        }
    }];
}

-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum {
    if (sender == self.ageSlider){
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
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)ageGetFromParse{
   PFUser *current = [PFUser currentUser];
    
    if (current) {
         PFQuery *query = [PFQuery queryWithClassName:@"_User"];
         [query getObjectInBackgroundWithId:current.objectId block:^(PFObject *user, NSError *error) {
           int min = [[user objectForKey:@"minAge"] intValue];
           int max = [[user objectForKey:@"maxAge"] intValue];
             
             NSString *strFromInt1 = [NSString stringWithFormat:@"%d", min];
             NSString *strFromInt2 = [NSString stringWithFormat:@"%d", max];
             
             
             self.minLabel.text = strFromInt1;
             self.maxLabel.text = strFromInt2;
            
            
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
    
    self.oldSegmentedIndex = self.actualSegmentedIndex;
    self.actualSegmentedIndex = self.segmentedControl.selectedSegmentIndex;
    
}


// Log out

- (IBAction)logMeOut:(id)sender {
    [PFUser logOut];

    
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"LoginVC";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    LoginVC * controller = (LoginVC *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:YES completion:nil];
}

@end