//
//  MGWUMinigameTemplate
//
//  Created by Zachary Barryte on 6/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MyCharacter.h"

@implementation MyCharacter {
    float _velYPrev; // this tracks the previous velocity, it's used for animation
    BOOL _isRunning; // these BOOLs track what animations have been triggered.  By default, they're set to NO
    BOOL _isJumping;
    BOOL _isFalling;
    BOOL _isLanding;
}

-(id)init {
    if ((self = [super init])) {
        // Initialize any arrays, dictionaries, etc in here
        
        // We initialize _isRunning to be YES, because we want the character to start idling
        // (Our animation code relies on this)
        _isRunning = YES;
        // by default, a BOOL's value is NO, so the other BOOLs are NO right now
    }
    return self;
}

-(void)didLoadFromCCB {
    // Set up anything connected to Sprite Builder here
    
    //[self performSelector:@selector(startRunningRight) withObject:nil];
    
}

-(void)startRunningRight {
    [self.animationManager runAnimationsForSequenceNamed:@"AnimSideWalking"];
}

-(void)onEnter {
    [super onEnter];
    // Create anything you'd like to draw here
}

-(void)update:(CCTime)delta {
    // Called each update cycle
    // n.b. Lag and other factors may cause it to be called more or less frequently on different devices or sessions
    // delta will tell you how much time has passed since the last cycle (in seconds)
    
    // This sample method is called every update to handle character animation
    [self updateAnimations:delta];
    
    CCLOG(@"Landing: %hhd", _isLanding);
    CCLOG(@"Falling: %hhd", _isFalling);
    CCLOG(@"Jumping: %hhd", _isJumping);
    CCLOG(@"Running: %hhd", _isRunning);
    CCLOG(@"VelYPrev: %f ;  Y Velocity %f", _velYPrev, self.physicsBody.velocity.y);
    CCLOG(@"%hhd %hhd %hhd %hhd", _velYPrev == 0.0, self.physicsBody.velocity.y == 0.0, !_isRunning, !_isFalling);
    
    if (_isRunning) {
        [self run];
    }
    
    
}

-(void)updateAnimations:(CCTime)delta {
    // RUN
    // The animation should be idle if the character was and is stationary
    // The character may only start idling if he or she was not already idling or falling
    
    if (_velYPrev == 0 && self.physicsBody.velocity.y == 0 && !_isRunning && !_isFalling) {
        [self resetBools];
        _isRunning = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideWalking"];
    }
    // JUMP
    // The animation should be jumping if the character wasn't moving up, but now is
    // The character may only start jumping if he or she was idling and isn't jumping
    else if (_velYPrev == 0 && self.physicsBody.velocity.y > 0 && _isRunning && !_isJumping) {
        [self resetBools];
        _isJumping = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideJump"];
    }
    // FALLING
    // The animation should be falling if the character's moving down, but was moving up or stalled
    // The character may only start falling if he or she was jumping and isn't falling
    else if (_velYPrev >= 0 && self.physicsBody.velocity.y < 0.0 && _isJumping && !_isFalling) {
        [self resetBools];
        _isFalling = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideFalling" tweenDuration:0.5f];
    }
    
    // LANDING
    // The animation sholud be landing if the character's stopped moving down (hit something)
    // The character may only start landing if he or she was falling and isn't landing
    else if (_velYPrev < 0 && self.physicsBody.velocity.y >= 0 && _isFalling && !_isLanding) {
        [self resetBools];
        _isLanding = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideLand"];
    }
    else if (_isLanding) {
        // Only here to deal with the wonky landing in mid-air error that occurs.
        [self resetBools];
        _isRunning = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideWalking"];
    }
    
    // We track the previous velocity, since it's important to determining how the character is and was moving for animations
    _velYPrev = self.physicsBody.velocity.y;
    
}

// This method is called before setting one to YES, so that only one is ever YES at a time
-(void)resetBools {
    _isRunning = NO;
    _isJumping = NO;
    _isFalling = NO;
    _isLanding = NO;
}

// This method tells the character to jump by giving it an upward velocity.
// It's been added to a physics node in the main scene, like the penguins Peeved Penguins, so it will fall automatically!
-(void)jump {
    self.physicsBody.velocity = ccp(200, 200);
}

-(void)run {
    self.physicsBody.velocity = ccp(200, 0);
}

@end
