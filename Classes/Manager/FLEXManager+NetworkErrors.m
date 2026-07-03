//
//  FLEXManager+NetworkErrors.m
//  FLEX
//
//  Created by Ata Etgi on 4.07.2026.
//  Copyright © 2026 FLEX Team. All rights reserved.
//

#import "FLEXManager+NetworkErrors.h"
#import "FLEXNetworkRecorder.h"
#import "FLEXNetworkTransaction.h"

@interface FLEXNetworkErrorRecord ()
@property (nonatomic, readwrite) NSDate *startTime;
@property (nonatomic, readwrite, copy) NSString *method;
@property (nonatomic, readwrite, copy) NSString *urlString;
@property (nonatomic, readwrite) NSInteger statusCode;
@property (nonatomic, readwrite, copy, nullable) NSString *errorDescription;
@end

@implementation FLEXNetworkErrorRecord
@end

@implementation FLEXManager (NetworkErrors)

- (NSArray<FLEXNetworkErrorRecord *> *)recentNetworkErrorsWithLimit:(NSUInteger)limit {
    NSMutableArray<FLEXNetworkErrorRecord *> *records = [NSMutableArray new];
    for (FLEXHTTPTransaction *transaction in FLEXNetworkRecorder.defaultRecorder.HTTPTransactions) {
        if (records.count >= limit) {
            break;
        }

        NSInteger statusCode = 0;
        if ([transaction.response isKindOfClass:[NSHTTPURLResponse class]]) {
            statusCode = ((NSHTTPURLResponse *)transaction.response).statusCode;
        }
        if (transaction.error == nil && statusCode < 400) {
            continue;
        }

        FLEXNetworkErrorRecord *record = [FLEXNetworkErrorRecord new];
        record.startTime = transaction.startTime ?: [NSDate date];
        record.method = transaction.request.HTTPMethod ?: @"GET";
        record.urlString = transaction.request.URL.absoluteString ?: @"-";
        record.statusCode = statusCode;
        record.errorDescription = transaction.error.localizedDescription;
        [records addObject:record];
    }
    return records;
}

@end
