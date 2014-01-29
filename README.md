SplitViewAutoLayout
===================

This is a simple project to demonstrate how to use NSSplitView with Auto Layout. It consists of a three-paned view, where the middle pane contains an NSScrollView. Auto Layout is also used in the scroll view to center the document view.

Currently this is a work in progress.

##### Model

The layout is roughly analogous to how Xcode is laid out.

* left pane has a minimum width of 100, but can grow (e.g. source view)
* right pane is always fixed with a width of 150 (e.g. fixed inspector view)
* middle pane has minimum width of 50
* left and right panes can collapse either programmatically or via user dragging (i.e. classic NSSplitView behavior)
* the middle pane should be the most free to resize when the window is resized - the left pane should only be resized upon user interaction (manual resize or a button to collapse it)
* there are buttons to toggle the left and right panes, and a third to load content into the middle pane

##### Project Settings

Edit the project scheme and add this to "Arguments Passed on Launch".

    -NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints YES

##### Steps Performed in Interface Builder

* drag NSSplit view to window's view
* drag an NSView into the split view to create a third pane
* drag two buttons to the top of the view
* constrain the buttons to the top and left/right edges of the containing view
* constrain the widths of the buttons
* control-drag from split view to enclosing view in each direction to create four constraints to fill the view, leaving space for the toggle buttons
* add an identifier to each pane view (`leftView`, `middleView`, and `rightView`)
* select left pane, then Edit->Pin->Width, modify constraint created to a width of "greater than or equal" 100
* repeat with middle pane, modify constraint created to a width of "greater than or equal" 50
* select right pane, then Edit->Pin->Width, modify constraint created to a width of "greater than or equal" 100
* select the NSSplitView and change the holding priorities:
  * left pane: 255
  * middle pane: 250 (default)
  * right pane: 250 (default)
  
  
#### Troubleshooting

Initially I had this error upon running the application:

    Unsupported Configuration Content rectangle not entirely on screen with the menu bar ( May not be completely seen for all screen resolution and configurations)

This was corrected by selecting the window itself in the xib, then the Size Inspector, and moving the initial position of the window to be centered horizontally and vertically on the screen. Not sure what was going on there.

#### NSSplitView Delegate Methods

It’s important to note that if some of the `NSSplitView` delegate methods are used, the view will revert to the old springs and structs layout. When using Auto Layout, do not implement these methods:

    -splitView:constrainMinCoordinate:ofSubviewAt:
    -splitView:constrainMaxCoordinate:ofSubviewAt:
    -splitView:resizeSubviewsWithOldSize:
    -splitView:shouldAdjustSizeOfSubview:


#### Notes

The `NSScrollView` has a color background which is helpful for debugging.






