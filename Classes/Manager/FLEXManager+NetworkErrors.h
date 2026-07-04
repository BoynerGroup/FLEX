//
//  FLEXManager+NetworkErrors.h
//  FLEX
//
//  Created by Ata Etgi on 4.07.2026.
//  Copyright © 2026 FLEX Team. All rights reserved.
//

#import "FLEXManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLEXNetworkErrorRecord : NSObject

@property (nonatomic, readonly) NSDate *startTime;
@property (nonatomic, readonly, copy) NSString *method;
@property (nonatomic, readonly, copy) NSString *urlString;
/// 0 when no HTTP response was received (transport errors such as timeouts).
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly, copy, nullable) NSString *errorDomain;
/// 0 when the transaction failed with an HTTP status instead of an NSError.
@property (nonatomic, readonly) NSInteger errorCode;
@property (nonatomic, readonly, copy, nullable) NSString *errorDescription;

@end

@interface FLEXManager (NetworkErrors)

/// Failed HTTP transactions (transport error or HTTP status >= 400) recorded
/// by the network observer, newest first. Requires network debugging to be enabled.
- (NSArray<FLEXNetworkErrorRecord *> *)recentNetworkErrorsWithLimit:(NSUInteger)limit
    NS_SWIFT_NAME(recentNetworkErrors(limit:));

@end

NS_ASSUME_NONNULL_END
