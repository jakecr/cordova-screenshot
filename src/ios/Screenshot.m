//
// Screenshot.h
//
// Created by Simon Madine on 29/04/2010.
// Copyright 2010 The Angry Robot Zombie Factory.
// - Converted to Cordova 1.6.1 by Josemando Sobral.
// MIT licensed
//
// Modifications to support orientation change by @ffd8
//

#import <Cordova/CDV.h>
#import "Screenshot.h"

@implementation Screenshot

@synthesize webView;

//- (void)saveScreenshot:(NSArray*)arguments withDict:(NSDictionary*)options

 - (void)saveScreenshot:(CDVInvokedUrlCommand*)command
{
	NSString *filename = [command.arguments objectAtIndex:2];
	NSNumber *quality = [command.arguments objectAtIndex:1];
	NSString *path = [NSString stringWithFormat:@"%@.jpg",filename];

	int x = [[command.arguments objectAtIndex:3] intValue];
	int y = [[command.arguments objectAtIndex:4] intValue];
	int width = [[command.arguments objectAtIndex:5] intValue];
	int height = [[command.arguments objectAtIndex:6] intValue];

	NSString *jpgPath = [NSTemporaryDirectory() stringByAppendingPathComponent:path ];

	CGRect imageRect;
	CGRect screenRect = [[UIScreen mainScreen] bounds];

	// statusBarOrientation is more reliable than UIDevice.orientation
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
		// landscape check
		if (width == 0)
			width = CGRectGetHeight(screenRect);
		if (height == 0)
			height = CGRectGetWidth(screenRect);
	} else {
		// portrait check
		if (width == 0)
			width = CGRectGetWidth(screenRect);
		if (height == 0)
			height = CGRectGetHeight(screenRect);
	}
	imageRect = CGRectMake(x, y, width, height);

	// Adds support for Retina Display. Code reverts back to original if iOs 4 not detected.
	if (NULL != UIGraphicsBeginImageContextWithOptions)
		UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, 0);
	else
		UIGraphicsBeginImageContext(imageRect.size);

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextTranslateCTM(ctx, -x, -y);
	CGContextFillRect(ctx, imageRect);

	[webView.layer renderInContext:ctx];

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	NSData *imageData = UIImageJPEGRepresentation(image,[quality floatValue]);
	[imageData writeToFile:jpgPath atomically:NO];

	UIGraphicsEndImageContext();

	CDVPluginResult* pluginResult = nil;
	NSDictionary *jsonObj = [ [NSDictionary alloc]
		initWithObjectsAndKeys :
		jpgPath, @"filePath",
		@"true", @"success",
		nil
		];

	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonObj];
	[self writeJavascript:[pluginResult toSuccessCallbackString:command.callbackId]];
}

@end
