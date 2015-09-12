//
//  ConnectionListViewController.h
//  DelightMatchApp
//
//  Created by Alex Cruz on 7/29/15.
//  Copyright (c) 2015 Felicia Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString* chatWithName;

@end
