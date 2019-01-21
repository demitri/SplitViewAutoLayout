//
//  AppDelegate.m
//  AutoLayoutSplitView
//
//  Created by Demitri Muna on 12/30/13.
//

#import <Quartz/Quartz.h>
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"

@interface AppDelegate ()
{
	// remember the width of the left pane before being collapsed (optional)
	CGFloat _lastLeftPaneWidth;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

	/*
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(splitViewDidResizeSubviews:)
			   name:NSSplitViewDidResizeSubviewsNotification
			 object:self.splitView];

	[nc addObserver:self
		   selector:@selector(splitViewWillResizeSubviews:)
			   name:NSSplitViewWillResizeSubviewsNotification
			 object:self.splitView];
	 */
}

- (void)awakeFromNib
{
	self.leftPane.translatesAutoresizingMaskIntoConstraints = NO;
	self.rightPane.translatesAutoresizingMaskIntoConstraints = NO;
	_lastLeftPaneWidth = self.leftPane.frame.size.width;
}

- (IBAction)loadPhoto:(id)sender
{
	// load photo
	NSURL *photoURL = [[NSBundle mainBundle] URLForResource:@"butterfly" withExtension:@"jpg"];
	NSImage *image = [[NSImage alloc] initWithContentsOfURL:photoURL];

	originalSize = image.size;
	
	NSRect imageRect = NSMakeRect(0, 0, image.size.width, image.size.height);
	NSImageView *imageView = [[NSImageView alloc] initWithFrame:imageRect];
	imageView.bounds = imageRect;
	imageView.image = image;
	
	// to pass to the bindings dictionary below - can't use dot notation (?)
	NSScrollView *scrollView = self.scrollView;
	
	scrollView.documentView = imageView;
	
	[self.middlePane addSubview:scrollView];

	// turn off autoresizing for scroll view
	scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSDictionary *views = NSDictionaryOfVariableBindings(scrollView);
	[self.middlePane addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
																					options:0
																					metrics:nil
																					  views:views]];
	[self.middlePane addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|"
																					options:0
																					metrics:nil
																					  views:views]];
}

- (IBAction)toggleLeftPane:(id)sender
{
	[NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
		context.allowsImplicitAnimation = YES;
		context.duration = 0.25; // seconds
		context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

		if ([self.splitView isSubviewCollapsed:self.leftPane]) {
			// -> expand
			[self.splitView setPosition:_lastLeftPaneWidth ofDividerAtIndex:0];
		} else {
			// <- collapse
			_lastLeftPaneWidth = self.leftPane.frame.size.width; //  remember current width to restore
			[self.splitView setPosition:0 ofDividerAtIndex:0];
		}
		
		[self.splitView layoutSubtreeIfNeeded];
	}];
}

- (IBAction)toggleRightPane:(id)sender
{
	[NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
		context.allowsImplicitAnimation = YES;
		context.duration = 0.25; // seconds
		context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		
		if ([self.splitView isSubviewCollapsed:self.rightPane]) {
			// -> expand
			[self.splitView setPosition:NSMaxX(self.splitView.frame) - self.rightPane.frame.size.width ofDividerAtIndex:1];
		} else {
			// <- collapse
			[self.splitView setPosition:NSMaxX(self.splitView.frame) ofDividerAtIndex:1];
		}
		
		[self.splitView layoutSubtreeIfNeeded];
	}];
}

/*
- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
	return;
}

- (void)splitViewWillResizeSubviews:(NSNotification *)aNotification
{
	return;
}
*/

#pragma mark - IBActions

- (IBAction)sliderAction:(id)sender
{
	//DLog(@"scale factor: %f", self.slider.floatValue);
	float scaleFactor = self.slider.floatValue;
	
	self.scrollView.magnification = scaleFactor;
	
	//NSRect docFrame = self.scrollView.documentView.frame;
	//[self.scrollView setMagnification:scaleFactor centeredAtPoint:NSMakePoint(NSMidX(docFrame), NSMidY(docFrame))];
	
	self.scrollView.contentView.needsDisplay = YES;
}

#pragma mark NSSplitViewDelegate methods

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
	if (subview == self.leftPane) {
		return YES;
	}
	else if (subview == self.rightPane)
		return YES;
	
	return NO;
}

@end
