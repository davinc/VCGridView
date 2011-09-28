//
//  VCThumbnailGridView.m
//  
//
//  Created by Vinay Chavan on 19/03/11.
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

#import "VCThumbnailGridView.h"

#import "VCThumbnailViewCell.h"

@interface VCThumbnailGridView()

@end

@implementation VCThumbnailGridView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize isEditing = _isEditing;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_delegate = nil;
		_dataSource = nil;
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		_tableView.clipsToBounds = NO;
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.rowHeight = 0;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:_tableView];
		
		_numberOfThumbnailsInRow = 1;
    }
    return self;
}

- (void)layoutSubviews {
	_tableView.frame = CGRectInset(self.bounds, 0, 2);
}

- (void)dealloc {
	[_tableView release], _tableView = nil;
    [super dealloc];
}


#pragma mark - Private Methods

- (void)didTapImageThumbnail:(VCThumbnailView*)imageView {
	if ([self.delegate respondsToSelector:@selector(thumbnailGridView:didSelectThumbnailAtIndex:)]) {
		[self.delegate thumbnailGridView:self didSelectThumbnailAtIndex:imageView.tag];
	}
}


#pragma mark - Public Methods

- (void)reloadData {
	if ([self.dataSource respondsToSelector:@selector(numberOfThumbnailsInThumbnailGridView:)]) {
		_numberOfThumbnails = [self.dataSource numberOfThumbnailsInThumbnailGridView:self];
	}
	_numberOfThumbnails = MAX(_numberOfThumbnails, 0);
	
	if ([self.dataSource respondsToSelector:@selector(numberOfThumbnailsInRowForThumbnailGridView:)]) {
		_numberOfThumbnailsInRow = [self.dataSource numberOfThumbnailsInRowForThumbnailGridView:self];
	}
	_numberOfThumbnailsInRow = MAX(_numberOfThumbnailsInRow, 1);
	
	CGFloat width = (320 - (4 * (_numberOfThumbnailsInRow+1))) / _numberOfThumbnailsInRow;
	_tableView.rowHeight = width + 4;
	
	[_tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[_tableView setEditing:editing animated:animated];
	_isEditing = editing;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if (_numberOfThumbnails == 0) return 0;
	if (_numberOfThumbnailsInRow == 0) return 0;
	
	NSInteger numberOfCells = _numberOfThumbnails / _numberOfThumbnailsInRow;
	if (_numberOfThumbnails % _numberOfThumbnailsInRow != 0) {
		numberOfCells += 1;
	}
	
    return numberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i", indexPath.row];
    
    VCThumbnailViewCell *cell = (VCThumbnailViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VCThumbnailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier thumbnailCount:_numberOfThumbnailsInRow] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		// Configure the cell...
		
		// Every row has a different identifier so we do not need to recofigure rows again on appear
		int indexOfImage = indexPath.row * _numberOfThumbnailsInRow;
		
		VCThumbnailView *thumbnail = nil;
		BOOL respondsToSelectorView = [self.dataSource respondsToSelector:@selector(thumbnailGridView:thumbnailViewAtIndex:)];
		for (int i = 0; i < _numberOfThumbnailsInRow; i++) {
			if (indexOfImage < _numberOfThumbnails) {
				// get or create thumbnail
				if (respondsToSelectorView) {
					thumbnail = [self.dataSource thumbnailGridView:self thumbnailViewAtIndex:indexOfImage];
				}
				if (thumbnail == nil) {
					thumbnail = [[[VCThumbnailView alloc] initWithFrame:CGRectZero] autorelease];
				}
				
				// set proerties
				thumbnail.tag = indexOfImage;
				[thumbnail addTarget:self withSelector:@selector(didTapImageThumbnail:)];
				[cell addSubview:thumbnail];
				[cell.thumbnails addObject:thumbnail];
				thumbnail.tag = indexOfImage++;
			}
			thumbnail = nil;
		}
    }
	
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

#pragma mark - Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;	
}

@end
