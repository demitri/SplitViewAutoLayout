//
//  AppDelegate.h
//  AutoLayoutSplitView
//
//  Created by Demitri Muna on 12/30/13.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSSplitViewDelegate>
{
	NSSize originalSize; // original values
}

@property (nonatomic, strong) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet NSSplitView *splitView;
@property (nonatomic, weak) IBOutlet NSView *leftPane;
@property (nonatomic, weak) IBOutlet NSView *middlePane;
@property (nonatomic, weak) IBOutlet NSView *rightPane;
@property (nonatomic, weak) IBOutlet NSSlider *slider;
@property (nonatomic, weak) IBOutlet NSScrollView *scrollView;

// layout constraints
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *splitViewLeadingConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *splitViewTrailingConstraint;

- (IBAction)toggleLeftPane:(id)sender;
- (IBAction)toggleRightPane:(id)sender;
- (IBAction)loadPhoto:(id)sender;
- (IBAction)sliderAction:(id)sender;

@end
