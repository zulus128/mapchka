//
//  Common.m
//  Mapochka
//
//  Created by Oleg Kohtenko on 19.02.14.
//
//

#import "Common.h"
#import "ASIFormDataRequest.h"
#import "UIDevice+IdentifierAddition.h"

NSString * const CHILD_NAME = @"CHILD_NAME";
NSString * const CHILD_BIRTHDAY = @"CHILD_BIRTHDAY";
NSString * const CHILD_SEX = @"CHILD_SEX";

void MDLogEndTimedEvent(LOG_STORY story_id){
    NSData *data = [NSData dataWithContentsOfFile:cachesFullPath(@"unsentLogs.json")];
    NSMutableArray *array;
    if(data)
        array = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers
                                                  error:nil];
    else
        array = [NSMutableArray array];
    
    for (NSMutableDictionary *dict in array) {
        if([dict[@"story_id"] intValue] == story_id && [dict[@"isTimed"] boolValue]){
            [dict setObject:@([[NSDate date] timeIntervalSince1970] - [dict[@"date"] doubleValue])
                     forKey:@"duration"];
            [dict setObject:@NO forKey:@"isTimed"];
            break;
        }
    }
    
    [[NSJSONSerialization dataWithJSONObject:array options:0 error:nil] writeToFile:cachesFullPath(@"unsentLogs.json") atomically:YES];
}

void MDLogEvent(LOG_TYPE type, LOG_STORY story_id, BOOL isTimed){
    NSMutableArray *array;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:cachesFullPath(@"unsentLogs.json")])
        array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:cachesFullPath(@"unsentLogs.json")]
                                                options:NSJSONReadingMutableContainers
                                                  error:nil];
    else
        array = [NSMutableArray array];
    
    [array addObject:@{@"type" : @(type),
                       @"story_id" : @(story_id),
                       @"date" : @([[NSDate date] timeIntervalSince1970]),
                       @"duration" : @0,
                       @"isTimed" : @(isTimed)}];
    
    
    [[NSJSONSerialization dataWithJSONObject:array options:0 error:nil] writeToFile:cachesFullPath(@"unsentLogs.json") atomically:YES];
}

void MDSendCollectedLogs(){
    NSString *str = [NSString stringWithFormat:@"http://portal.moslight.com/mapochka/logEvents.php?id=%@",[[UIDevice currentDevice] uniqueDeviceIdentifier]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request addPostValue:[NSString stringWithContentsOfFile:cachesFullPath(@"unsentLogs.json")
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil]
                   forKey:@"events"];
    
    [request startAsynchronousWithcompletion:^(ASIHTTPRequest *requestInstance, NSData *responseData, NSError *error) {
        if(!error && responseData){
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            if([response[@"status"] intValue] == 1 && [response[@"response"] intValue] == 1){
                [[NSFileManager defaultManager] removeItemAtPath:cachesFullPath(@"unsentLogs.json") error:nil];
            }
        }
    }];
}