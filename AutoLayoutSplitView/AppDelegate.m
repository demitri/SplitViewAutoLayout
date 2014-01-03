//
//  AppDelegate.m
//  AutoLayoutSplitView
//
//  Created by Demitri Muna on 12/30/13.
//

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
	
	// add constraints to center the document view in scroll view
	NSView *documentSuperview = [self.scrollView.documentView superview];
	[(NSView*)self.scrollView.documentView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[documentSuperview addConstraint:[NSLayoutConstraint constraintWithItem:documentSuperview
																  attribute:NSLayoutAttributeCenterX
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self.scrollView.documentView
																  attribute:NSLayoutAttributeCenterX
																 multiplier:1
																   constant:0]];

	[documentSuperview addConstraint:[NSLayoutConstraint constraintWithItem:documentSuperview
																  attribute:NSLayoutAttributeCenterY
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self.scrollView.documentView
																  attribute:NSLayoutAttributeCenterY
																 multiplier:1
																   constant:0]];

	NSImageView *documentView = (NSImageView*)self.scrollView.documentView;
	
/*
	[documentSuperview addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView.documentView
																  attribute:NSLayoutAttributeTop
																  relatedBy:NSLayoutRelationGreaterThanOrEqual
																	 toItem:self.scrollView.contentView
																  attribute:NSLayoutAttributeTop
																 multiplier:1
																   constant:0]];

	[documentSuperview addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView.documentView
																  attribute:NSLayoutAttributeBottom
																  relatedBy:NSLayoutRelationGreaterThanOrEqual
																	 toItem:self.scrollView.contentView
																  attribute:NSLayoutAttributeBottom
																 multiplier:1
																   constant:0]];

	[documentSuperview addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView.documentView
																  attribute:NSLayoutAttributeLeft
																  relatedBy:NSLayoutRelationGreaterThanOrEqual
																	 toItem:self.scrollView.contentView
																  attribute:NSLayoutAttributeLeft
																 multiplier:1
																   constant:0]];

	[documentSuperview addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView.documentView
																  attribute:NSLayoutAttributeRight
																  relatedBy:NSLayoutRelationGreaterThanOrEqual
																	 toItem:self.scrollView.contentView
																  attribute:NSLayoutAttributeRight
																 multiplier:1
																   constant:0]];
*/
	
	[documentSuperview addConstraint:[NSLayoutConstraint constraintWithItem:documentView
															 attribute:NSLayoutAttributeWidth
															 relatedBy:NSLayoutRelationGreaterThanOrEqual
																toItem:self.scrollView.contentView
															 attribute:NSLayoutAttributeWidth
															multiplier:1
															  constant:0]];
	
	[documentSuperview addConstraint:[NSLayoutConstraint constraintWithItem:documentView
															 attribute:NSLayoutAttributeHeight
															 relatedBy:NSLayoutRelationGreaterThanOrEqual
																toItem:self.scrollView.contentView
															 attribute:NSLayoutAttributeHeight
															multiplier:1
															  constant:0]];

	
	
	// add constraints to center the image view


}

- (IBAction)toggleLeftPane:(id)sender
{
	
}

- (IBAction)toggleRightPane:(id)sender
{
	
}

- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
	DLog(@"");
}


#pragma mark -
- (IBAction)sliderAction:(id)sender
{
	//DLog(@"scale factor: %f", self.slider.floatValue);
	float scaleFactor = self.slider.floatValue;
	NSImage *image = [(NSImageView*)self.scrollView.documentView image];
	NSSize newSize = NSMakeSize(originalSize.width * scaleFactor, originalSize.height * scaleFactor);
	[image setSize:newSize];
		
	self.scrollView.contentView.needsDisplay = YES;
}

@end
