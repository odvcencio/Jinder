//
//  PrivateMessageViewController.h
//  DelightMatchApp
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JSQMessages.h"

@interface PrivateMessageViewController : JSQMessagesViewController <UIActionSheetDelegate>

@property (strong, nonatomic) PFObject *delightChat;

@property (strong, nonatomic) NSString* chatWithName;


@end
