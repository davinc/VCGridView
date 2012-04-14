//
//  RootViewController.m
//  Demo
//
//  Created by Vinay Chavan on 26/06/11.
//  
//  Copyright (C) 2011 by Vinay Chavan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions: 
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "RootViewController.h"

@interface RootViewController()

- (void)didTapAction:(id)sender;

@end


@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

	self.navigationItem.title = @"Grid View Demo";
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	[self.gridView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Private Methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	[self.gridView setEditing:editing animated:animated];
	
	if (editing) {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																							   target:self
																							   action:@selector(didTapAction:)] autorelease];
	}else {
		self.navigationItem.leftBarButtonItem = nil;
	}
}

- (void)didTapAction:(id)sender
{
#if DEBUG
	NSLog(@"Selected item count : %i", [self.gridView.selectedIndexes count]);
#endif
	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%i items selected.", [self.gridView.selectedIndexes count]] 
								 message:nil 
								delegate:nil
					   cancelButtonTitle:@"Dismiss"
					   otherButtonTitles:nil] autorelease] show];
}


#pragma mark - VCThumbnailGridViewDataSource

- (NSInteger)numberOfThumbnailsInThumbnailGridView:(VCThumbnailGridView*)thumbnailGridView 
{
	return 220;
}

- (NSInteger)numberOfThumbnailsInRowForThumbnailGridView:(VCThumbnailGridView *)thumbnailGridView
{
	return 4;
}

- (VCThumbnailView *)thumbnailGridView:(VCThumbnailGridView *)thumbnailGridView thumbnailViewAtIndex:(NSInteger)index reusableThumbnailView:(VCThumbnailView *)reusableThumbnailView
{
	VCThumbnailView *thumbnailView = reusableThumbnailView;
	if (!thumbnailView) {
		thumbnailView = [[[VCThumbnailView alloc] initWithFrame:CGRectZero]autorelease];
	}
	[thumbnailView setImage:[UIImage imageNamed:@"Icon.png"]];
	return thumbnailView;
}

- (BOOL)thumbnailGridView:(VCThumbnailGridView *)thumbnailGridView canEditThumbnailAtIndex:(NSInteger)index
{
	return YES;
}

#pragma mark - VCThumbnailGridViewDelegate

- (CGFloat)spacingOfThumbnailsInThumbnailGridView:(VCThumbnailGridView *)thumbnailGridView
{
	return 4.0f;
}

- (void)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView didSelectThumbnailAtIndex:(NSInteger)index
{
#if DEBUG
	NSLog(@"Selected %i", index);
#endif
}


@end
