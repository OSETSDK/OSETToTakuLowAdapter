//
//  OSETInterstitialCustomEvent.m
//  YhsADSProject
//
//  Created by Shens on 21/3/2025.
//

#import "OSETInterstitialCustomEvent.h"

@implementation OSETInterstitialCustomEvent
- (NSString *)networkUnitId {
    return self.serverInfo[@"unit_id"];
}

- (void)interstitialDidReceiveSuccess:(nonnull id)interstitialAd slotId:(nonnull NSString *)slotId {
    [self trackInterstitialAdLoaded:interstitialAd adExtra:@{}];
}

- (void)interstitialLoadToFailed:(nonnull id)interstitialAd error:(nonnull NSError *)error {
    [self trackInterstitialAdLoadFailed:error];
}

- (void)interstitialDidClick:(nonnull id)interstitialAd {
    [self trackInterstitialAdClick];
}

- (void)interstitialDidClose:(nonnull id)interstitialAd {
    [self trackInterstitialAdClose:@{}];
}
- (void)interstitialExposured:(id)interstitialAd{
    [self trackInterstitialAdShow];
}
@end
