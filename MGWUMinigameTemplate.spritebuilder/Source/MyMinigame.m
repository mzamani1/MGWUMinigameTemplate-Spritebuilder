//
//  MGWUMinigameTemplate
//
//  Created by Zachary Barryte on 6/6/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "MyMinigame.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "MyCharacter.h"

@implementation MyMinigame {
    CCNode *_contentNode;
    CCPhysicsNode *_physicsNode;
    CCAction *_followCharacter;
}

-(id)init {
    if ((self = [super init])) {
        // Initialize any arrays, dictionaries, etc in here
        self.instructions = @"Make it to the end! Don't run into an obstacle. Tap to jump.";
    }
    return self;
}

- (void) followCharacter {
    self.position = ccp(0, 0);
    CCAction *follow = [CCActionFollow actionWithTarget:self.hero worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
}

-(void)didLoadFromCCB {
    // Set up anything connected to Sprite Builder here
    
    // We're calling a public method of the character that tells it to jump!
    
    _physicsNode.debugDraw = TRUE;
    _physicsNode.collisionDelegate = self;
    
    self.userInteractionEnabled = TRUE;
    _followCharacter = [CCActionFollow actionWithTarget:self.hero worldBoundary:self.boundingBox];
    [_contentNode runAction:_followCharacter];
}

-(void)onEnter {
    [super onEnter];
    // Create anything you'd like to draw here
}

-(void)update:(CCTime)delta {
    // Called each update cycle
    // n.b. Lag and other factors may cause it to be called more or less frequently on different devices or sessions
    // delta will tell you how much time has passed since the last cycle (in seconds)
}

- (void) ccPhysicsCollisionPostSolve: (CCPhysicsCollisionPair *)pair obstacle:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    [[_physicsNode space] addPostStepBlock:^{
        [self endMinigame];
    } key:nodeA];
}

-(void)endMinigame {
    // Be sure you call this method when you end your minigame!
    // Of course you won't have a random score, but your score *must* be between 1 and 100 inclusive
    [self endMinigameWithScore:arc4random()%100 + 1];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self.hero jump];
}

// DO NOT DELETE!
-(MyCharacter *)hero {
    return (MyCharacter *)self.character;
}
// DO NOT DELETE!

@end
