//
//  VCThumbnailGridView.m
//  
//
//  Created by Vinay Chavan on 19/03/11.
//  Copyright 2011 Vinay Chavan. All rights reserved.
//

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
		_tableView.rowHeight = 79; // 75 + 2 + 2
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:_tableView];
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

- (void)didTapImageThumbnail:(VCThumbnailButton*)imageView {
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
	
	[_tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[_tableView setEditing:editing animated:animated];
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
	NSInteger numberOfCells = _numberOfThumbnails / 4;
	if (_numberOfThumbnails % 4 != 0) {
		numberOfCells += 1;
	}
	
    return numberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i", indexPath.row];
    
    VCThumbnailViewCell *cell = (VCThumbnailViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VCThumbnailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
    // Configure the cell...
	NSInteger indexOfImage = indexPath.row * 4;
	if ([self.dataSource respondsToSelector:@selector(thumbnailGridView:imageAtIndex:)]) {
		if (indexOfImage < _numberOfThumbnails) {
			[cell.imageView1 setImage:[self.dataSource thumbnailGridView:self imageAtIndex:indexOfImage++]];
			cell.imageView1.tag = indexOfImage;
			[cell.imageView1 addTarget:self withSelector:@selector(didTapImageThumbnail:)];
		}
		if (indexOfImage < _numberOfThumbnails) {
			[cell.imageView2 setImage:[self.dataSource thumbnailGridView:self imageAtIndex:indexOfImage++]];
			cell.imageView2.tag = indexOfImage;
			[cell.imageView2 addTarget:self withSelector:@selector(didTapImageThumbnail:)];
		}
		if (indexOfImage < _numberOfThumbnails) {
			[cell.imageView3 setImage:[self.dataSource thumbnailGridView:self imageAtIndex:indexOfImage++]];
			cell.imageView3.tag = indexOfImage;
			[cell.imageView3 addTarget:self withSelector:@selector(didTapImageThumbnail:)];
		}
		if (indexOfImage < _numberOfThumbnails) {
			[cell.imageView4 setImage:[self.dataSource thumbnailGridView:self imageAtIndex:indexOfImage++]];
			cell.imageView4.tag = indexOfImage;
			[cell.imageView4 addTarget:self withSelector:@selector(didTapImageThumbnail:)];
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
