//
//  SettingsViewController.m
//  DelightMatchApp
//
//  Created by Alex Cruz on 7/29/15.
//  Copyright (c) 2015 Felicia Ferreira. All rights reserved.
//
#import <Parse/Parse.h>
#import "SettingsViewController.h"
#define MILES2KM(miles) (ceil(miles*1609.34))
#import "YelpMapViewController.h"
#define MILES2METERS(mi) ((float)mi*1609.34))
@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *PhotoSharing;
@property (weak, nonatomic) IBOutlet UISwitch *ProfileOn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *GenderChooser;

@property (weak, nonatomic) IBOutlet UISlider *WithinMiles;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *LoadingOne;
@property (weak, nonatomic) IBOutlet UIButton *SaveSettings;

@property (weak, nonatomic) IBOutlet UISlider *youngest;
@property (weak, nonatomic) IBOutlet UISlider *Oldest;
@property (weak, nonatomic) IBOutlet UILabel *MinAgeShower;
@property (weak, nonatomic) IBOutlet UILabel *MaxAgeShower;
@property (weak, nonatomic) IBOutlet UILabel *DistanceShower;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UISlider *slidebar = [[UISlider alloc]init];
    slidebar.minimumValue = 1;
    slidebar.maximumValue = 125;
    PFQuery *query = [PFUser query];
    [query whereKey:@"gender" equalTo:@"male"]; // find all the men
    NSArray *men = [query findObjects];
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
- (IBAction)ShowProfile:(id)sender {



}



- (IBAction)PhotoSharing:(id)sender {



}

- (IBAction)DistanceRange:(id)sender {
    self.DistanceShower.text = [[NSString alloc]initWithFormat:@"%.1f mi", ceil
                            (self.WithinMiles.value)];
    float f =self.WithinMiles.value;
     PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:[NSNumber numberWithFloat:f] forKey:@"searchDist"];
    [currentUser saveInBackground];
}




- (IBAction)GenderBender:(id)sender {
    UISegmentedControl * segmentedControl = (UISegmentedControl *)sender;
     PFUser *currentUser = [PFUser currentUser];
    if(segmentedControl.selectedSegmentIndex == 0){
        
  
        
        [currentUser setObject:@YES forKey:@"showMan"];
        [currentUser setObject:@NO forKey:@"showWoman"];
        
        
//        PFQuery *query0 = [PFUser query];
//        [query0 whereKey:@"gender" equalTo:@"male"]; // find all the men
//        NSArray *men = [query0 findObjects];
//        
//    
//        NSLog ([NSString stringWithFormat:@"%lu", (unsigned long)men.count]);
//        
        
        
        [[PFUser currentUser] saveInBackground];
    
    } else if (segmentedControl.selectedSegmentIndex == 1){
    
        
        [currentUser setObject:@YES forKey:@"showWoman"];
         [currentUser setObject:@NO forKey:@"showMan"];
        
         [[PFUser currentUser] saveInBackground];
        
        //
//        PFQuery *query = [PFUser query];
//        [query whereKey:@"gender" equalTo:@"female"]; // find all the women
//        NSArray *women = [query findObjects];
    
        
        
        
        // NSLog ([NSString stringWithFormat:@"%lu", (unsigned long)women.count]);
    }
    
    else if (segmentedControl.selectedSegmentIndex == 2){
       

        [currentUser setObject:@YES forKey:@"showWoman"];
        [currentUser setObject:@YES forKey:@"showMan"];
        
         [[PFUser currentUser] saveInBackground];
        
        
        
        //        PFQuery *query2 = [PFUser query];
//        [query2 whereKey:@"gender" equalTo:@"female"];
//        
//        
//        PFQuery *query3 = [PFUser query];
//        [query3 whereKey:@"gender" equalTo:@"male"];
//        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query3,query2]];
//        NSArray *both = [query findObjects];
//        
//        
//        
//        
//        
//        
//        
//        
//
//  NSLog ([NSString stringWithFormat:@"%lu", (unsigned long)both.count]);
// |  0   |  1   |  2    |  3    |  4   |  5   |
//  showP  photoS  minAge MaxAge   dist   M/F
 
  [[PFUser currentUser] saveInBackground];
    }
}


-(NSMutableArray*)dataGathering{
    NSMutableArray * dataGatReturn = [[NSMutableArray alloc]init];
    
    //////////////////////////////  photo sharing on/off
    if (self.PhotoSharing) {
        [dataGatReturn addObject:@"OnPhotoSharing"];
    } else {
        [dataGatReturn addObject:@"OffPhotoSharing"];
    }
    //////////////////////////////  profile on/off
    if (self.ProfileOn) {
        [dataGatReturn addObject:@"OnProfile"];
    } else {
        [dataGatReturn addObject:@"OffProfile"];
    }
    //////////////////////////////  min age

       // [dataGatReturn addObject:[NSNumber  numberWithInteger:]];
          [dataGatReturn addObject:@"20"];
    //////////////////////////////  max age

      //  [dataGatReturn addObject:[NSNumber  numberWithInteger:]];
           [dataGatReturn addObject:@"27"];
    ////////////////////////////// distance

      //  [dataGatReturn addObject:[NSNumber  numberWithFloat:[self.]];
           [dataGatReturn addObject:[NSNumber  numberWithInteger:MILES2KM(100)]];
    //////////////////////////////  man/woman
    switch (self.GenderChooser.selectedSegmentIndex) {
        case 0:
            [dataGatReturn addObject:@"Man"];
            break;
        case 1:
            [dataGatReturn addObject:@"Woman"];
            break;
        default:
            break;
    }
    
    return dataGatReturn;
}



- (IBAction)SaveSettings:(id)sender





    {

    
    
    
    }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    YelpMapViewController *webVC = [segue destinationViewController];
    
   // webVC.range = [[NSString alloc]initWithFormat:@"%f", 1609.34*(self.WithinMiles.value)];
    //webVC.url = self.url;
    
    //////////////////////////////////////////////////////////////////////////////
   // NSLog(@"%@", webVC.range);
    NSLog(@" should segue out ");
}
// When sugueing out enter this code in the save method  [self performSegueWithIdentifier:@"webViewSegue" sender:self];


float RoundValue(UISlider * slider) {
    return roundf(slider.value * 2.0) * 1;
}

- (IBAction)MinAgeBar:(UISlider *)sender {
    self.Oldest.minimumValue = sender.value;

    float myValue = RoundValue(sender);
    
    
    self.MinAgeShower.text = [[NSString alloc]initWithFormat:@"%.0f", ceil
                                (self.youngest.value)];
    
    
    int f =self.youngest.value;
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:[NSNumber numberWithInt:f] forKey:@"minAgeToSearch"];
    [currentUser saveInBackground];


}




- (IBAction)MaxAgeBar:(UISlider *)sender {
    self.youngest.maximumValue = sender.value;

    
    float myValue = RoundValue(sender);
    self.MaxAgeShower.text = [[NSString alloc]initWithFormat:@"%.0f", ceil
                                  (self.Oldest.value)];
    
    
    int f =self.Oldest.value;
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:[NSNumber numberWithInt:f] forKey:@"maxAgeToSearch"];
    [currentUser saveInBackground];
}





@end
