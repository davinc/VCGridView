//
//  VCGridViewCell.h
//  Demo
//
//  Created by Vinay Chavan on 07/08/12.
//
//  Copyright (C) 2012 by Vinay Chavan
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

#import <UIKit/UIKit.h>

@interface VCGridViewCell : UIView
{
@private
	UIView *_containerView;
	UIView *_contentView;
	UIView *_backgroundView;
	UIView *_highlightedBackgroundView;
	UIView *_editingSelectionOverlayView;

	struct {
        unsigned int highlighted:1;
        unsigned int selected:1;
        unsigned int editing:1;
    } _cellFlags;
}

@property (nonatomic, readonly, retain) UIView *contentView;
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIView *highlightedBackgroundView;
@property (nonatomic, retain) UIView *editingSelectionOverlayView;


@property (nonatomic, getter=isHighlighted) BOOL highlighted;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@property (nonatomic, getter=isSelected) BOOL selected;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@property (nonatomic, getter=isEditing) BOOL editing;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end

