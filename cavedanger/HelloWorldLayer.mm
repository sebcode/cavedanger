//
//  HelloWorldLayer.mm
//  t6mb
//
//  Created by Ricardo Quesada on 3/24/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


#import "HelloWorldLayer.h"
#import "ContactListener.h"
#import "Constants.h"


// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        isDebug = FALSE;
        
        moveUp = FALSE;
        moveDown = FALSE;
        moveLeft = FALSE;
        moveRight = FALSE;
        
		// enable touches
		self.isMouseEnabled = YES;
        
        self.isKeyboardEnabled = YES;
                
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -1.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
        
        contactListener = new ContactListener();
        world->SetContactListener(contactListener);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
//		flags += b2DebugDraw::e_jointBit;
//		flags += b2DebugDraw::e_aabbBit;
//		flags += b2DebugDraw::e_pairBit;
//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);		
		
		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
        float wwidth = 1024;
        float wheight = 1024;
        
		// bottom
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(wwidth/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);		
		// top
		groundBox.SetAsEdge(b2Vec2(0,wheight/PTM_RATIO), b2Vec2(wwidth/PTM_RATIO,wheight/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		// left
		groundBox.SetAsEdge(b2Vec2(0,wheight/PTM_RATIO), b2Vec2(0,0));
		groundBody->CreateFixture(&groundBox,0);
		// right
		groundBox.SetAsEdge(b2Vec2(wwidth/PTM_RATIO,wheight/PTM_RATIO), b2Vec2(wwidth/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);


		b2BodyDef levBodyDef;
		levBodyDef.position.Set(0, 0); // bottom-left corner
		levBody = world->CreateBody(&levBodyDef);
        

        #include "/tmp/level.inc"
        
        
        
        
        
        
        oldposx = -1;
        oldposy = -1;
        
        //[[GB2ShapeCache sharedShapeCache] addFixturesToBody:groundBody forShapeName:@"level1"];
        
        
        //CCSprite *mySprite = [CCSprite spriteWithFile:@"ufo.png"];
        //mySprite.anchorPoint = ccp(0, 0);
        //mySprite.position = ccp(winSize.width/2, winSize.height/2);
        //[self addChild: mySprite];
		//[self addChild:mySprite z:0 tag:kTagBatchNode];		
		//[self addNewSpriteWithCoords:ccp(screenSize.width/2, screenSize.height/2)];

		
        CCSprite *lev = [CCSprite spriteWithFile:@"level3.png"];
        //lev.anchorPoint = ccp(480.0/1024.0/2.0, 320/1024.0/2);
        lev.anchorPoint = ccp(0, 0);
        lev.position = ccp(0, 0);
        //lev.opacity = 100;
        [self addChild: lev];
        
		CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"ufo.png" capacity:150];
		[self addChild:batch z:0 tag:kTagBatchNode];
        [self addNewSpriteWithCoords:ccp(100, 120)];
        
        
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"x,y" fontName:@"Marker Felt" fontSize:16];
		[self addChild:label z:0 tag:kTagText];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( screenSize.width/2, screenSize.height-50);

		
        
        
        
		[self schedule: @selector(tick:)];
	}
	return self;
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
    if (isDebug) {
        world->DrawDebugData();
    }
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}

-(void) addNewSpriteWithCoords:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
//	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
//	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(0,0,28,12)];
	[batch addChild:sprite];
	
	sprite.position = ccp(p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;

	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
    bodyDef.fixedRotation = true;
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.2f, .1f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 5.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
    
    player = body;
}



