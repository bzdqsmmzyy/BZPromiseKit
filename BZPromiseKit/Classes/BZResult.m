//
//  BZResult.m
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/22.
//

#import "BZResult.h"

@implementation BZResult
- (instancetype)initWithValue:(id)value {
    if (self = [super init]) {
        _type = BZResultTypeFulfilled;
        _value = value;
    }
    return self;
}
- (instancetype)initWithError:(NSError *)error {
    if (self = [super init]) {
        _type = BZResultTypeRejected;
        _error = error;
    }
    return self;
}

@end
