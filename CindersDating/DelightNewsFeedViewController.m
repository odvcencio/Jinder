//
//  DelightNewsFeedViewController.m
//  DelightMatchApp
//
//

#import "DelightNewsFeedViewController.h"
#import <Parse/Parse.h>
#import "SettingsViewController.h"
#import "ConnectionListViewController.h"
#import "ProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DelightNewsFeedViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *currentMatches;
@property (weak, nonatomic) IBOutlet UILabel *Label;
// image view
@property (strong, nonatomic) UIImageView *imageHolder;
@end

@implementation DelightNewsFeedViewController

//-------------------------------------------------------------Segue

- (IBAction)selectSettings:(id)sender {
    NSString * storyboardName = @"StoryboardSettings";
    NSString * viewControllerID = @"SettingsViewController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    SettingsViewController * controller = (SettingsViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:YES completion:nil];
    
}
- (IBAction)connectionsButton:(id)sender {
    NSString * storyboardName = @"StoryboardInteraction";
    NSString * viewControllerID = @"navBar";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    ConnectionListViewController * controller = (ConnectionListViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:YES completion:nil];
}

//-------------------------------------------------------------End Segue

//-------------------------------------------------------------Array
    
- (NSMutableArray *)currentMatches
{
    if (!_currentMatches) {
        _currentMatches = [[NSMutableArray alloc] init];
    }
    return _currentMatches;
    
}

//-------------------------------------------------------------End Array


//------------------------------------------------------------------------------Start PFClouf function

-(void) returnAllUserFromParseThatMatchCurrentUserPreference1 {
    
 PFUser *current = [PFUser currentUser];

// cloud function
[PFCloud callFunctionInBackground:@"matchFeed"
                   withParameters:@{@"objectId": current.objectId}
                            block:^(NSArray *objects, NSError *error) {
                                if (!error) {
                                    // ratings is 4.5
                               //     if ([objects  isEqual:@"They fucking match"]) {
                                        //  NSLog(@"is it object: %@", total);
                                        
                                        [self.currentMatches removeAllObjects];
                                        [self.currentMatches addObjectsFromArray:objects];
                                        [self.tableView reloadData];
                                    
                            //            NSString *what = @"Go to your inbox and say Hi";
                                     NSLog(@"I have %@", objects);
                      
                                        
                                        
                               //     }
                                    
                                }
                            }];

}
//------------------------------------------------------------------------------End PFClouf function



//-------------------------------------------------------------Start query
/*
-(void) returnAllUserFromParseThatMatchCurrentUserPreference {
    
  //  PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"gender" equalTo:@"male"];
    
   // [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.currentMatches removeAllObjects];
            [self.currentMatches addObjectsFromArray:objects];
            [self.tableView reloadData];
            
        }
    }];

}
*/
//-------------------------------------------------------------End query

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self returnAllUserFromParseThatMatchCurrentUserPreference1];
    
    // Adjust tableview
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentMatches count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    PFUser *userAtIndPath = [self.currentMatches objectAtIndex:indexPath.row];
    
    NSLog(@"%@", userAtIndPath);
    
    NSString *userAtIndPathName;
    NSString *userAtIndPathURL;
    
    userAtIndPathName = [userAtIndPath objectForKey:@"firstName"];
    userAtIndPathURL = [userAtIndPath objectForKey:@"picURL"];
    

    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:100];
    nameLabel.text = [userAtIndPath objectForKey:@"firstName"];
    
    
    UILabel *ageLabel = (UILabel*) [cell viewWithTag:102];
    
   // ageLabel.text = [userAtIndPath objectForKey:@"age"];
    
    int age = [[userAtIndPath objectForKey:@"age"] intValue];
    NSString *strFromInt1 = [NSString stringWithFormat:@"%d", age];
    ageLabel.text = strFromInt1;
    
  //
    
    // Configure the cell
    UIImageView *pic = (UIImageView *) [cell viewWithTag:101];
    
    
    [pic sd_setImageWithURL:[NSURL URLWithString:userAtIndPathURL]
           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"goToProfile" sender:indexPath];
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"goToProfile"])
    {
        
        
        
        ProfileViewController *profileVC = [segue destinationViewController];
        NSIndexPath *indexPath = sender; 
        profileVC.profileUser = [self.currentMatches objectAtIndex:indexPath.row];
        

        
    }

    
    
}



@end

