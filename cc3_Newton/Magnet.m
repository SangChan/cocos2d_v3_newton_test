//
//  Magnet.m
//  cc3_Newton
//
//  Created by SangChan on 2014. 7. 24..
//  Copyright 2014년 이 상찬. All rights reserved.
//

#import "Magnet.h"


@implementation Magnet

@synthesize magnetBodyList;


+ (instancetype)magnetWithLetter:(NSString *)letter
{
    return [[Magnet alloc] initWithForce:5000000 Radius:150 Letter:(NSString *)letter];
}

+ (instancetype)magnetWithForce:(float)force Radius:(float)raidus Letter:(NSString *)letter
{
    return [[Magnet alloc] initWithForce:force Radius:raidus Letter:(NSString *)letter];
}

- (instancetype)initWithForce:(float)force Radius:(float)raidus Letter:(NSString *)letter
{
    self = [super init];
    if (!self) return(nil);
    
    magnetBodyList = [NSMutableArray array];
    _active = YES;
    _force = force;
    _radius = raidus;
    _letter = letter;
    
    CCLabelTTF *addedLabel = [CCLabelTTF labelWithString:_letter fontName:@"Marker Felt" fontSize:48];
    addedLabel.position = ccp(self.position.x,self.position.y);
    [self addChild:addedLabel];
    
    return self;
}

- (void)update:(CCTime)delta
{
    // update needs not to be scheduled anymore. Just overriding update:, will automatically cause it to be called
    
    // if the sphere is grabbed, force it into position, and update its velocity.
    
    if (_active) {
        for (CCNode *magnetBody in magnetBodyList) {
            CGPoint distance = ccpSub(self.position, magnetBody.position);
            CGFloat r = ccpDistance(self.position, magnetBody.position);
            //NSLog(@"name : %@ , distance : %f",_letter, r);
            if (r <= _radius) {
                if (r < 20) {
                    magnetBody.position = self.position;
                    magnetBody.physicsBody.velocity = CGPointZero;
                    magnetBody.physicsBody.angularVelocity = 0.0;
                    [magnetBody.physicsBody setSleeping:YES];
                    //CCActionRotateTo *rotateTo = [CCActionRotateTo actionWithDuration:1.0f angle:0.0];
                    //[magnetBody runAction:[CCActionRepeatForever actionWithAction:rotateTo]];
                }
                else {
                    CGPoint force = ccpMult([self normalize:distance], _force/(r*r));
                    [magnetBody.physicsBody applyForce:force];
                }
            }
        }
    }
    
}

- (CGPoint)normalize:(CGPoint)vector
{
    CGFloat length = sqrt(vector.x*vector.x +vector.y*vector.y);
    if (length < FLT_EPSILON)
    {
        return vector;
    }
    CGFloat invLength = 1.0f / length;
    vector.x *= invLength;
    vector.y *= invLength;
    
    return vector;
}

@end
