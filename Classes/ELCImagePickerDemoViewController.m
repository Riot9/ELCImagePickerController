//
//  ELCImagePickerDemoViewController.m
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerDemoAppDelegate.h"
#import "ELCImagePickerDemoViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"

@implementation ELCImagePickerDemoViewController
{
    CGRect workingFrame;
}

@synthesize scrollview;

-(IBAction)launchController {
	
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];    
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];
    
    ELCImagePickerDemoAppDelegate *app = (ELCImagePickerDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.viewController presentModalViewController:elcPicker animated:YES];
    [elcPicker release];
    [albumController release];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker willFinishPickingThisManyMediaItems:(NSNumber *)number
{
    
    for (UIView *v in [scrollview subviews]) {
        [v removeFromSuperview];
    }
    workingFrame = scrollview.frame;
	workingFrame.origin.x = 0;
    [scrollview setPagingEnabled:YES];

    [self dismissModalViewControllerAnimated:YES];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker hasMediaWithInfo:(NSDictionary *)info
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.frame = workingFrame;
        [scrollview addSubview:imageview];
        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
        [scrollview setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
        [imageview release];
    });
    
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
	

    for (UIView *v in [scrollview subviews]) {
        [v removeFromSuperview];
    }
    
	workingFrame = scrollview.frame;
	workingFrame.origin.x = 0;
	
	for(NSDictionary *dict in info) {
	
		UIImageView *imageview = [[UIImageView alloc] initWithImage:[dict objectForKey:UIImagePickerControllerOriginalImage]];
		[imageview setContentMode:UIViewContentModeScaleAspectFit];
		imageview.frame = workingFrame;
		
		[scrollview addSubview:imageview];
		[imageview release];
		
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
	}
	
	[scrollview setPagingEnabled:YES];
	[scrollview setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {

	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
