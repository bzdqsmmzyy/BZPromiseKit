//
//  BZResolver.m
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/21.
//

#import "BZResolver.h"
#import "BZBox.h"

@interface BZResolver ()
@property (nonatomic, strong) BZBox *box;
@end

@implementation BZResolver
- (instancetype)initWithBox:(BZBox *)box {
    if (self = [super init]) {
        self.box = box;
    }
    return self;
}
- (void)dealloc {
    if (self.box.status == BZBoxSealantStatusPending) {
        NSLog(@"BZPromiseKit: warning: pending promise deallocated");
    }
}

- (void (^)(id _Nullable))fulfill {
    return ^void (id v){
        BZResult *r = [[BZResult alloc] initWithValue:v];
        self.box.seal(r);
    };
}
- (void (^)(NSError * _Nonnull))reject {
    return ^void (NSError *e){
        BZResult *r = [[BZResult alloc] initWithError:e];
        self.box.seal(r);
    };
}
- (void (^)(BZResult * _Nonnull))resolve {
    return ^void (BZResult *r){
        self.box.seal(r);
    };
}
@end


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
