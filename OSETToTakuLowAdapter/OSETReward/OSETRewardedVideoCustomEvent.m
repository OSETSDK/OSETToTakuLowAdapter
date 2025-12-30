//
//  OSETRewardedVideoCustomEvent.m
//  YhsADSProject
//
//  Created by Shens on 21/3/2025.
//

#import "OSETRewardedVideoCustomEvent.h"




@implementation OSETRewardedVideoCustomEvent
- (NSString *)networkUnitId {
    return self.serverInfo[@"unit_id"];
}

- (void)rewardVideoDidReceiveSuccess:(nonnull id)rewardVideoAd slotId:(nonnull NSString *)slotId {
    NSLog(@"OSETRewardedVideoCustomEvent - rewardVideoDidReceiveSuccess");
    [self trackRewardedVideoAdLoaded:rewardVideoAd adExtra:@{}];
}

- (void)rewardVideoLoadToFailed:(nonnull id)rewardVideoAd error:(nonnull NSError *)error {
    [self trackRewardedVideoAdLoadFailed:error];
}

- (void)rewardVideoDidClick:(nonnull id)rewardVideoAd {
    NSLog(@"trackRewardedVideoAdClick");
    [self trackRewardedVideoAdClick];
    
}

- (void)rewardVideoDidClose:(id)rewardVideoAd checkString:(NSString *)checkString{
    [self trackRewardedVideoAdCloseRewarded:YES extra:@{}];
    NSLog(@"trackRewardedVideoAdCloseRewarded");
}
//激励视频播放结束
- (void)rewardVideoPlayEnd:(id)rewardVideoAd  checkString:(NSString *)checkString{
    NSLog(@"trackRewardedVideoAdVideoEnd");
    [self trackRewardedVideoAdVideoEnd];
}

//激励视频开始播放
- (void)rewardVideoPlayStart:(id)rewardVideoAd checkString:(NSString *)checkString{
    NSLog(@"trackRewardedVideoAdVideoStart");
    [self trackRewardedVideoAdVideoStart];

}
//激励视频奖励
- (void)rewardVideoOnReward:(id)rewardVideoAd checkString:(NSString *)checkString{
    NSLog(@"trackRewardedVideoAdRewarded");
    [self trackRewardedVideoAdRewarded];
}
-(void)rewardVideoRequestOnReward:(id)rewardVideoAd checkString:(NSString *)checkString withRequsetData:(NSDictionary *)requsetData{

}
//激励视频播放出错
- (void)rewardVideoPlayError:(id)rewardVideoAd error:(NSError *)error{
}
@end
