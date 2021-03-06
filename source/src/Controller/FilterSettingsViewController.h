//
//  FilterSettingsViewController.h
//  Backyard Brains
//
//  Created by Stanislav Mircic on 10/29/14.
//  Copyright (c) 2014 Datta Lab, Harvard University. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BBFilterConfigDelegate;

@interface FilterSettingsViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate>
@property (retain, nonatomic) IBOutlet UITextField *lowTI;
@property (retain, nonatomic) IBOutlet UISlider *lowSlider;
@property (retain, nonatomic) IBOutlet UITextField *highTI;
@property (retain, nonatomic) IBOutlet UISlider *highSlider;
@property (retain, nonatomic) IBOutlet UISwitch *notchFilterSwitch;

@property (nonatomic, assign) id <BBFilterConfigDelegate> masterDelegate;

- (IBAction)lowSliderValueChanged:(id)sender;
- (IBAction)highSliderValueChanged:(id)sender;



@end

@protocol BBFilterConfigDelegate <NSObject>

-(void) finishedWithConfiguration;

@end