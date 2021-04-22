//
//  BZBox.h
//  BZPromiseKit
//
//  Created by 夏和奇 on 2021/4/14.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BZBoxSealantStatus) {
    BZBoxSealantStatusPending,
    BZBoxSealantStatusResolved
};

typedef void(^_Nonnull BZPromiseValueHandle)(id _Nullable v);

NS_ASSUME_NONNULL_BEGIN
@interface BZBox : NSObject
@property (nonatomic, readonly, nullable) id value;

@property (nonatomic, readonly) BZBoxSealantStatus status;

@property (nonatomic, readonly) void (^seal)(id _Nullable value);

@property (nonatomic, readonly) void (^append)(BZPromiseValueHandle);
@end

NS_ASSUME_NONNULL_END

@interface BZSealedBox : BZBox

- (instancetype _Nonnull )initWithValue:(id _Nullable)value;
@end


@interface BZEmptyBox : BZBox

@end
