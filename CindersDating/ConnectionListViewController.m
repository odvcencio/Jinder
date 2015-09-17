//
//  ConnectionListViewController.m
//  DelightMatchApp
//
//

#import "ConnectionListViewController.h"
#import "PrivateMessageViewController.h"
#import "DelightNewsFeedViewController.h"

@interface ConnectionListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *currentConversations;

@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelName;

@end

@implementation ConnectionListViewController


//-------------------------------------------------------------Segue


- (IBAction)selectSettings:(id)sender {
    NSString * storyboardName = @"StoryboardNewsFeed";
    NSString * viewControllerID = @"NavBar";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    DelightNewsFeedViewController * controller = (DelightNewsFeedViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:YES completion:nil];
    
}


//-------------------------------------------------------------End Segue


- (NSMutableArray *)currentConversations
{
    if (!_currentConversations) {
        _currentConversations = [[NSMutableArray alloc] init];
    }
    return _currentConversations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
   // PFUser *currentUser = [PFUser currentUser];
    
    
    
   
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Match Feed" style:UIBarButtonItemStyleDone target:self action:@selector(handleBack: ) ];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//     self.navigationItem.backBarButtonItem.title = @"Matches";
    

    
    [self refreshCurrentConversations];
    
    
}

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


#pragma mark - Navigation Match Feed Example

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *delightChat = [PFObject objectWithClassName:@"DelightChat"];
    
    delightChat = [self.currentConversations objectAtIndex:indexPath.row];
    
    PFUser *likedUser;
    NSString *likedUserName;
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testUser1 = delightChat[@"user1"];
    
    if ([testUser1.objectId isEqual:currentUser.objectId]) {  // must compare Parse objects using objectId
        likedUser = [delightChat objectForKey:@"user2"];
        likedUserName = [likedUser objectForKey:@"firstName"];
        self.chatWithName = likedUserName;
    } else {
        likedUser = [delightChat objectForKey:@"user1"];
        likedUserName = [likedUser objectForKey:@"firstName"];
    }
    
    cell.textLabel.text = likedUserName;
    
    
    PFObject *messageRoomKey = [PFObject objectWithClassName:@"dMessage"];
    
    [messageRoomKey setObject:delightChat forKey:@"matchRoom"];
    
    
    [delightChat saveInBackground];
    
    /*    PFQuery *queryForPhoto = [[PFQuery alloc] initWithClassName:@"Photo"];
     [queryForPhoto whereKey:@"user" equalTo:likedUser];
     [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     if ([objects count] > 0){
     }
     }];*/
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath];
    
    
}


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
