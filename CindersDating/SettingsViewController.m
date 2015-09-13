//
//  SettingsViewController.m
//  DelightMatchApp
//
#import <Parse/Parse.h>
#import "SettingsViewController.h"


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet TTRangeSlider *ageSlider;
@property (strong, nonatomic) NSNumber *minAge;
@property (strong, nonatomic) NSNumber *maxAge;


@end

@implementation SettingsViewController
{
    float *minAgeFloat;
    float *maxAgeFloat;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.ageSlider.delegate = self;
    self.ageSlider.minValue = 18;
    self.ageSlider.maxValue = 65;

     
    
    
    

}
/*-(void)createSlider{
UIView *lineViewHorizon = [[UIView alloc] initWithFrame:CGRectMake(0, pageTopMargin+inthorizon, self.view.bounds.size.width, 2)];
lineViewHorizon.backgroundColor = [UIColor blueColor];
[self.view addSubview:lineViewHorizon];
[lineViewHorizon removeFromSuperview];

}
*/

-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum {
    if (sender == self.ageSlider){
        NSLog(@"Standard slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        _minAge = [NSNumber numberWithInt: selectedMinimum];
        _maxAge = [NSNumber numberWithInt:selectedMaximum];
        [self ageSetToParse];
        
    }
    
}

-(void)ageSetToParse{
    PFUser *current = [PFUser currentUser];
    
    [current setObject:_minAge forKey:@"minAge"];
    [current setObject:_maxAge forKey:@"maxAge"];
    
    [current saveInBackground];
    
}

-(void)ageGetFromParse{
    PFUser *current = [PFUser currentUser];

}

- (IBAction)doneButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Parse Data

// Look at rough draft


#pragma mark - Helper Function










@end
