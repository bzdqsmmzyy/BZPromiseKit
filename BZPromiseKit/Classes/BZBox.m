//
//  BZBox.m
//  BZPromiseKit
//
//  Created by 夏和奇 on 2021/4/14.
//

#import "BZBox.h"

@implementation BZBox

- (BZBoxSealantStatus)inspectStatus {
    NSAssert(NO, nil);
    return BZBoxSealantStatusPending;
}

- (void)inspectStatus:(BZBoxSealantHandle)handle {
    NSAssert(NO, nil);
}

- (void)sealValue:(id)value {}
@end

@interface BZSealedBox ()
@property (nonatomic, strong) id v;
@end
@implementation BZSealedBox
- (instancetype)initWithValue:(id)value {
    if (self = [super init]) {
        self.v = value;
    }
    return self;
}

- (id)value {
    return self.v;
}

- (BZBoxSealantStatus)inspectStatus {
    return BZBoxSealantStatusResolved;
}
@end

@interface BZEmptyBox ()
@property (nonatomic, assign) BZBoxSealantStatus status;
@property (nonatomic, strong) id v;
@property (nonatomic, strong) NSMutableArray<BZBoxValueHandle> *handles;
@property (nonatomic, strong) dispatch_queue_t barrier;
@end
@implementation BZEmptyBox
- (instancetype)init {
    if (self = [super init]) {
        self.handles = [NSMutableArray array];
        self.barrier = dispatch_queue_create("com.bzpromisekit.barrier", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (id)value {
    __block id v = nil;
    dispatch_barrier_sync(self.barrier, ^{
        v = self.v;
    });
    return v;
}

- (void (^)(id _Nullable))seal {
    return ^void (id v) {
        __block NSArray *handlers = nil;
        dispatch_barrier_sync(self.barrier, ^{
            if (self.inspectStatus == BZBoxSealantStatusResolved) {
                return;
            }
            handlers = [self.handles copy];
            self.status = BZBoxSealantStatusResolved;
            self.v = v;
        });
        
        if (handlers) {
            for (BZBoxValueHandle handler in handlers) {
                handler(v);
            }
        }
    };
}

- (BZBoxSealantStatus)status {
    __block BZBoxSealantStatus status;
    dispatch_barrier_sync(self.barrier, ^{
        status = self.status;
    });
    return status;
}

- (void (^)(BZBoxValueHandle))append {
    return ^void (BZBoxValueHandle handle) {
        dispatch_barrier_sync(self.barrier, ^{
            if (self.status == BZBoxSealantStatusPending && handle) {
                [self.handles addObject:handle];
            }
        });
    };
}
@end
