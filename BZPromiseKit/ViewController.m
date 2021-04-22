//
//  ViewController.m
//  BZPromiseKit
//
//  Created by 夏和奇 on 2021/4/14.
//

#import "ViewController.h"
#import "BZPromise.h"
#import "BZResolver.h"
#import "BZPromise+Then.h"
#import "BZPromise+Done.h"
#import "BZPromise+Catch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self promise1]
    .then(^BZPromise* (NSString *v) {
        return [BZPromise promiseWithValue:[NSURL URLWithString:v]];
    })
    .done(^(NSURL *v) {
        NSLog(@"success url %@", v);
    })
    .catchOf(^(NSError *e) {
        NSLog(@"error e %@", e);
    });
}

- (BZPromise *)promise1 {
    return [BZPromise promiseWithResolver:^(BZResolver * _Nonnull resolver) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            resolver.fulfill(@"https://www.baidu.com");
            resolver.reject([NSError errorWithDomain:@"test.com" code:123 userInfo:nil]);
        });
    }];
}



@end