-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			//myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}

    if (player) {
        float im = 0.05;

        CCSprite *myActor = (CCSprite*)player->GetUserData();

//        const b2Vec2 v = player->GetLinearVelocity();
//        float vx = v.x;
//        float vy = v.y;
//        if (vx > 0) vx *= 0.01;
//        if (vy > 0) vy *= 0.01;
//        player->SetLinearVelocity(b2Vec2(vx, vy));
        
        if (moveUp) {
            b2Vec2 impulse = b2Vec2(0.0f, im);
            player->ApplyLinearImpulse(impulse, player->GetWorldCenter());
        }
        
        if (moveDown) {
            b2Vec2 impulse = b2Vec2(0.0f, - im);
            player->ApplyLinearImpulse(impulse, player->GetWorldCenter());
        }
        
        if (moveLeft) {
            b2Vec2 impulse = b2Vec2(- im, 0.0f);
            player->ApplyLinearImpulse(impulse, player->GetWorldCenter());
            
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(0.1);
        }
        
        if (moveRight) {
            b2Vec2 impulse = b2Vec2(im, 0.0f);
            player->ApplyLinearImpulse(impulse, player->GetWorldCenter());
            
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(-0.1);
        }
        
        if (!moveLeft && !moveRight) {
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(0);            
        }
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;

        b2Vec2 pos = player->GetPosition();

        float x = position_.x;
        float y = position_.y;
        
        //CCLOG(@"Player %0.2f x %0.2f | %0.2f x %0.2f", pos.x * PTM_RATIO, pos.y * PTM_RATIO, screenSize.width / 2, screenSize.height / 2);
        
        if (pos.x * PTM_RATIO >= (screenSize.width / 2) && pos.x * PTM_RATIO <= 1024 - (screenSize.width / 2)) {
            x = -1 * pos.x * PTM_RATIO + (screenSize.width / 2);
        }
        
        if (pos.y * PTM_RATIO >= (screenSize.height / 2) && pos.y * PTM_RATIO <= 1024 - (screenSize.height / 2)) {
            y = -1 * pos.y * PTM_RATIO + (screenSize.height / 2);
        }
        
        CGPoint newPos = ccp(x, y);
        [self setPosition:newPos];        
    }
    
    CCLabelTTF *label = (CCLabelTTF*) [self getChildByTag:kTagText];
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    label.position = ccp((position_.x * -1) + screenSize.width / 2, (position_.y * -1) + screenSize.height - 50);
    NSString *s = [[NSString alloc] initWithFormat: @"%0.2fx%0.2f , %0.2fx%0.2f , %0.2fx%0.2f", mousex, mousey, position_.x, position_.y, mousexx, mouseyy];
    [label setString:s];
}

-(BOOL) ccKeyDown:(NSEvent *)event
{
//	NSString * character = [event characters];
//    unichar keyCode = [character characterAtIndex: 0];
    unsigned short keyCode = [event keyCode];
    
	if (keyCode == 126) { moveUp = TRUE; } // Up
	if (keyCode == 125) { moveDown = TRUE; } // Down
	if (keyCode == 123) { moveLeft = TRUE; } // Left
	if (keyCode == 124) { moveRight = TRUE; } // Right

	if (keyCode == 2) { isDebug = ! isDebug; } // 'd'    
    
	//NSLog(@"key down: %@", [event characters] );
	NSLog(@"key down: %u", keyCode);
	return YES;
}

-(BOOL) ccKeyUp:(NSEvent *)event
{
	//NSString * character = [event characters];
    //unichar keyCode = [character characterAtIndex: 0];
    unsigned short keyCode = [event keyCode];
    
	if (keyCode == 126) { moveUp = FALSE; } // Up
	if (keyCode == 125) { moveDown = FALSE; } // Down
	if (keyCode == 123) { moveLeft = FALSE; } // Left
	if (keyCode == 124) { moveRight = FALSE; } // Right

	//NSLog(@"key up: %@", [event characters] );
	//NSLog(@"key up: %u", keyCode);
	return YES;
}

- (BOOL) ccMouseMoved:(NSEvent *)event
{
	CGPoint loc = [(CCDirectorMac*)[CCDirector sharedDirector] convertEventToGL:event];

    mousex = loc.x;
    mousey = loc.y;
    
    mousexx = mousex + (position_.x * -1);
    mouseyy = mousey + (position_.y * -1);

    return YES;
}

- (BOOL) ccMouseDown:(NSEvent *)event
{
    CCLOG(@"POINT %0.2f x %0.2f", mousexx, mouseyy);

    float newposx = mousexx / PTM_RATIO;
    float newposy = mouseyy / PTM_RATIO;
    
    if (oldposx != -1 && oldposy != -1) {
        levBox.SetAsEdge(b2Vec2(oldposx, oldposy), b2Vec2(newposx, newposy));
        levBody->CreateFixture(&levBox,0);
    }
    
    oldposx = newposx;
    oldposy = newposy;

//    location.x = 300;
//    location.y = 400;
    
	//[self addNewSpriteWithCoords: location];
	//CCLOG(@"Go to %0.2f x %02.f", location.x, location.y);
    
    //[self.camera setCenterX:location.x centerY:location.y centerZ:0];
    //[self.camera setCenterX:location.x centerY:location.y centerZ:0];
    
	return YES;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
