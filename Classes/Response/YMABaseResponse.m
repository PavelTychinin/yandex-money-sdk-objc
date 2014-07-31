//
// Created by Alexander Mertvetsov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseResponse.h"

static NSInteger const kResponseParseErrorCode = 2503;

@interface YMABaseResponse ()

@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) YMAResponseHandler block;

@end

@implementation YMABaseResponse

#pragma mark - Object Lifecycle

- (id)initWithData:(NSData *)data andCompletion:(YMAResponseHandler)block
{
    self = [self init];

    if (self != nil) {
        _data = data;
        _block = [block copy];
    }

    return self;
}

#pragma mark - NSOperation

- (void)main
{
    NSError *error;

    @try {
        id responseModel =
            [NSJSONSerialization JSONObjectWithData:_data options:(NSJSONReadingOptions)kNilOptions error:&error];

        if (error) {
            _block(self, error);
            return;
        }

        [self parseJSONModel:responseModel error:&error];
        _block(self, error);
    }
    @catch (NSException *exception) {
        _block(self, [NSError errorWithDomain:exception.name code:kResponseParseErrorCode userInfo:exception.userInfo]);
    }
}

#pragma mark - Public methods

- (void)parseJSONModel:(id)responseModel error:(NSError * __autoreleasing *)error
{
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end
