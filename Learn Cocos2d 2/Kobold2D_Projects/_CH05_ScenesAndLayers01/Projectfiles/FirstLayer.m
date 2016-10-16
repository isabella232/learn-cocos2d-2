//
//  FirstLayer.m
//  ScenesAndLayers01
//
//  Created by Steffen Itterheim on 27.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstLayer.h"
#import "SecondLayer.h"

@implementation FirstLayer

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	CCScene* scene = [CCScene node];
	FirstLayer* layer = [FirstLayer node];
	[scene addChild:layer];
	return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
		CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
		
		CCLabelTTF* label = [CCLabelTTF labelWithString:@"First Scene" fontName:@"Marker Felt" fontSize:64];
		label.color = ccGREEN;
		CGSize size = [CCDirector sharedDirector].winSize;
		label.position = CGPointMake(size.width / 2, size.height / 2);
		[self addChild:label];
		
		self.isTouchEnabled = YES;
		[self scheduleUpdate];
	}
	return self;
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

-(void) changeScene
{
	CCTransitionSlideInB* transition = [CCTransitionSlideInB transitionWithDuration:1.5f scene:[SecondLayer scene]];
	[[CCDirector sharedDirector] replaceScene:transition];
}

#if KK_PLATFORM_IOS
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self changeScene];
}
#endif

-(void) update:(ccTime)delta
{
	KKInput* input = [KKInput sharedInput];
	if (input.isAnyKeyDownThisFrame || input.isAnyMouseButtonDownThisFrame)
	{
		[self changeScene];
	}
}

-(void) onEnter
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	// must call super here:
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	// must call super here:
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	// must call super here:
	[super onExit];
}

-(void) onExitTransitionDidStart
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	// must call super here:
	[super onExitTransitionDidStart];
}

@end
