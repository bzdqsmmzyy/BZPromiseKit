//
//  BZResolver.m
//  BZPromiseKit
//
//  Created by bzdqsmmz on 2021/4/21.
//

#import "BZResolver.h"
#import "BZBox.h"
#import "BZResult.h"

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
