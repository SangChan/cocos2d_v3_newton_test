//
//  Magnet.h
//  cc3_Newton
//
//  Created by SangChan on 2014. 7. 24..
//  Copyright 2014년 이 상찬. All rights reserved.
//

#import "cocos2d.h"

@interface Magnet : CCNode {
    BOOL _active;
    float _force;
    float _radius;
    NSString *_letter;
}

@property (nonatomic) NSMutableArray *magnetBodyList;

+ (instancetype)magnetWithLetter:(NSString *)letter;
+ (instancetype)magnetWithForce:(float)force Radius:(float)raidus Letter:(NSString *)letter;
- (instancetype)initWithForce:(float)force Radius:(float)raidus Letter:(NSString *)letter;


@end
