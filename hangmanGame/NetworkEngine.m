//
//  NetworkEngine.m
//  hangmanGame
//
//  Created by BILLY HO on 3/19/15.
//  Copyright (c) 2015 BILLY HO. All rights reserved.
//

#import "NetworkEngine.h"

#define BASEURL @"https://strikingly-hangman.herokuapp.com/game/on"

@implementation NetworkEngine

+ (void)startGameWhenSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parameters = @{@"playerId": @"billyho92@foxmail.com", @"action":@"startGame"};
    
    
    [manager POST:BASEURL
       parameters:parameters
          success:successBlock
          failure:failureBlock];
}

+ (void)performAction:(NSString *)action
            sessionId:(NSString *)sessionId
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parameters = @{@"sessionId": sessionId, @"action":action};
    
    [manager POST:BASEURL
       parameters:parameters
          success:successBlock
          failure:failureBlock];
}

+ (void)guessWord:(NSString *)guessWord
        sessionId:(NSString *)sessionId
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parameters = @{@"sessionId": sessionId, @"action":@"guessWord", @"guess":guessWord};
    
    
    [manager POST:BASEURL
       parameters:parameters
          success:successBlock
          failure:failureBlock];
}


@end
