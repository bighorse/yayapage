//
//  MyTableViewController.h
//  MyTableView
//

#import <UIKit/UIKit.h>


@interface PhotoListTableViewController : UITableViewController {
    NSMutableArray *photoNames;
    NSMutableArray *photoURLs;
	NSString *userName;
	NSString *tagName;
}

@property (retain) NSString *userName;
@property (retain) NSString *tagName;

@end
