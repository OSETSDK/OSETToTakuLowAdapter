//
//  OSETSplashCustomEvent.m
//  YhsADSProject
//
//  Created by Shens on 20/3/2025.
//

#import "OSETSplashCustomEvent.h"

@implementation OSETSplashCustomEvent

- (NSString *)networkUnitId {
    return self.serverInfo[@"unit_id"];
}

- (void)removeCustomViewAndsplashAd:(OSETSplashAd *)splashAd {
    
    if (splashAd) {
        splashAd = nil;
    }
}

#pragma mark - OSETSplashAdDelegate

/// 开屏加载成功
/// @param splashAd 开屏实例
/// @param slotId 广告位ID
- (void)splashDidReceiveSuccess:(id)splashAd slotId:(NSString *)slotId{
    [self trackSplashAdLoaded:splashAd adExtra:nil];
}
/// 开屏加载失败
- (void)splashLoadToFailed:(id)splashAd error:(NSError *)error{
    [self trackSplashAdLoadFailed:error];
}
/// 开屏点击
- (void)splashDidClick:(id)splashAd{
    [self trackSplashAdClick];
}

/// 开屏关闭
- (void)splashDidClose:(id)splashAd{
    [self trackSplashAdClosed:nil];
}
/// 开屏将要关闭
- (void)splashWillClose:(id)splashAd{
    [self trackSplashAdWillClosed:@{}];
}
- (void)splashAdExposured:(id)splashAd{
    [self trackSplashAdShow];
}
@end
