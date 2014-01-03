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

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet NSSplitView *splitView;
@property (nonatomic, strong) IBOutlet NSView *leftPane;
@property (nonatomic, strong) IBOutlet NSView *middlePane;
@property (nonatomic, strong) IBOutlet NSView *rightPane;
@property (nonatomic, strong) IBOutlet NSSlider *slider;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *leftPaneWidthConstraint;

@property (nonatomic, strong) IBOutlet NSScrollView *scrollView;

- (IBAction)toggleLeftPane:(id)sender;
- (IBAction)toggleRightPane:(id)sender;
- (IBAction)loadPhoto:(id)sender;
- (IBAction)sliderAction:(id)sender;

@end
