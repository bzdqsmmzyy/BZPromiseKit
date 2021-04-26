//
//  BZPromise.m
//  BZPromiseKit
//
//  Created by bzdqsmmz on 2021/4/21.
//

#import "BZBox.h"
#import "BZResult.h"
#import "BZPromise.h"
#import "BZResolver.h"

@interface BZPromise ()
@property (nonatomic, strong) BZBox *box;
@end
@implementation BZPromise
+ (instancetype)promise {
    BZEmptyBox *box = [[BZEmptyBox alloc] init];
    return [[self alloc] initWithBox:box];
}
+ (instancetype)promiseWithValue:(id)value {
    BZResult *r = [[BZResult alloc] initWithValue:value];
    BZSealedBox *box = [[BZSealedBox alloc] initWithValue:r];
    return [[self alloc] initWithBox:box];
}

+ (instancetype)promiseWithError:(NSError *)error {
    BZResult *r = [[BZResult alloc] initWithError:error];
    BZSealedBox *box = [[BZSealedBox alloc] initWithValue:r];
    return [[self alloc] initWithBox:box];
}

+ (instancetype)promiseWithResolver:(void (^)(BZResolver * _Nonnull))body {
    BZEmptyBox *box = [[BZEmptyBox alloc] init];
    BZResolver *resolver = [[BZResolver alloc] initWithBox:box];
    !body ?: body(resolver);
    return [[self alloc] initWithBox:box];
}

- (instancetype)initWithBox:(BZBox *)box {
    if (self = [super init]) {
        _box = box;
    }
    return self;
}

- (BZResult *)result {
    switch (self.box.status) {
        case BZBoxSealantStatusPending:
            return nil;
        case BZBoxSealantStatusResolved:
            return self.box.value;
        default:
            break;
    }
    return nil;
}

- (void (^)(BZResult * _Nullable))seal {
    return ^void (BZResult *v) {
        if ([self.box isKindOfClass:[BZEmptyBox class]]) {
            BZEmptyBox *box = (BZEmptyBox *)self.box;
            box.seal(v);
        }
        else {
            NSAssert(NO, @"A BZSealedBox can't seal");
        }
    };
}
- (void (^)(BZPromisePipeBlock))pipe {
    return ^void (BZPromisePipeBlock to){
        switch (self.box.status) {
            case BZBoxSealantStatusPending:
                self.box.append(to);
                break;
            case BZBoxSealantStatusResolved:
                !to ?: to(self.box.value);
                break;
            default:
                break;
        }
    };
}
@end

void BZPNullableQueueAsync(dispatch_queue_t queue, dispatch_block_t block) {
    if (queue) {
        dispatch_async(queue, block);
    }
    else {
        !block ?: block();
    }
}

NSErrorDomain const BZPErrorDomian = @"com.bzpromisekit.domain";
