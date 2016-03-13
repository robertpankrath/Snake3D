//  Created by Robert Pankrath on 13.03.16.
//  Copyright © 2016 Robert Pankrath. All rights reserved.

#import "Snake3DView.h"

@implementation Snake3DView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
        [self startNewGame];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    [self.gameDrawer draw:self.game bounds:self.bounds];
}

- (void)animateOneFrame
{
    if (self.game.running) {
        [self.game update];
        [self setNeedsDisplay:YES];
    } else {
        [self startNewGame];
    }
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

- (void)startNewGame
{
    NSInteger fieldSize = 10 + random()%10;
    self.game = [[Game alloc] initWithDimension:3 fieldSize:fieldSize];
    self.gameDrawer = [[GameDrawer alloc] initWithFieldSize:fieldSize];
}

@end
