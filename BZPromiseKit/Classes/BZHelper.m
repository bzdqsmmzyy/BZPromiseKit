//
//  BZHelper.m
//  BZPromiseKit
//
//  Created by 夏和奇 on 2021/4/23.
//

#import "BZHelper.h"

void bz_nullable_queue_async(dispatch_queue_t queue, dispatch_block_t block) {
    if (queue) {
        dispatch_async(queue, block);
    }
    else {
        block();
    }
}
