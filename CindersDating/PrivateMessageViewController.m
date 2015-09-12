//
//  PrivateMessageViewController.m
//  DelightMatchApp
//
//  Created by Alex Cruz on 7/29/15.
//  Copyright (c) 2015 Felicia Ferreira. All rights reserved.
//

#import "PrivateMessageViewController.h"
#import "ConnectionListViewController.h"

@interface PrivateMessageViewController ()
{
    NSTimer *timer;
    BOOL isLoading;
    BOOL initialized;
    NSString *groupId;
    NSDate *date;
    
    NSMutableArray *users;
    NSMutableArray *messages;
    NSMutableDictionary *avatars;

    JSQMessagesBubbleImage *bubbleImageOutgoing;
    JSQMessagesBubbleImage *bubbleImageIncoming;
    JSQMessagesAvatarImage *avatarImageBlank;
}
@end

@implementation PrivateMessageViewController
- (IBAction)backButton:(UIBarButtonItem *)sender {
 //[self dismissViewControllerAnimated:YES completion:nil];  //matchesToChatSegue
   // [self performSegueWithIdentifier:@"matchesToChatSegue" sender:self]; yoyoyoyo
}




-(id) initWith:(NSString *)groupId_ {
        self = [super init];
        groupId = groupId_;
        return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
   
    
    users = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    avatars = [[NSMutableDictionary alloc] init];
    
    PFUser *user = [PFUser currentUser];
    self.senderId = user.objectId;
    self.senderDisplayName = user[@"firstName"];
    

    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor purpleColor]];
    bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor greenColor]];
    
    isLoading = NO;
    initialized = NO;
    [self loadMessages];

    
    self.showLoadEarlierMessagesHeader = YES;
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.inputToolbar.maximumHeight = 150;
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.hidesBackButton = NO;  // changes are here ;;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}

#pragma mark- parse methods

-(void)loadMessages{
    if(isLoading == NO){
        isLoading = YES;
        date = [NSDate date];
        
        JSQMessage *messageLast = [messages lastObject];
        
        PFQuery *query = [PFQuery queryWithClassName:@"dMessage"];
        [query whereKey:@"matchRoom" equalTo:_delightChat];
    
        if (messageLast != nil) [query whereKey:@"createdAt" greaterThan:messageLast.date];
        
        [query includeKey:@"user"];
        [query orderByDescending:@"createdAt"];
        [query setLimit:50];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error == nil)
             {
                 BOOL incoming = NO;
                 self.automaticallyScrollsToMostRecentMessage = NO;
                 for (PFObject *object in [objects reverseObjectEnumerator])
                 {
                     JSQMessage *message = [self addMessage:object];
                     if (message) {
                         if ([self incoming:message]){
                             incoming = YES;
                             self.title = message.senderDisplayName;
                         }
                         NSLog(@"adding %@",message.text);
                     }
                 }
                 if ([objects count] != 0)
                 {
                     [self performSelectorOnMainThread:@selector(doneLoading) withObject:nil waitUntilDone:NO];
                     
                 }
                 self.automaticallyScrollsToMostRecentMessage = YES;
                 initialized = YES;
             }
             else
                 NSLog(@"error has happen");
             isLoading = NO;
         }];
        
 
    }
}

- (void) doneLoading {
    //if (initialized && incoming){
    //[JSQSystemSoundPlayer jsq_playMessageReceivedSound];
    //}
    [self finishReceivingMessage];
    [self scrollToBottomAnimated:NO];
        
}

- (JSQMessage *)addMessage:(PFObject *)object{
    JSQMessage *message;
    
    PFUser *user = [PFUser currentUser];
    [object objectForKey:@"user"];
    
    PFUser *sendingUser = [object objectForKey:@"user"];
    NSString *name = sendingUser[@"firstName"];
    
    if(object[@"message"] != [NSNull null] && [object[@"message"] length] > 0){
        message = [[JSQMessage alloc] initWithSenderId:sendingUser.objectId senderDisplayName:name date:object.createdAt text:object[@"message"]];
        
        [users addObject:user];
        [messages addObject:message];
    } else {
        NSLog(@"BAD MESSAGE");
    }
    
    return message;
}

- (void)sendMessage:(NSString *)text{
    PFUser *currentUser = [PFUser currentUser];
    
    PFObject *object = [PFObject objectWithClassName:@"dMessage"];
    object[@"user"] = currentUser;
    object[@"matchRoom"] = _delightChat;
    object[@"message"] = text;
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             [JSQSystemSoundPlayer jsq_playMessageSentSound];
             [self loadMessages];
         }
         else {
             NSLog(@"Error");
         }
     }];
    
    [self finishSendingMessage];
    
}

#pragma mark- JSQMessages method override

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        return avatarImageBlank;
    }

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
 
    [self sendMessage:text];
}

#pragma mark JSQMessages CollectionView Data Source

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    return messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self outgoing:messages[indexPath.item]])
    {
        return bubbleImageOutgoing;
    }
    else return bubbleImageIncoming;
    
}



- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item % 3 == 0)
    {
        JSQMessage *message = messages[indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    else return nil;
    
}
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath{
    
    JSQMessage *message = messages[indexPath.item];
    if ([self incoming:message])
    {
        if (indexPath.item > 0)
        {
            JSQMessage *previous = messages[indexPath.item-1];
            if ([previous.senderId isEqualToString:message.senderId])
            {
                return nil;
            }
        }
        return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
    }
    else return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self outgoing:messages[indexPath.item]])
    {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.textView.textColor = [UIColor blackColor];
    }
    
    JSQMessage *message = messages[indexPath.item];
    cell.textView.text = message.text;
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item % 3 == 0)
    {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else return 0;
    
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *message = messages[indexPath.item];
    if ([self incoming:message])
    {
        if (indexPath.item > 0)
        {
            JSQMessage *previous = messages[indexPath.item-1];
            if ([previous.senderId isEqualToString:message.senderId])
            {
                return 0;
            }
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else return 0;
    
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
    
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender{
    NSLog(@"didTapLoadEarlierMessagesButton");
}

/*- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView
           atIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *message = messages[indexPath.item];
    if ([self incoming:message])
  {
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *message = messages[indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation{
    NSLog(@"didTapCellAtIndexPath %@", NSStringFromCGPoint(touchLocation));
    
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helper Function
- (BOOL)incoming:(JSQMessage *)message{
    return ([message.senderId isEqualToString:self.senderId] == NO);
    
}
- (BOOL)outgoing:(JSQMessage *)message{
    return ([message.senderId isEqualToString:self.senderId] == YES);
    
}

@end
