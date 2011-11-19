//
//  ContactListener.mm
//  cavedanger
//
//  Created by Sebastian Volland on 13.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactListener.h"
#import "Constants.h"
#import "cocos2d.h"

#define IS_PLAYER(x, y)         (x.type == kGameObjectPlayer || y.tag == kTagPlayer)
#define IS_PLATFORM(x, y)       (x.type == kGameObjectPlatform || y.type == kGameObjectPlatform)


ContactListener::ContactListener() {
}

ContactListener::~ContactListener() {
}

void ContactListener::BeginContact(b2Contact *contact)
{
//	CCSprite *o1 = (CCSprite*)contact->GetFixtureA()->GetBody()->GetUserData();
//	CCSprite *o2 = (CCSprite*)contact->GetFixtureB()->GetBody()->GetUserData();
//	
//	if (IS_PLATFORM(o1, o2) && IS_PLAYER(o1, o2)) {
//        CCLOG(@"-----> Player made contact with platform!");
//    }
}

void ContactListener::EndContact(b2Contact *contact)
{
//	CCSprite *o1 = (GameObject*)contact->GetFixtureA()->GetBody()->GetUserData();
//	CCSprite *o2 = (GameObject*)contact->GetFixtureB()->GetBody()->GetUserData();
//    
//	if (IS_PLATFORM(o1, o2) && IS_PLAYER(o1, o2)) {
//        CCLOG(@"-----> Player lost contact with platform!");
//    }
}

void ContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold) {
}

void ContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse *impulse) {
}