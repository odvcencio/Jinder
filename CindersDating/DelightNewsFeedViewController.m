//
//  DelightNewsFeedViewController.m
//  DelightMatchApp
//
//

#import "DelightNewsFeedViewController.h"
#import <Parse/Parse.h>
#import "SettingsViewController.h"
#import "ProfileViewController.h"

@interface DelightNewsFeedViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *currentMatches;


@property (weak, nonatomic) IBOutlet UIImageView *image;
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
    // Initialize table data
//    recipes = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
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
    
    
//    PFUser *usersIMightLike;
//    NSString *usersIMightLikeName = userMatches[@"firstName"];
    UILabel *text = (UILabel*) [cell viewWithTag:101];
    
//    text.text = usersIMightLikeName;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    

//
//    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
//    nameLabel.text = [userMatchesArray objectForKey:@"firstName"];

    
    return cell;
}




//- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
//    static NSString *identifier = @"cell";
//    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    
//    if (!cell) {
//        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    
//    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
//    nameLabel.text = [object objectForKey:@"firstName"];
//    
//    
//    
//    // Configure the cell
//    PFFile *thumbnail = [object objectForKey:@"img"];
//    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
//    thumbnailImageView.image = [UIImage imageNamed:@"delight-placeholder.jpg"];
//    thumbnailImageView.file = thumbnail;
//    [thumbnailImageView loadInBackground];
//    
//    return cell;
//    
//}







//
//- (IBAction)selectSettings:(id)sender {
//    NSString * storyboardName = @"StoryboardProfile";
//    NSString * viewControllerID = @"SettingsViewController";
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//    SettingsViewController * controller = (SettingsViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
//    [self presentViewController:controller animated:YES completion:nil];
//    
//}
//
//
//
///******* //////////////////////////////////////////////////////////////////////////////////// *******/
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//
////    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:self        action:@selector(handleBack: ) ];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    self.navigationItem.backBarButtonItem.title = @"Matches";
//
//  //  [self refreshCurrentMatches];
//
//}
//
//
///******* //////////////////////////////////////////////////////////////////////////////////// *******/
//
//
//
//#pragma mark - refreshCurrentMatches - pQuery and add to NSMutableArray
//
////-(void) refreshCurrentMatches{
////    
////    //PFUser *currentUser = [PFUser currentUser];
////    //
////    //PFQuery *query = [PFQuery queryWithClassName:@"User"];
////    
////    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
////    [query whereKey:@"gender" equalTo:@"male"];
////    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
////        if (!error) {
////            // The find succeeded.
////            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
////            // Do something with the found objects
////            
////            [self.currentMatches removeAllObjects];
////            [self.currentMatches addObjectsFromArray:objects];
////            [self.tableView reloadData];
////            
////            //            for (PFObject *object in objects) {
////            //                NSLog(@"%@", object.objectId);
////            //            }
////            
////        } else {
////            // Log details of the failure
////            NSLog(@"Error: %@ %@", error, [error userInfo]);
////        }
////    }];
////    
////    
////}
//
//
//
///******* //////////////////////////////////////////////////////////////////////////////////// *******/
//
//
//#pragma mark - Parse Data
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
//    // [query whereKey:@"gender" equalTo:@"male"];
//    
//    return [query count];
//}
//
///******* //////////////////////////////////////////////////////////////////////////////////// *******/
//
//
////- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
////    static NSString *identifier = @"cell";
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
////    
////    if (!cell) {
////        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
////    }
////    
////    UILabel *name = (UILabel*) [cell viewWithTag:101];
////    cell.name.text = [object objectForKey:@"firstName"];
////    
////    
////    //    UILabel *gender = (UILabel*) [cell viewWithTag:102];
////    //    gender.text = [object objectForKey:@"gender"];
////    
////    
////    // Configure the cell
//////    PFFile *thumbnail = [object objectForKey:@"image"];
//////    UIImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
//////    thumbnailImageView.image = [UIImage imageNamed:@"delight-placeholder.jpg"];
//////    thumbnailImageView.file = thumbnail;
//////    [thumbnailImageView loadInBackground];
////    
////    return cell;
////    
////}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//
//    
//    
//    static NSString *cellIdentifier = @"cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//    }
//    
//   cell.textLabel.text = [self.currentMatches objectAtIndex:indexPath.row];
//    
//    // Configure the cell to show todo item with a priority at the bottom
//  //  cell.textLabel.text = object[@"firstName"];
// //   cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",  object[@"priority"]];
//    
//    return cell;
//}
//
//
//
//
///******* //////////////////////////////////////////////////////////////////////////////////// *******/
//
// - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
// {
//     [tableView deselectRowAtIndexPath:indexPath animated:YES];
//     [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath];
//
//
// }




@end

