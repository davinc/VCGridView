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
	self.view.backgroundColor = [UIColor blackColor];
	
	_gridView = [[VCThumbnailGridView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
	_gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_gridView.backgroundColor = [UIColor whiteColor];
	_gridView.delegate = self;
	_gridView.dataSource = self;
	[self.view addSubview:_gridView];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[_gridView reloadData];
	
	self.navigationItem.title = @"Grid View Demo";
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


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


#pragma mark - Private Methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	[_gridView setEditing:editing animated:animated];
}


#pragma mark - VCThumbnailGridViewDataSource

- (NSInteger)numberOfThumbnailsInThumbnailGridView:(VCThumbnailGridView*)thumbnailGridView 
{
	return 22;
}

- (UIImage*)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView imageAtIndex:(NSInteger)index 
{
	return [UIImage imageNamed:@"Icon.png"];
}

//- (NSString*)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView imageUrlAtIndex:(NSInteger)index
//{
//	return [NSString stringWithString:@"http://gravatar.com/avatar/dbdebfdea3fb580bf9402c202f1fbcc9"];
//}

#pragma mark - VCThumbnailGridViewDelegate

- (void)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView didSelectThumbnailAtIndex:(NSInteger)index
{
#if DEBUG
	NSLog(@"Selected %i", index);
#endif
}

@end
