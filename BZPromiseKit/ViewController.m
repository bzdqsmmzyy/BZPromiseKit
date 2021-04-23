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
#import "BZPromise+Map.h"
#import "BZPromise+Catch.h"
#import "BZPromise+Firstly.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushNext) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [button.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    firstly(^BZPromise *{
        return [self promise1];
    })
    .then(^BZPromise * _Nonnull(id  _Nullable v) {
        return [self promise2:v];
    })
    .map(^id (NSString *v) {
        return [NSURL URLWithString:v];
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
            resolver.fulfill(@"https://www.baidu.com");
        });
    }];
}

- (BZPromise *)promise2:(NSString *)string {
    return [BZPromise promiseWithResolver:^(BZResolver * _Nonnull resolver) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            resolver.fulfill([NSString stringWithFormat:@"%@?a=abc", string]);
        });
    }];
}

- (void)dealloc {
    NSLog(@"vc dealloc");
}


- (void)pushNext {
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
