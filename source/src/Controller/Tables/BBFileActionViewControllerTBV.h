//
//  BBFileActionViewControllerTBV.h
//  Backyard Brains
//
//  Created by Zachary King on 7/13/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BBFileTableCell.h"
#import "PlaybackViewController.h"
#import "SpikesAnalysisViewController.h"
#import "BBFileDetailsTableViewController.h"

@protocol BBFileActionViewControllerDelegate
@required
    @property (nonatomic, retain) NSArray *filesSelectedForAction;
    - (void)deleteTheFiles:(NSArray *)files;
@end


@interface BBFileActionViewControllerTBV : UITableViewController  
        <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    PlaybackViewController * playbackController;
}

@property (nonatomic, retain) NSArray *actionOptions;

//For BBFileDownloadViewControllerDelegate
@property (nonatomic, retain) NSArray *fileNamesToShare;

//for DrawingViewControllerDelegate
@property (nonatomic, retain) NSArray *files;

@property (nonatomic, assign) id <BBFileActionViewControllerDelegate> delegate;


- (void)emailFiles;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

- (void)downloadFiles;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;


@end
