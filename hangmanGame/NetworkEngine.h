//
//  NetworkEngine.h
//  hangmanGame
//
//  Created by BILLY HO on 3/19/15.
//  Copyright (c) 2015 BILLY HO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkEngine : NSObject

+ (void)startGameWhenSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)performAction:(NSString *)action
            sessionId:(NSString *)sessionId
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)guessWord:(NSString *)guessWord
        sessionId:(NSString *)sessionId
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

@end
