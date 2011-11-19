//
//  HelloWorldLayer.h
//  t6mb
//
//  Created by Ricardo Quesada on 3/24/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactListener.h"
#import "Constants.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    b2Body *player;
    
    b2Body* levBody;
    b2PolygonShape levBox;
    float oldposx, oldposy;
    
    float mousex, mousey;
    float mousexx, mouseyy;
    
    ContactListener *contactListener;
    
    BOOL isDebug;
    
    BOOL moveUp;
    BOOL moveDown;
    BOOL moveLeft;
    BOOL moveRight;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
