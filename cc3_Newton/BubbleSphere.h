//
//  BubbleSphere.h
//  cc3_Newton
//
//  Created by 이 상찬 on 2014. 7. 22..
//  Copyright 2014년 이 상찬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BubbleSphere : CCNode {
    BOOL _grabbed;
    NSTimeInterval _previousTime;
    CGPoint _previousVelocity;
    CGPoint _previousPos;
}

// -----------------------------------------------------------------------

@property (nonatomic, readonly) CCSprite *sphere;

// -----------------------------------------------------------------------

+ (instancetype)bubbleSphereWithLetter:(NSString *)letter;
- (instancetype)initWithLetter:(NSString *)letter;

// -----------------------------------------------------------------------

@end
