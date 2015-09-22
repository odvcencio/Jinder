//
//  EditProfile.m
//  DelightMatchApp
//

#import "EditProfile.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>



@interface EditProfile ()<UITextViewDelegate>
@end

@implementation EditProfile


//currently this view does nothing, eventually will hold 'edit profile'

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.editAboutMeTextView.delegate = self;
    
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            PFObject *user = objects[2];
             NSString *picURL = [user objectForKey:@"picURL"];
        } else NSLog(@"error getting the image from data in EditProfile: %@", error);
            }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.editAboutMeTextView resignFirstResponder];
        [[PFUser currentUser] saveInBackground];
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    else return YES;
}




- (IBAction)cancelButton:(UIBarButtonItem *)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
