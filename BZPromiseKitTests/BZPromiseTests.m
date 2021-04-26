//
//  BZPromiseTests.m
//  BZPromiseTests
//
//  Created by bzdqsmmz on 2021/4/14.
//

#import <XCTest/XCTest.h>
#import "BZPromiseKit.h"

@interface BZPromiseTests : XCTestCase

@end

@implementation BZPromiseTests

- (void)testThen {
    XCTestExpectation *ex1 = [[XCTestExpectation alloc] initWithDescription:@""];
    XCTestExpectation *ex2 = [[XCTestExpectation alloc] initWithDescription:@""];
    
    [BZPromise promiseWithValue:@(1)]
    .then(^BZPromise * _Nonnull(id  _Nullable v) {
        XCTAssertEqual(v, @(1));
        [ex1 fulfill];
        return [BZPromise promiseWithValue:@(2)];
    }).done(^void(id  _Nullable v) {
        XCTAssertEqual(v, @(2));
        [ex2 fulfill];
    });
    
    XCTWaiterResult r = [XCTWaiter waitForExpectations:@[ex1, ex2] timeout:10];
    XCTAssertEqual(r, XCTWaiterResultCompleted);
}

- (void)testMap {
    XCTestExpectation *ex = [[XCTestExpectation alloc] initWithDescription:@""];
    
    [BZPromise promiseWithValue:@(1)]
    .map(^id _Nullable(id  _Nullable v) {
        return @([v intValue] * 2);
    }).done(^(id  _Nullable v) {
        XCTAssertEqual(v, @(2));
        [ex fulfill];
    });
    XCTWaiterResult r = [XCTWaiter waitForExpectations:@[ex] timeout:10];
    XCTAssertEqual(r, XCTWaiterResultCompleted);
}

- (void)testError {
    XCTestExpectation *ex1 = [[XCTestExpectation alloc] initWithDescription:@""];
    XCTestExpectation *ex2 = [[XCTestExpectation alloc] initWithDescription:@""];
    
    NSError *rr = [NSError errorWithDomain:@"test.bzpromiseKit"
                                      code:15000
                                  userInfo:nil];
    [BZPromise promiseWithError:rr]
    .done(^(id  _Nullable v) {
        [ex1 fulfill];
    })
    .catchOf(^(NSError * _Nonnull e) {
        [ex2 fulfill];
        XCTAssertEqual(e.code, 15000);
    });
    XCTWaiterResult r1 = [XCTWaiter waitForExpectations:@[ex1] timeout:2];
    XCTWaiterResult r2 = [XCTWaiter waitForExpectations:@[ex2] timeout:2];
    
    XCTAssertEqual(r1, XCTWaiterResultTimedOut);
    XCTAssertEqual(r2, XCTWaiterResultCompleted);
}

- (void)testWhen {
    // 1、Empty
    XCTestExpectation *ex1 = [[XCTestExpectation alloc] initWithDescription:@""];
    NSArray *emptyArray = @[];
    BZPWhen(emptyArray).done(^(id  _Nullable v) {
        [ex1 fulfill];
    });
    XCTWaiterResult r1 = [XCTWaiter waitForExpectations:@[ex1] timeout:1];
    XCTAssertEqual(r1, XCTWaiterResultCompleted);
    
    // 2. Fufill
    XCTestExpectation *ex2 = [[XCTestExpectation alloc] initWithDescription:@""];
    BZPromise *p1 = [BZPromise promiseWithValue:@(1)];
    BZPromise *p2 = [BZPromise promiseWithValue:@(2)];
    BZPromise *p3 = [BZPromise promiseWithValue:@(3)];
    BZPromise *p4 = [BZPromise promiseWithValue:@(4)];
    BZPWhen(@[p1, p2, p3, p4]).done(^(NSArray *_Nullable x) {
        XCTAssertEqual(x[0], @1);
        XCTAssertEqual(x[1], @2);
        XCTAssertEqual(x[2], @3);
        XCTAssertEqual(x[3], @4);
        XCTAssertEqual(x.count, 4);
        [ex2 fulfill];
    });
    
    XCTWaiterResult r2 = [XCTWaiter waitForExpectations:@[ex2] timeout:1];
    XCTAssertEqual(r2, XCTWaiterResultCompleted);
    
    // 3. Rejected
    XCTestExpectation *ex3 = [[XCTestExpectation alloc] initWithDescription:@""];
    XCTestExpectation *ex4 = [[XCTestExpectation alloc] initWithDescription:@""];
    NSError *rr = [NSError errorWithDomain:@"test.bzpromiseKit"
                                      code:16000
                                  userInfo:nil];
    BZPWhen(@[p1, p2, p3, [BZPromise promiseWithError:rr]])
    .done(^(id  _Nullable v) {
        [ex3 fulfill];
    })
    .catchOf(^(NSError * _Nonnull e) {
        [ex4 fulfill];
        XCTAssertEqual(e.code, 16000);
    });
    XCTWaiterResult r3 = [XCTWaiter waitForExpectations:@[ex3] timeout:2];
    XCTWaiterResult r4 = [XCTWaiter waitForExpectations:@[ex4] timeout:2];
    
    XCTAssertEqual(r3, XCTWaiterResultTimedOut);
    XCTAssertEqual(r4, XCTWaiterResultCompleted);
}

- (void)testRace {
    BZPromise *p1 = BZAfter(0.1).then(^BZPromise * _Nonnull(id  _Nullable v) {
        return [BZPromise promiseWithValue:@(1)];
    });
    BZPromise *p2 = BZAfter(0.2).then(^BZPromise * _Nonnull(id  _Nullable v) {
        return [BZPromise promiseWithValue:@(2)];
    });
    
    XCTestExpectation *ex1 = [[XCTestExpectation alloc] initWithDescription:@""];
    BZPRace(@[p1, p2]).done(^(id  _Nullable v) {
        XCTAssertEqual(v, @1);
        [ex1 fulfill];
    });
    XCTWaiterResult r1 = [XCTWaiter waitForExpectations:@[ex1] timeout:1];
    XCTAssertEqual(r1, XCTWaiterResultCompleted);
    
    
    BZPromise *p3 = BZAfter(1).map(^id _Nonnull(id  _Nullable v) {
        return @3;
    });
    BZPromise *p4 = BZAfter(0.2).map(^id _Nonnull(id  _Nullable v) {
        return @4;
    });
    XCTestExpectation *ex2 = [[XCTestExpectation alloc] initWithDescription:@""];
    BZPRace(@[p3, p4]).done(^(id  _Nullable v) {
        XCTAssertEqual(v, @4);
        [ex2 fulfill];
    });
    XCTWaiterResult r2 = [XCTWaiter waitForExpectations:@[ex2] timeout:2];
    XCTAssertEqual(r2, XCTWaiterResultCompleted);
}
@end
