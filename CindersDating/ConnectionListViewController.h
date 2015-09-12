//
//  ConnectionListViewController.h
//  DelightMatchApp
//
//

#import <UIKit/UIKit.h>

@interface ConnectionListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString* chatWithName;

@end
