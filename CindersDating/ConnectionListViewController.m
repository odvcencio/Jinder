//
//  ConnectionListViewController.m
//  DelightMatchApp
//
//

#import "ConnectionListViewController.h"
#import "PrivateMessageViewController.h"
#import "DelightNewsFeedViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ConnectionListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *currentConversations;

@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelName;

@property (strong, nonatomic) UIImageView *imageHolder;

@end

@implementation ConnectionListViewController




//settings segue
- (IBAction)selectSettings:(id)sender {
    NSString * storyboardName = @"StoryboardNewsFeed";
    NSString * viewControllerID = @"NavBar";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    DelightNewsFeedViewController * controller = (DelightNewsFeedViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:YES completion:nil];
    
}


//alloc init array of match objects
- (NSMutableArray *)currentConversations
{
    if (!_currentConversations) {
        _currentConversations = [[NSMutableArray alloc] init];
    }
    return _currentConversations;
}


//load the conversations
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self refreshCurrentConversations];
}

//back to match feed
-(void)handleBack:(id)sender{
NSString * storyboardName = @"StoryboardProfile";
NSString * viewControllerID = @"DelightNewsFeedViewController";
UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    DelightNewsFeedViewController * controller = (DelightNewsFeedViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
[self presentViewController:controller animated:YES completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView touch method

//tap cell to segue to that private messaging

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PrivateMessageViewController *dchatVC = [segue destinationViewController];
    NSIndexPath *indexPath = sender;
    dchatVC.delightChat = [self.currentConversations objectAtIndex:indexPath.row];

}


#pragma mark - Parse Data

// Table view of all matches

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentConversations count];
}

//cell for each match room loaded from parse

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *delightChat = [PFObject objectWithClassName:@"DelightChat"];
    
    delightChat = [self.currentConversations objectAtIndex:indexPath.row];
  
    PFUser *likedUser;
    NSString *likedUserName;
    NSString *userAtIndPathURL;
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testUser1 = delightChat[@"user1"];
    
    if ([testUser1.objectId isEqual:currentUser.objectId]) {
        // must compare Parse objects using objectId
        likedUser = [delightChat objectForKey:@"user2"];
        likedUserName = [likedUser objectForKey:@"firstName"];
        userAtIndPathURL = [likedUser objectForKey:@"picURL"];
        self.chatWithName = likedUserName;
    } else {
        likedUser = [delightChat objectForKey:@"user1"];
        likedUserName = [likedUser objectForKey:@"firstName"];
        userAtIndPathURL = [likedUser objectForKey:@"picURL"];
    }
    
    // testing
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:200];
    nameLabel.text = [likedUser objectForKey:@"firstName"];
    
    UIImageView *pic = (UIImageView *) [cell viewWithTag:201];
    
    [pic sd_setImageWithURL:[NSURL URLWithString:userAtIndPathURL]
           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    PFObject *messageRoomKey = [PFObject objectWithClassName:@"dMessage"];
    
    [messageRoomKey setObject:delightChat forKey:@"matchRoom"];
    
    
    [delightChat saveInBackground];

    return cell;
}


#pragma mark - Display a message if you have no items in the inbox

//still in progress



#pragma mark - UITableViewDelegate

//segue to chat from inbox

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath];
    
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//query for chats, add them to array

-(void) refreshCurrentConversations{
    
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"DelightChat"];
    [query whereKey:@"user1" equalTo:currentUser];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"DelightChat"];
    [query2 whereKey:@"user2" equalTo:currentUser];
    
    PFQuery *queryCombine = [PFQuery orQueryWithSubqueries:@[query, query2]];
    [queryCombine includeKey:@"user1"];
    [queryCombine includeKey:@"user2"];
    [queryCombine orderByDescending:@"createdAt"];
    [queryCombine findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.currentConversations removeAllObjects];
            [self.currentConversations addObjectsFromArray:objects];
            [self.tableView reloadData];

        }
    }];
}
@end
