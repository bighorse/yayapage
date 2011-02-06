//
//  ContactListTableViewController.m
//
//

#import "ContactListTableViewController.h"
#import "TagListTableViewController.h"

@interface ContactListTableViewController()
@property (retain) NSMutableDictionary *usernames;
@property (retain) NSArray *sections;
@end

@implementation ContactListTableViewController

@synthesize usernames, sections;

- (NSMutableDictionary *)usernames
{
	if (!usernames) {
		//NSURL *wordsURL = [NSURL URLWithString:@"http://cs193p.stanford.edu/vocabwords.txt"];
		//usernames = [[NSMutableDictionary dictionaryWithContentsOfURL:wordsURL] retain];
		NSArray *objArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects: @"29435289@N00",nil], [NSArray arrayWithObjects: @"mei", @"ma", nil], [NSArray arrayWithObjects: @"yaya",nil], nil];
		NSArray *keyArray = [NSArray arrayWithObjects:@"2", @"m", @"y", nil];
		usernames = [[NSMutableDictionary dictionaryWithObjects:objArray forKeys:keyArray] retain];
		
	}
	return usernames;
}

- (NSArray *)sections
{
	if (!sections) {
		sections = [[[self.usernames allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
	}
	return sections;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Contacts";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *itemsInSection = [self.usernames objectForKey:[self.sections objectAtIndex:section]];
	return itemsInSection.count;
}

- (NSString *)itemAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *itemsInSection = [self.usernames objectForKey:[self.sections objectAtIndex:indexPath.section]];
	return [itemsInSection objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactListTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [self itemAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		NSString *section = [self.sections objectAtIndex:indexPath.section];
		NSMutableArray *wordsInSection = [[self.usernames objectForKey:section] mutableCopy];
		[wordsInSection removeObjectAtIndex:indexPath.row];
		[self.usernames setObject:wordsInSection forKey:section];
		[wordsInSection release];
		// Delete the row from the table view
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.sections objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return self.sections;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */

	TagListTableViewController *tltvc = [[TagListTableViewController alloc] init];
	tltvc.userName = [self itemAtIndexPath:indexPath];
    [self.navigationController pushViewController:tltvc animated:YES];
	[tltvc release];
	
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	[usernames release];
	[sections release];
    [super dealloc];
}

@end

