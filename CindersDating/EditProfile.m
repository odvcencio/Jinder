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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.editAboutMeTextView.delegate = self;
    
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            PFObject *user = objects[2];
             NSString *picURL = [user objectForKey:@"picURL"];
//            [self.editProfileImageView sd_setImageWithURL:[NSURL URLWithString: picURL] placeholderImage:[UIImage imageNamed: @"placeholder.png"]];
        } else NSLog(@"error getting the image from data in EditProfile: %@", error);
            }];
//     self.editAboutMeTextView.text = [[PFUser currentUser] objectForKey:kUserTagLineKey];
    
   
    
    
}

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item { NSLog(@"didSelectItem: %d", item.); }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.editAboutMeTextView resignFirstResponder];
//        [[PFUser currentUser] setObject:self.editAboutMeTextView.text forKey:kUserTagLineKey];
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
