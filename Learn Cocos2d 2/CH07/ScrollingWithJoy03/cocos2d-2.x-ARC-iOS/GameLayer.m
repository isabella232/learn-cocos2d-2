//
//  GameScene.m
//  SpriteBatches
//
//  Created by Steffen Itterheim on 04.08.10.
//
//  Updated by Andreas Loew on 20.06.11:
//  * retina display
//  * framerate independency
//  * using TexturePacker http://www.texturepacker.com
//
//  Copyright Steffen Itterheim and Andreas Loew 2010-2011. 
//  All rights reserved.
//

#import "GameLayer.h"
#import "Ship.h"
#import "Bullet.h"
#import "ParallaxBackground.h"
#import "InputLayer.h"

@interface GameLayer (PrivateMethods)
-(void) countBullets:(ccTime)delta;
@end

@implementation GameLayer

static GameLayer* sharedGameLayer;
+(GameLayer*) sharedGameLayer
{
	NSAssert(sharedGameLayer != nil, @"GameScene instance not yet initialized!");
	return sharedGameLayer;
}

+(id) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
    InputLayer* inputLayer = [InputLayer node];
    [scene addChild:inputLayer z:1 tag:GameSceneLayerTagInput];
	return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
		sharedGameLayer = self;
		
		// if the background shines through we want to be able to see it!
		glClearColor(1, 1, 1, 1);

		// Load all of the game's artwork up front.
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"game-art.plist"];

		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		ParallaxBackground* background = [ParallaxBackground node];
		[self addChild:background z:-1];
		
		/*
        // add a background image
		CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"background.png"];
		background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
		[self addChild:background];
		*/
		
        // add the ship
		Ship* ship = [Ship ship];
		ship.position = CGPointMake(80, screenSize.height / 2);
		ship.tag = GameSceneNodeTagShip;
		[self addChild:ship z:10];
		
		// Now uses the image from the Texture Atlas.
		CCSpriteFrame* bulletFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bullet.png"];
		CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithTexture:bulletFrame.texture];
		[self addChild:batch z:1 tag:GameSceneNodeTagBulletSpriteBatch];

		// Create a number of bullets up front and re-use them whenever necessary.
		for (int i = 0; i < 400; i++)
		{
			Bullet* bullet = [Bullet bullet];
			bullet.visible = NO;
			[batch addChild:bullet];
		}
		
		// call bullet countrer from time to time
		[self schedule:@selector(countBullets:) interval:3];
	}
	return self;
}

-(void) dealloc
{
	sharedGameLayer = nil;
}

-(void) countBullets:(ccTime)delta
{
	CCLOG(@"Number of active Bullets: %i", self.bulletSpriteBatch.children.count);
}

-(CCSpriteBatchNode*) bulletSpriteBatch
{
	CCNode* node = [self getChildByTag:GameSceneNodeTagBulletSpriteBatch];
	NSAssert([node isKindOfClass:[CCSpriteBatchNode class]], @"not a CCSpriteBatchNode");
	return (CCSpriteBatchNode*)node;
}

-(void) shootBulletFromShip:(Ship*)ship
{
	CCArray* bullets = [self.bulletSpriteBatch children];
	
	CCNode* node = [bullets objectAtIndex:nextInactiveBullet];
	NSAssert([node isKindOfClass:[Bullet class]], @"not a bullet!");
	
	Bullet* bullet = (Bullet*)node;
	[bullet shootBulletFromShip:ship];
	
	nextInactiveBullet++;
	if (nextInactiveBullet >= bullets.count)
	{
		nextInactiveBullet = 0;
	}
}

-(Ship*) defaultShip
{
	CCNode* node = [self getChildByTag:GameSceneNodeTagShip];
	NSAssert([node isKindOfClass:[Ship class]], @"node is not a Ship!");
	return (Ship*)node;
}

@end
