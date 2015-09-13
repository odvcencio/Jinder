//
//  DelightNewsFeedViewController.m
//  DelightMatchApp
//
//

#import "DelightNewsFeedViewController.h"
#import <Parse/Parse.h>
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DelightNewsFeedViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSMutableArray *currentMatches;

@property (weak, nonatomic) IBOutlet UILabel *text;

@end

@implementation DelightNewsFeedViewController
    


//-------------------------------------------------------------Under contruction
    
- (NSMutableArray *)currentMatches
{
    if (!_currentMatches) {
        _currentMatches = [[NSMutableArray alloc] init];
    }
    return _currentMatches;
    
}

//-------------------------------------------------------------

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

//-------------------------------------------------------------End Under Contruction

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self returnAllUserFromParseThatMatchCurrentUserPreference];
    
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
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:userAtIndPathURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    cell.textLabel.text = userAtIndPathName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 //   [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath];
    
    
}



@end

