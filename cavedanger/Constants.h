//
//  Constants.h
//  cavedanger
//
//  Created by Sebastian Volland on 13.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 2,
	kTagAnimation1 = 3,
    kTagPlayer = 4,
    kTagText = 5
};

typedef enum {
    kGameObjectNone,
    kGameObjectPlayer,
    kGameObjectPlatform
} GameObjectType;