//  Created by Robert Pankrath on 13.03.16.
//  Copyright © 2016 Robert Pankrath. All rights reserved.

#import "AppDelegate.h"
#import "Snake3DView.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) NSTimer *timer;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    Snake3DView *snakeView = [[Snake3DView alloc] initWithFrame:_window.contentView.bounds isPreview:false];
    [_window.contentView addSubview:snakeView];
    [snakeView startAnimation];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1/30. target:snakeView selector:@selector(animateOneFrame) userInfo:nil repeats:YES];
}

@end
