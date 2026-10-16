//
//  FLEXManager+NetworkTransactions.m
//  FLEX
//
//  Created by Duygu Batkan on 7.10.2026.
//  Copyright © 2026 FLEX Team. All rights reserved.
//

#import "FLEXManager+NetworkTransactions.h"
#import "FLEXNetworkRecorder.h"
#import "FLEXNetworkTransaction.h"

@interface FLEXNetworkTransactionRecord ()
@property (nonatomic, readwrite, copy) NSString *requestID;
@property (nonatomic, readwrite) NSDate *startTime;
@property (nonatomic, readwrite) NSTimeInterval latency;
@property (nonatomic, readwrite) NSTimeInterval duration;
@property (nonatomic, readwrite) BOOL isComplete;
@property (nonatomic, readwrite, copy) NSString *method;
@property (nonatomic, readwrite, copy) NSString *urlString;
@property (nonatomic, readwrite, copy) NSDictionary<NSString *, NSString *> *requestHeaders;
@property (nonatomic, readwrite, copy, nullable) NSData *requestBody;
@property (nonatomic, readwrite) NSInteger statusCode;
@property (nonatomic, readwrite, copy) NSDictionary<NSString *, NSString *> *responseHeaders;
@property (nonatomic, readwrite, copy, nullable) NSString *MIMEType;
@property (nonatomic, readwrite, copy, nullable) NSData *responseBody;
@property (nonatomic, readwrite) int64_t receivedDataLength;
@property (nonatomic, readwrite, copy, nullable) NSString *errorDomain;
@property (nonatomic, readwrite) NSInteger errorCode;
@property (nonatomic, readwrite, copy, nullable) NSString *errorDescription;
@end

@implementation FLEXNetworkTransactionRecord
@end

@implementation FLEXManager (NetworkTransactions)

- (NSArray<FLEXNetworkTransactionRecord *> *)networkTransactionsStartedAfter:(NSDate *)date {
    FLEXNetworkRecorder *recorder = FLEXNetworkRecorder.defaultRecorder;
    NSMutableArray<FLEXNetworkTransactionRecord *> *records = [NSMutableArray new];
    for (FLEXHTTPTransaction *transaction in recorder.HTTPTransactions.reverseObjectEnumerator) {
        NSDate *startTime = transaction.startTime;
        if (startTime == nil || [startTime compare:date] == NSOrderedAscending) {
            continue;
        }

        FLEXNetworkTransactionRecord *record = [FLEXNetworkTransactionRecord new];
        record.requestID = transaction.requestID ?: @"";
        record.startTime = startTime;
        record.latency = transaction.latency;
        record.duration = transaction.duration;
        record.isComplete = transaction.state == FLEXNetworkTransactionStateFinished
            || transaction.state == FLEXNetworkTransactionStateFailed;
        record.method = transaction.request.HTTPMethod ?: @"GET";
        record.urlString = transaction.request.URL.absoluteString ?: @"-";
        record.requestHeaders = transaction.request.allHTTPHeaderFields ?: @{};
        record.requestBody = transaction.cachedRequestBody;
        record.receivedDataLength = transaction.receivedDataLength;
        record.MIMEType = transaction.response.MIMEType;
        record.responseHeaders = @{};
        if ([transaction.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)transaction.response;
            record.statusCode = response.statusCode;
            NSMutableDictionary<NSString *, NSString *> *headers = [NSMutableDictionary new];
            [response.allHeaderFields enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
                headers[[key description]] = [value description];
            }];
            record.responseHeaders = headers;
        }
        if (record.isComplete) {
            record.responseBody = [recorder cachedResponseBodyForTransaction:transaction];
        }
        NSError *error = transaction.error;
        if (error != nil) {
            record.errorDomain = error.domain;
            record.errorCode = error.code;
            record.errorDescription = error.localizedDescription;
        }
        [records addObject:record];
    }
    return records;
}

@end
