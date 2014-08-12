//
//  Obstacle.m
//  MGWUMinigameTemplate
//
//  Created by Michael Zamani on 8/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle

- (void) didLoadFromCCB {
    self.physicsBody.collisionType = @"obstacle";
}

@end
