//
//  RootViewController.h
//  Demo
//
//  Created by Vinay Chavan on 26/06/11.
//  Copyright 2011 Vinay Chavan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VCThumbnailGridView.h"

@interface RootViewController : UIViewController <VCThumbnailGridViewDataSource, VCThumbnailGridViewDelegate> {
	VCThumbnailGridView *_gridView;
}

@end
