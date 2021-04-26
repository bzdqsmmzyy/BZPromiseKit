//
//  BZBox.m
//  BZPromiseKit
//
//  Created by bzdqsmmz on 2021/4/14.
//

#import "BZBox.h"

@implementation BZBox

- (BZBoxSealantStatus)status {
    NSAssert(NO, nil);
    return BZBoxSealantStatusPending;
}

- (void (^)(id _Nullable))seal {
    return ^void (id v) {
        NSAssert(NO, nil);
    };
}

- (void (^)(BZPromiseValueHandle))append {
    return ^void (BZPromiseValueHandle handle) {
        NSAssert(NO, nil);
    };
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

- (BZBoxSealantStatus)status {
    return BZBoxSealantStatusResolved;
}
@end

@interface BZEmptyBox ()
@property (nonatomic, assign) BZBoxSealantStatus s;
@property (nonatomic, strong) id v;
@property (nonatomic, strong) NSMutableArray<BZPromiseValueHandle> *handles;
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

- (BZBoxSealantStatus)status {
    __block BZBoxSealantStatus s;
    dispatch_barrier_sync(self.barrier, ^{
        s = self.s;
    });
    return s;
}

- (void (^)(id _Nullable))seal {
    return ^void (id v) {
        __block NSArray *handlers = nil;
        dispatch_barrier_sync(self.barrier, ^{
            if (self.s == BZBoxSealantStatusResolved) {
                return;
            }
            handlers = [self.handles copy];
            self.s = BZBoxSealantStatusResolved;
            self.v = v;
        });
        
        if (handlers) {
            for (BZPromiseValueHandle handler in handlers) {
                handler(v);
            }
        }
    };
}


- (void (^)(BZPromiseValueHandle))append {
    return ^void (BZPromiseValueHandle handle) {
        dispatch_barrier_sync(self.barrier, ^{
            if (self.s == BZBoxSealantStatusPending && handle) {
                [self.handles addObject:handle];
            }
        });
    };
}
@end
