//
//  TagListTableViewController.h
//  yayapage
//
//  Created by 馬 広軍 on 11/01/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TagListTableViewController : UITableViewController {
	NSMutableArray *tagNames;
	NSString *userName;
}

@property (retain) NSString *userName;

@end
