//
//  SessionHandler.h
//  QJDlibFace
//
//  Created by Q14 on 2019/7/26.
//  Copyright © 2019 Gengmei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionHandler : NSObject

@property (nonatomic, strong) AVSampleBufferDisplayLayer *layer;

- (void)openSession;
@end

NS_ASSUME_NONNULL_END
