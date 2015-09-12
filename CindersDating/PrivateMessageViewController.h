//
//  PrivateMessageViewController.h
//  DelightMatchApp
//
//  Created by Alex Cruz on 7/29/15.
//  Copyright (c) 2015 Felicia Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JSQMessages.h"

@interface PrivateMessageViewController : JSQMessagesViewController <UIActionSheetDelegate>

@property (strong, nonatomic) PFObject *delightChat;

@property (strong, nonatomic) NSString* chatWithName;

- (id)initWith:(NSString *)groupId_;


@end
