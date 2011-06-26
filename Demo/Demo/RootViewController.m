//
//  RootViewController.m
//  Demo
//
//  Created by Vinay Chavan on 26/06/11.
//  Copyright 2011 Vinay Chavan. All rights reserved.
//

#import "RootViewController.h"


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
	[_gridView release];
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
	self.view.backgroundColor = [UIColor blackColor];
	
	_gridView = [[VCThumbnailGridView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
	_gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_gridView.backgroundColor = [UIColor whiteColor];
	_gridView.gridDelegate = self;
	_gridView.gridDataSource = self;
	_gridView.rowHeight = 150;
	_gridView.scrollsToTop = YES;
	[self.view addSubview:_gridView];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - VCThumbnailGridViewDataSource

- (NSInteger)numberOfThumbnailsInThumbnailGridView:(VCThumbnailGridView*)thumbnailGridView {
	return 20;
}
- (NSInteger)numberOfThumbnailsInRowInThumbnailGridView:(VCThumbnailGridView*)thumbnailGridView {
	return 4;
}
- (UIImage*)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView imageAtIndex:(NSInteger)index {
	return [UIImage imageNamed:@"Icon.png"];
}

#pragma mark - VCThumbnailGridViewDelegate

- (void)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView didSelectThumbnailAtIndex:(NSInteger)index {
	
}

@end
