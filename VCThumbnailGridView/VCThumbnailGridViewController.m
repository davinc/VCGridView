//
//  VCThumbnailGridViewController.m
//  Demo
//
//  Created by Vinay Chavan on 29/09/11.
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

#import "VCThumbnailGridViewController.h"

@implementation VCThumbnailGridViewController

@synthesize gridView = _gridView;

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
	[_gridView release], _gridView = nil;
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	[super loadView];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	_gridView = [[VCThumbnailGridView alloc] initWithFrame:self.view.bounds];
	_gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_gridView.delegate = self;
	_gridView.dataSource = self;
	[self.view addSubview:_gridView];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification 
											   object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[_gridView release], _gridView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - VCThumbnailGridViewDataSource

- (NSInteger)numberOfThumbnailsInThumbnailGridView:(VCThumbnailGridView*)thumbnailGridView 
{
	return 0;
}

- (NSInteger)numberOfThumbnailsInRowForThumbnailGridView:(VCThumbnailGridView *)thumbnailGridView
{
	return 4;
}

- (VCThumbnailView *)thumbnailGridView:(VCThumbnailGridView *)thumbnailGridView thumbnailViewAtIndex:(NSInteger)index reusableThumbnailView:(VCThumbnailView *)reusableThumbnailView
{
	return nil;
}

- (BOOL)thumbnailGridView:(VCThumbnailGridView *)thumbnailGridView canEditThumbnailAtIndex:(NSInteger)index
{
	return YES;
}

#pragma mark - VCThumbnailGridViewDelegate

- (void)thumbnailGridView:(VCThumbnailGridView *)thumbnailGridView didSelectThumbnailAtIndex:(NSInteger)index
{
	
}

#pragma mark Keyboard show hide

- (void)keyboardBecameVisible:(BOOL)visible notification:(NSNotification*)notification {
	_isInputViewVisible = visible;
	
	CGRect newFrame = CGRectZero;
	
	NSDictionary* userInfo = [notification userInfo];
	
	// Get animation info from userInfo
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	
	CGRect keyboardEndFrame = CGRectZero;
	[[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	
	newFrame = self.view.frame;
	CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
	newFrame.size.height -= keyboardFrame.size.height * (visible? 1 : -1);
	
	// Animate up or down
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	
	self.view.frame = newFrame;
	
	[UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification*)notification {
	[self keyboardBecameVisible:YES notification:notification];
}

- (void)keyboardWillHide:(NSNotification*)notification {
	[self keyboardBecameVisible:NO notification:notification];
}

@end
