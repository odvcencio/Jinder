//
//  DelightNewsFeedViewController.m
//  DelightMatchApp
//
//  Created by Alex Cruz on 8/4/15.
//  Copyright (c) 2015 Felicia Ferreira. All rights reserved.
//

#import "DelightNewsFeedViewController.h"
#import <Parse/Parse.h>
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "ConnectionListViewController.h"

@interface DelightNewsFeedViewController ()


@end

@implementation DelightNewsFeedViewController

- (IBAction)selectSettings:(id)sender {
    NSString * storyboardName = @"StoryboardProfile";
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


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"_User";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"firstName";
        self.textKey = @"gender";
        
      //  self.textKey = @"img";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;

    }
    return self;
}


- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    return query;
}

// UITableViewCell
// PFTableViewCell

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *identifier = @"cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"firstName"];
    
    
    UILabel *gender = (UILabel*) [cell viewWithTag:102];
    gender.text = [object objectForKey:@"gender"];
    
    
    // Configure the cell
    PFFile *thumbnail = [object objectForKey:@"img"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
    thumbnailImageView.image = [UIImage imageNamed:@"delight-placeholder.jpg"];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * storyboardName = @"StoryboardProfile";
    NSString * viewControllerID = @"ProfileViewController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    ProfileViewController * controller = (ProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:YES completion:nil];
}


//- (instancetype)initWithStyle:(UITableViewStyle)style {
//    self = [super initWithStyle:style];
//    if (self) { // This table displays items in the Todo class
//        self.parseClassName = @"User";
//        self.textKey = @"firstName";
//        self.pullToRefreshEnabled = YES;
//        self.paginationEnabled = YES;
//        self.objectsPerPage = 25;
//    }
//    return self;
//}
//
//
//- (PFQuery *)queryForTable {
//    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
//    
//    // If no objects are loaded in memory, we look to the cache first to fill the table
//    // and then subsequently do a query against the network.
//    if (self.objects.count == 0) {
//        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    }
//    
//    [query orderByDescending:@"createdAt"];
//    
//    return query;
//}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath
//                        object:(PFObject *)object {
//    static NSString *cellIdentifier = @"cell";
//    
//    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
//                                      reuseIdentifier:cellIdentifier];
//    }
//    
//    // Configure the cell to show todo item with a priority at the bottom
//    cell.textLabel.text = object[@"text"];
//   // cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",  object[@"priority"]];
//    
//    return cell;
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//}



/*

- (id)initWithCoder:(NSCoder *)aCoder {
    
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"User";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"firstName";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        self.imageKey = @"picURL";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 20;
    }
    
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}



- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    

    return query;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)User {
    
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    
    // Configure the cell
    PFFile *thumbnail = [User objectForKey:@"picURL"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
    thumbnailImageView.image = [UIImage imageNamed:@"delight-placeholder.jpg"];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];
    
    // Configure the cell to show todo item with a priority at the bottom
    // cell.textLabel.User = object[@"User"];
    // cell.textLabel.text = [User objectForKey:@"firstName"];
    
       UILabel *textLabel = (UILabel*) [cell viewWithTag:101];
       textLabel.text = [User objectForKey:@"firstName"];
    
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",  object[@"priority"]];
    
    //    NSLog(@"%@", self.textKey);
    //    NSLog(@"%@", self.imageKey);
    
    return cell;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




@end

