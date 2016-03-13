//  Created by Robert Pankrath on 13.03.16.
//  Copyright © 2016 Robert Pankrath. All rights reserved.

#import <ScreenSaver/ScreenSaver.h>
#import "Snake3D-Swift.h"
@import Snake;

@interface Snake3DView : ScreenSaverView

@property (nonatomic, strong) Game* game;
@property (nonatomic, strong) GameDrawer* gameDrawer;

@end
