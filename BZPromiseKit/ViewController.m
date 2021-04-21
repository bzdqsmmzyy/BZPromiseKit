//
//  ViewController.m
//  BZPromiseKit
//
//  Created by 夏和奇 on 2021/4/14.
//

#import "ViewController.h"
#import "BZPromise.h"
#import "BZResolver.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_queue_t queue = dispatch_queue_create("bzpromise.kit", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 50; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_barrier_sync(queue, ^{
                NSLog(@"%@", [NSString stringWithFormat:@"~~~~~~ %d--1", i]);
            });
            
            dispatch_barrier_sync(queue, ^{
                NSLog(@"%@", [NSString stringWithFormat:@"~~~~~~ %d--2", i]);
            });
            
            dispatch_barrier_sync(queue, ^{
                NSLog(@"%@", [NSString stringWithFormat:@"~~~~~~ %d--3", i]);
            });
        });
    }
}


@end
