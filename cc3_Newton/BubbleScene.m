//
//  BubbleScene.m
//  cc3_Newton
//
//  Created by 이 상찬 on 2014. 7. 21..
//  Copyright 2014년 이 상찬. All rights reserved.
//

#import "BubbleScene.h"


@implementation BubbleScene {
    CCPhysicsNode *_physics;
}

+ (instancetype)scene
{
    return [[self alloc] init];
}

- (instancetype)init
{
    // Apple recommend assigning self with supers return value, and handling self not created
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    CGPoint centerPos = ccp([CCDirector sharedDirector].viewSize.width * 0.5, [CCDirector sharedDirector].viewSize.height * 0.5);
    
    // Create a physics node, to hold all the spheres
    // This node is a physics node, so that you can add physics to the spheres
    _physics = [CCPhysicsNode node];
    _physics.gravity = NewtonGravity;
    //_physics.debugDraw = YES;
    [self addChild:_physics];
    
    CGRect worldRect = CGRectMake(0, 20, [CCDirector sharedDirector].viewSize.width, [CCDirector sharedDirector].viewSize.height-20);
    CCNode *outline = [CCNode node];
    outline.physicsBody = [CCPhysicsBody bodyWithPolylineFromRect:worldRect cornerRadius:0];
    outline.physicsBody.friction = NewtonOutlineFriction;
    outline.physicsBody.elasticity = NewtonOutlineElasticity;
    outline.physicsBody.collisionType = @"outline";
    outline.physicsBody.collisionCategories = @[NewtonSphereCollisionOutline];
    outline.physicsBody.collisionMask = @[NewtonSphereCollisionSphere];
    [_physics addChild:outline];
    
    BubbleSphere *sphere_a = [BubbleSphere bubbleSphereWithLetter:@"A"];//[NewtonSphere newtonSphereWithLetter:(NSString *)NewtonLetter[0]];
    sphere_a.position = ccp(centerPos.x-100, centerPos.y);
    [_physics addChild:sphere_a];
    
    Magnet *magnet_a = [Magnet magnetWithLetter:@"A"];
    magnet_a.position = ccp(centerPos.x-80, centerPos.y+180);
    [magnet_a.magnetBodyList addObject:sphere_a];
    [_physics addChild:magnet_a];
    
    BubbleSphere *sphere_b = [BubbleSphere bubbleSphereWithLetter:@"B"];//[NewtonSphere newtonSphereWithLetter:(NSString *)NewtonLetter[0]];
    sphere_b.position = ccp(centerPos.x, centerPos.y);
    [_physics addChild:sphere_b];
    
    Magnet *magnet_b = [Magnet magnetWithLetter:@"B"];
    magnet_b.position = ccp(centerPos.x, centerPos.y+180);
    [magnet_b.magnetBodyList addObject:sphere_b];
    [_physics addChild:magnet_b];

    
    BubbleSphere *sphere_c = [BubbleSphere bubbleSphereWithLetter:@"C"];//[NewtonSphere newtonSphereWithLetter:(NSString *)NewtonLetter[0]];
    sphere_c.position = ccp(centerPos.x+100, centerPos.y);
    [_physics addChild:sphere_c];
    
    Magnet *magnet_c = [Magnet magnetWithLetter:@"C"];
    magnet_c.position = ccp(centerPos.x+80, centerPos.y+180);
    [magnet_c.magnetBodyList addObject:sphere_c];
    [_physics addChild:magnet_c];

    
    self.userInteractionEnabled = YES;
    
    // done
    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Enter and Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
    // Basically this will result in fewer having the need to override onEnter and onExit, but for clarity, it is shown
}

- (void)onExit
{
    
    
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------

- (void)onEnterTransitionDidFinish
{
    // always call super onEnterTransitionDidFinish first
    [super onEnterTransitionDidFinish];
    
    
}

- (void)onExitTransitionDidStart
{
    
    
    // always call super onExitTransitionDidStart last
    [super onExitTransitionDidStart];
}


@end
