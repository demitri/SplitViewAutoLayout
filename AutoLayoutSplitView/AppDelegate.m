//
//  AppDelegate.m
//  AutoLayoutSplitView
//
//  Created by Demitri Muna on 12/30/13.
//

#import <Quartz/Quartz.h>
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(splitViewDidResizeSubviews:)
			   name:NSSplitViewDidResizeSubviewsNotification
			 object:self.splitView];
}

- (void)awakeFromNib
{

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
	// NOTE: The animation will only work if the split views and their children have
	//       "wantsLayer" set to YES - easiest done by checking the "Core Animation Layer" in the nib.
	
	// NOTE: The split view divider should have zero width, otherwise when it is slid out of view,
	//       the size can be changed by dragging the divider. This can be also avoided by returning NO for canCollapseSubview:
	
	if ([self.splitView isSubviewCollapsed:self.leftPane]) {
		// can manually collapse view, handle this case
		[self.splitView setPosition:self.leftPane.frame.size.width // view retains frame size when collapsed
				   ofDividerAtIndex:0];
	}
	else {
	
		[NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
			context.allowsImplicitAnimation = YES;
			context.duration = 0.25; // seconds
			context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
			
			if (self.splitViewLeadingConstraint.constant < 0) {
				// view is collapsed -> expand
				self.splitViewLeadingConstraint.constant = 0;
			} else {
				// view is visible -> collapse
				self.splitViewLeadingConstraint.constant = -self.leftPane.frame.size.width;
			}
			
			[self.splitView layoutSubtreeIfNeeded];
		}];
	}
}

- (IBAction)toggleRightPane:(id)sender
{
	if ([self.splitView isSubviewCollapsed:self.rightPane]) {
		// can manually collapse view, handle this case - can remove this condition by returning NO for canCollapseSubview:
		[self.splitView setPosition:NSMaxX(self.splitView.frame) - self.rightPane.frame.size.width // view retains frame size when collapsed
				   ofDividerAtIndex:1];
	} else {

		[NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
			context.allowsImplicitAnimation = YES;
			context.duration = 0.25; // seconds
			context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
			
			if (self.splitViewTrailingConstraint.constant > 0) {
				// pane collapsed -> expand
				self.splitViewTrailingConstraint.constant = 0;
			} else {
				// pane is visible -> collapse
				self.splitViewTrailingConstraint.constant = self.rightPane.frame.size.width * 2.0;
			}
			[self.splitView layoutSubtreeIfNeeded];
		}];
	}

}

- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
	DLog(@"");
}


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
	if (subview == self.leftPane)
		return YES;
	else if (subview == self.rightPane)
		return YES;
	
	return NO;
}

@end
