//
//  FMCallback.h
//  FMEngine
//
//  Created by Nicolas Haunold on 5/2/09.
//  Copyright 2009 Tapolicious Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMCallback : NSObject {
	id __unsafe_unretained _target;
	SEL _selector;
	id __unsafe_unretained _userInfo;
	id __unsafe_unretained _identifier;
}

@property (nonatomic, assign) id __unsafe_unretained target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) id __unsafe_unretained userInfo;
@property (nonatomic, assign) id __unsafe_unretained identifier;

+ (id)callbackWithTarget:(id)target action:(SEL)action userInfo:(id)userInfo;
+ (id)callbackWithTarget:(id)target action:(SEL)action userInfo:(id)userInfo object:(id)identifier;
- (id)initWithTarget:(id)target action:(SEL)action userInfo:(id)userInfo;
- (id)initWithTarget:(id)target action:(SEL)action userInfo:(id)userInfo object:(id)identifier;
- (void)fire;

@end
