//
//  BubbleSphere.m
//  cc3_Newton
//
//  Created by 이 상찬 on 2014. 7. 22..
//  Copyright 2014년 이 상찬. All rights reserved.
//

#import "BubbleSphere.h"


@implementation BubbleSphere


+ (instancetype)bubbleSphereWithLetter:(NSString *)letter
{
    return([[BubbleSphere alloc] initWithLetter:letter]);
}

- (instancetype)initWithLetter:(NSString *)letter
{
    // Apple recommend assigning self with supers return value, and handling self not created
    self = [super init];
    if (!self) return(nil);
    
    // fist create a sphere with a letter
    _sphere = [CCSprite spriteWithImageNamed:@"bubble.png"];
    [self addChild:_sphere];
    
    CCLabelTTF *addedLabel = [CCLabelTTF labelWithString:letter fontName:@"Marker Felt" fontSize:48];
    addedLabel.position = ccp(self.position.x,self.position.y);
    [self addChild:addedLabel];
    
    // Give the sprite a physics body.
    // Use the content size from the sphere, and subtract NewtonSphereMargin (a constant), as the image we are using, has a transparent edge
    CCPhysicsBody *body = [CCPhysicsBody bodyWithCircleOfRadius:_sphere.contentSize.width * 0.5 andCenter:CGPointZero];
    
    // Assign the physics to our base node
    self.physicsBody = body;
    
    body.type = CCPhysicsBodyTypeDynamic;
    // Set the physics properties, trying to simulate a newtons cradle
    body.density = 1.0f;
    body.friction = 0.5f;
    body.elasticity = 1.0f;
    
    body.collisionType = @"sphere";
    // Assign the collision category
    // As you can assign several categories, this becomes an extremely flexible and clever way of filtering collisions.
    body.collisionCategories = @[@"sphere", @"outline"];
    
    // Spheres should collide with both other spheres, and the outline
    body.collisionMask = @[@"sphere", @"outline"];
    
    
    // enable touch for the sphere
    self.userInteractionEnabled = YES;
    return self;
}


- (void)dealloc
{
    CCLOG(@"A Newton Sphere was deallocated");
    // clean up code goes here, should there be any
    
}

// -----------------------------------------------------------------------
#pragma mark - Hit test override
// -----------------------------------------------------------------------

- (BOOL)hitTestWithWorldPos:(CGPoint)pos
{
    // The Newton Sphere is a compound physics object, and thus based on a CCNode.
    // Because of that, the object has no content size, and default touch registration will not work
    // Giving the node a content size, will ruin the compound placement.
    
    // To fix this, the hit test function is overridden.
    // As this is a simple sphere, the hit test will return YES, if the touch distance to sphere, is less than radius
    
    // get the position in the node
    CGPoint nodePos = [self convertToNodeSpace:pos];
    
    // calculate distance from touch to node center
    float distance = ccpLength(nodePos);
    return(distance < _sphere.contentSize.width * 0.5);
}

// -----------------------------------------------------------------------
#pragma mark - Touch implementation
// -----------------------------------------------------------------------

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // convert the touch into parents coordinate system
    // This is often the same as the world location, but if the scene is ex, scaled or offset, it might not be
    CGPoint parentPos = [_parent convertToNodeSpace:touch.locationInWorld];
    
    // The spehre was grabbed.
    // To move the sphere around in a "believeable" manner, two things has to be done
    // 1) the mass has to be increased, to simulate "an unstopable force" (please dont add an imovable object to the space, or chipmunk will crash ... no it wont :)
    self.physicsBody.mass = 100;
    
    // 2) Save state data, like time and position, so that a velocity can be calculated when moving the sphere.
    // Velocity must be set on forced movement, otherwise the collisions will feel "mushy"
    _grabbed = YES;
    _previousTime = event.timestamp;
    _previousPos = parentPos;
    CCLOG(@"A Newton Sphere was touched");
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // convert the touch into parents coordinate system
    // This is often the same as the world location, but if the scene is ex, scaled or offset, it might not be
    
    CGPoint parentPos = [_parent convertToNodeSpace:touch.locationInWorld];
    _previousVelocity = ccpMult(ccpSub(parentPos, _previousPos),10);
    _previousTime = event.timestamp;
    _previousPos = parentPos;
    
    //CCLOG(@"A Newton Sphere was moved : (%f,%f)",_previousPos.x,_previousPos.y);
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // if not grabbed anymore, return mass to normal
    _grabbed = NO;
    self.physicsBody.mass = 1;
    
    [self.physicsBody applyImpulse:_previousVelocity];
    
    CCLOG(@"A Newton Sphere was released");
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self touchEnded:touch withEvent:event];
}

// -----------------------------------------------------------------------
#pragma mark - Scheduled update
// -----------------------------------------------------------------------

- (void)update:(CCTime)delta
{
    // update needs not to be scheduled anymore. Just overriding update:, will automatically cause it to be called
    
    // if the sphere is grabbed, force it into position, and update its velocity.
    if (_grabbed)
    {
        self.position = _previousPos;
        self.physicsBody.velocity = CGPointZero;
    }
    
}



@end
