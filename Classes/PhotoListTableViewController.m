//
//  MyTableViewController.m
//  MyTableView
//

#import "PhotoListTableViewController.h"
#import "JSON.h"
#import "FlickrAPIKey.h"
#import "PhotoViewController.h"

// http://www.flickr.com/services/api/

@implementation PhotoListTableViewController

@synthesize userName;
@synthesize tagName;

- (void)loadPhotosByTag
{
//    // Construct a Flickr API request.
//	// Important! Enter your Flickr API key in FlickrAPIKey.h
//    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&user_id=%@&tags=%@&per_page=10&format=json&nojsoncallback=1", FlickrAPIKey, userName, tagName];
//    NSURL *url = [NSURL URLWithString:urlString];
//
//    // Get the contents of the URL as a string, and parse the JSON into Foundation objects.
//    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//
//    NSDictionary *results = [jsonString JSONValue];
//    
//    // Now we need to dig through the resulting objects.
//    // Read the documentation and make liberal use of the debugger or logs.
//    NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
//    for (NSDictionary *photo in photos) {
//        // Get the title for each photo
//        NSString *title = [photo objectForKey:@"title"];
//        [photoNames addObject:(title.length > 0 ? title : @"Untitled")];
//        
//        // Construct the URL for each photo.
//        NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
//		NSLog(@"%@", photoURLString);
//		[photoURLs addObject:[NSURL URLWithString:photoURLString]];
//    }
    
	for (int i = 0; i < 10; i++) {
		[photoNames addObject:[NSString stringWithFormat:@"photo%d", i]];
		if (i % 2 == 0) {
			[thumbURLs addObject:[NSURL URLWithString:@"http://farm1.static.flickr.com/105/281854329_e4111b1922_s.jpg"]];
			[photoURLs addObject:[NSURL URLWithString:@"http://farm1.static.flickr.com/105/281854329_e4111b1922_z.jpg"]];
		} else {
			[thumbURLs addObject:[NSURL URLWithString:@"http://farm2.static.flickr.com/1334/1376842596_d829582e76_s.jpg"]];
			[photoURLs addObject:[NSURL URLWithString:@"http://farm2.static.flickr.com/1334/1376842596_d829582e76_z.jpg"]];
		}

	}
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        thumbURLs = [[NSMutableArray alloc] init];
        photoURLs = [[NSMutableArray alloc] init];
        photoNames = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [thumbURLs release];
    [photoURLs release];
    [photoNames release];
	[userName release];
	[tagName release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    self.tableView.rowHeight = 95; // 75 pixel square image + 10 pixels of padding.
	self.title = @"Photos";
	[self loadPhotosByTag];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [photoNames count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *CellIdentifier = @"PhotoListTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
    cell.textLabel.text = [photoNames objectAtIndex:indexPath.row];    

    NSData *imageData = [NSData dataWithContentsOfURL:[thumbURLs objectAtIndex:indexPath.row]];
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	PhotoViewController *pvc = [[PhotoViewController alloc] init];
	pvc.photoNames = photoNames;
	pvc.photoURLs = photoURLs;
	pvc.pageNumber = indexPath.row;
    [self.navigationController pushViewController:pvc animated:YES];
	[pvc release];
	
}

@end
