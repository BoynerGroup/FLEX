//
//  FLEXManager+NetworkTransactions.h
//  FLEX
//
//  Created by Duygu Batkan on 7.10.2026.
//  Copyright © 2026 FLEX Team. All rights reserved.
//

#import "FLEXManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLEXNetworkTransactionRecord : NSObject

@property (nonatomic, readonly, copy) NSString *requestID;
@property (nonatomic, readonly) NSDate *startTime;
@property (nonatomic, readonly) NSTimeInterval latency;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) BOOL isComplete;
@property (nonatomic, readonly, copy) NSString *method;
@property (nonatomic, readonly, copy) NSString *urlString;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> *requestHeaders;
@property (nonatomic, readonly, copy, nullable) NSData *requestBody;
/// 0 when no HTTP response was received (transport errors such as timeouts).
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> *responseHeaders;
@property (nonatomic, readonly, copy, nullable) NSString *MIMEType;
/// nil when the body was not cached (media types, cache purged under memory pressure).
@property (nonatomic, readonly, copy, nullable) NSData *responseBody;
@property (nonatomic, readonly) int64_t receivedDataLength;
@property (nonatomic, readonly, copy, nullable) NSString *errorDomain;
@property (nonatomic, readonly) NSInteger errorCode;
@property (nonatomic, readonly, copy, nullable) NSString *errorDescription;

@end

@interface FLEXManager (NetworkTransactions)

/// HTTP transactions recorded by the network observer that started at or after the given date,
/// oldest first. Requires network debugging to be enabled.
- (NSArray<FLEXNetworkTransactionRecord *> *)networkTransactionsStartedAfter:(NSDate *)date
    NS_SWIFT_NAME(networkTransactions(startedAfter:));

@end

NS_ASSUME_NONNULL_END
