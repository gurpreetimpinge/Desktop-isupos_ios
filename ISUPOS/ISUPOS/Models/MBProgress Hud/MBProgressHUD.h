//
//  MBProgressHUD.h
//  Test App
//
//  Created by Gurpreet Singh on 5/23/14.
//  Copyright (c) 2014 Gurpreet Singh. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum
{
    MBProgressHUDModeIndeterminate,
    
	MBProgressHUDModeDeterminate,
	
	MBProgressHUDModeCustomView
} MBProgressHUDMode;

typedef enum
{
    MBProgressHUDAnimationFade,
   
    MBProgressHUDAnimationZoom
} MBProgressHUDAnimation;

@protocol MBProgressHUDDelegate <NSObject>

@required

- (void) hudWasHidden;

@end

@interface MBRoundProgressView : UIProgressView {}

- (id)initWithDefaultSize;

@end

@interface MBProgressHUD : UIView
{
	MBProgressHUDMode mode;

    MBProgressHUDAnimation animationType;
	
	SEL methodForExecution;

	id targetForExecution, objectForExecution;

	BOOL useAnimation, taskInProgress, isFinished, removeFromSuperViewOnHide;
	
    float yOffset, xOffset, width, height, margin, graceTime, minShowTime, progress, opacity;
	
    id <MBProgressHUDDelegate> delegate;
    
	NSTimer *graceTimer, *minShowTimer;

	NSDate *showStarted;
	
	UIView *indicator;

	UILabel *label, *detailsLabel;
	
	
	NSString *labelText, *detailsLabelText;

	UIFont *labelFont, *detailsLabelFont;

	UIView *customView;
	
	CGAffineTransform rotationTransform;
}

// Properties
@property (retain) UIView *customView;

@property (assign) MBProgressHUDMode mode;

@property (assign) MBProgressHUDAnimation animationType;

@property (assign) id <MBProgressHUDDelegate> delegate;

@property (copy) NSString *labelText, *detailsLabelText;

@property (assign) float opacity, xOffset, yOffset, margin, graceTime, minShowTime, progress, width, height;

@property (assign) BOOL taskInProgress, removeFromSuperViewOnHide;

@property (retain) UIFont *labelFont, *detailsLabelFont;

@property (retain) UIView *indicator;

@property (retain) NSTimer *graceTimer, *minShowTimer;

@property (retain) NSDate *showStarted;


+ (MBProgressHUD *) showHUDAddedTo:(UIView *) view animated:(BOOL) animated;

+ (BOOL) hideHUDForView:(UIView *) view animated:(BOOL) animated;

- (id) initWithWindow:(UIWindow *) window;

- (id) initWithView:(UIView *) view;

- (void) show:(BOOL) animated;

- (void) hide:(BOOL) animated;

- (void) showWhileExecuting:(SEL) method onTarget:(id) target withObject:(id) object animated:(BOOL) animated;

- (void) hideUsingAnimation:(BOOL) animated;

- (void) showUsingAnimation:(BOOL) animated;

- (void) fillRoundedRect:(CGRect) rect inContext:(CGContextRef) context;

- (void) done;

- (void) updateLabelText:(NSString *) newText;

- (void) updateDetailsLabelText:(NSString *) newText;

- (void) updateProgress;

- (void) updateIndicators;

- (void) handleGraceTimer:(NSTimer *) theTimer;

- (void) handleMinShowTimer:(NSTimer *) theTimer;

- (void) setTransformForCurrentOrientation:(BOOL) animated;


@end

