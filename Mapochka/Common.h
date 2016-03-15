//
//  Common.h
//  Mapochka
//
//  Created by Oleg Kohtenko on 19.02.14.
//
//

#import <Foundation/Foundation.h>

extern NSString * const CHILD_NAME;
extern NSString * const CHILD_BIRTHDAY;
extern NSString * const CHILD_SEX;

typedef enum {
    LOG_TYPE_STORY,
    LOG_TYPE_OTHER
}LOG_TYPE;

typedef enum {
    LOG_GAME_BIRD_1,
    LOG_GAME_BIRD_2,
    LOG_GAME_BIRD_3,
    LOG_GAME_BIRD_4,
    LOG_GAME_BIRD_5,
    LOG_GAME_BIRD_6,
    LOG_GAME_CAT_1,
    LOG_GAME_CAT_2,
    LOG_GAME_CAT_3,
    LOG_GAME_CAT_4,
    LOG_GAME_CAT_5,
    LOG_GAME_TOILET_1,
    LOG_GAME_TOILET_2,
    LOG_GAME_TOILET_3,
    LOG_GAME_TOILET_4,
    LOG_GAME_TOILET_5,
    
    LOG_STORY_TOILET,
    LOG_STORY_CAT,
    LOG_STORY_BIRD,
    
    LOG_STORY_OTHER,
    
}LOG_STORY;


void MDLogEndTimedEvent(LOG_STORY story_id);
void MDLogEvent(LOG_TYPE type, LOG_STORY story_id, BOOL isTimed);
void MDSendCollectedLogs();