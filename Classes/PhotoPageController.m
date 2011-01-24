/*
     File: PhoneContentController.m 
 Abstract: Content controller used to manage the iPhone user interface for this app. 
  Version: 1.4 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
 */

#import "PhotoPageController.h"
#import "PhotoViewController.h"
#import "JSON.h"
#import "FlickrAPIKey.h"

@interface PhotoPageController (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end


@implementation PhotoPageController

@synthesize scrollView, pageControl, viewControllers;


- (void)loadPhotosByTag
{
//    // Construct a Flickr API request.
//	// Important! Enter your Flickr API key in FlickrAPIKey.h
//    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&user_id=%@&tags=%@&format=json&nojsoncallback=1", FlickrAPIKey, userName, tagName];
//    NSURL *url = [NSURL URLWithString:urlString];
//	NSLog(@"urlString:%@", urlString);
//	
//    // Get the contents of the URL as a string, and parse the JSON into Foundation objects.
//    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//	NSLog(@"jsonString:%@", jsonString);
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
//        [photoURLs addObject:[NSURL URLWithString:photoURLString]];
//    }    
	for (int i = 0; i < 10; i++) {
		[photoNames addObject:[NSString stringWithFormat:@"photo%d", i]];
		if (i % 2 == 0) {
			[photoURLs addObject:[NSURL URLWithString:@"http://farm1.static.flickr.com/105/281854329_e4111b1922_z.jpg"]];
		} else {
			[photoURLs addObject:[NSURL URLWithString:@"http://farm2.static.flickr.com/1334/1376842596_d829582e76_z.jpg"]];
		}
		
	}
}

- (id)initWithUserName:(NSString *)user tagName:(NSString *)tag pageNumber:(int)page
{
	if (self =[super init]) {
		photoNames = [[NSMutableArray alloc] init];
		photoURLs = [[NSMutableArray alloc] init];
		userName = user;
		tagName = tag;
		pageNumber = page;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
 
	[self loadPhotosByTag];
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [photoNames count]; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [photoNames count], scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl.numberOfPages = [photoNames count];
    pageControl.currentPage = pageNumber;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:pageNumber - 1];
    [self loadScrollViewWithPage:pageNumber];
    [self loadScrollViewWithPage:pageNumber + 1];
	
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageNumber;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
	
	// update tilte and hide it
	self.title = [photoNames objectAtIndex:pageNumber];
	[[self.navigationController navigationBar] setHidden:YES];
	
	// add single tap gesture to show/hide navi bar
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	[scrollView addGestureRecognizer:singleTap];
	[singleTap release];
}

- (void)viewDidUnload {
	self.viewControllers = nil;
	self.scrollView = nil;
	self.pageControl = nil;
}

- (void)dealloc
{
    [viewControllers release];
    [scrollView release];
    [pageControl release];
	[photoURLs release];
    [photoNames release];

	
    [super dealloc];
}

//- (UIView *)view
//{
//    return self.scrollView;
//}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= [photoNames count])
        return;
    
    // replace the placeholder if necessary
    PhotoViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[PhotoViewController alloc] initWithPageNumber:page];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
        
		NSData *imageData = [NSData dataWithContentsOfURL:[photoURLs objectAtIndex:page]];
        controller.numberImage.image = [UIImage imageWithData:imageData];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
//    if (pageControlUsed)
//    {
//        // do nothing - the scroll was initiated from the page control, not the user dragging
//        return;
//    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	self.title = [photoNames objectAtIndex:page];

    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  //  pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  //  pageControlUsed = NO;
}

//- (IBAction)changePage:(id)sender
//{
//    int page = pageControl.currentPage;
//	
//    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    [self loadScrollViewWithPage:page - 1];
//    [self loadScrollViewWithPage:page];
//    [self loadScrollViewWithPage:page + 1];
//    
//	// update the scroll view to the appropriate page
//    CGRect frame = scrollView.frame;
//    frame.origin.x = frame.size.width * page;
//    frame.origin.y = 0;
//    [scrollView scrollRectToVisible:frame animated:YES];
//    
//	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
//    pageControlUsed = YES;
//}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
	UINavigationBar *navbar = [self.navigationController navigationBar];
	[navbar setHidden:!navbar.hidden];

}

@end
