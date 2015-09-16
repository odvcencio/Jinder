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

@property (nonatomic) NSNumber *selectedMinimum;
@property (nonatomic) NSNumber *selectedMaximum;

//@property (strong, nonatomic) NSString *min;
//@property (strong, nonatomic) NSString *max;

@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;



@end

@implementation SettingsViewController
{
//    float *minAgeFloat;
//   float *maxAgeFloat;
    
//    float *min;
//    float *max;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.ageSlider.delegate = self;
    self.ageSlider.minValue = 18;
    self.ageSlider.maxValue = 60;
 
        [self ageGetFromParse];
  
 //   PFUser *currentUser = [PFUser currentUser];
    
 //   NSNumber *lastSelect = [currentUser objectForKey:@"minAge"];
 //   NSNumber *lastSelectMax = [currentUser objectForKey:@"maxAge"];
    
 //   [self rangeSlider:self.ageSlider didChangeSelectedMinimumValue:@"lastSelect" andMaximumValue:@"lastSelectMax"];


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
       _maxAge = [NSNumber numberWithInt: selectedMaximum];
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
    
    if (current) {
        // do stuff with the user
         PFQuery *query = [PFQuery queryWithClassName:@"_User"];
         [query getObjectInBackgroundWithId:@"ud7EMc6wVR" block:^(PFObject *user, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
           int min = [[user objectForKey:@"minAge"] intValue];
           int max = [[user objectForKey:@"maxAge"] intValue];
             
             NSString *strFromInt1 = [NSString stringWithFormat:@"%d", min];
             NSString *strFromInt2 = [NSString stringWithFormat:@"%d", max];
             
//             NSNumber *min = user[@"minAge"];
//             NSNumber *max = user[@"maxAge"];
             
             self.minLabel.text = strFromInt1;
             self.maxLabel.text = strFromInt2;
            
        
       //     [self rangeSlider:self.ageSlider didChangeSelectedMinimumValue:min andMaximumValue:max];
            
//            self.ageSlider.delegate = self;
//            self.ageSlider.minValue = selectedMinimum;
//            self.ageSlider.maxValue = selectedMaximum;
            
     
            
            
            NSLog(@"%@", user);
            
            NSLog(@"%@", strFromInt1);
            NSLog(@"%@", strFromInt2);
            
        }];
    } else {
        // show the signup or login screen
    }
    
    

    
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
