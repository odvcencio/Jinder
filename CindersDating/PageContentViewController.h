//
//  PageContentViewController.h
//  PageView
//
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

//stores the current page index or number yeah but
@property NSUInteger pageIndex;

//vc display an image and a tile
@property NSString *titleText;
@property NSString *imageFile;

@end
