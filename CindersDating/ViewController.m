//
//  ViewController.m
//  PageView
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib. these comments
    
    //init the the data model for page titiles and images
    _pageTitles = @[@"Select your match!",@"Choose your interests likes",@"Find and Like your match!",@"Chat with your match!", @"Invite your match on a date!"];
    _pageImages = @[@"settings.png",@"interests.png",@"matchfeeds.png",@"chatfeeds.png", @"yelp.png"];
    //[@"delight-setting.jpg",@"delight-screen-2.jpg",@"delight-screen-3.jpg",@"delight-chat.jpg", @"delight-yelp.jpg"];
    
    //create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startWalkThrough:(UIButton *)sender {
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (IBAction)loginFaceBook:(UIButton *)sender {
    
    
    
}

-(PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] ==0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    //create a new view controller and pass suitable data
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
    
}


#pragma mark - Page view controller data source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*)viewController).pageIndex;
    
    //get the current page index
    if ((index ==0) ||(index == NSNotFound)) {
        return nil;
    }
    //decrease the index number
    index--;
    
    //return the view controller to display
    return [self viewControllerAtIndex: index];
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index= ((PageContentViewController*)viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    //increase the index number
    index++;
    //reached the boundaries of the pages
    if (index == [self.pageTitles count]) {
        //and return nil
        return nil;
    }
    //return the view controller to display
    return [self viewControllerAtIndex: index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


@end
