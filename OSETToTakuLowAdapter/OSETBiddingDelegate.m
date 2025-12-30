//
//  OSETBiddingDelegate.m
//  YhsADSProject
//
//  Created by Shens on 21/3/2025.
//

#import "OSETBiddingDelegate.h"
#import "OSETBiddingManager.h"
#import "OSETBiddingRequest.h"


#import <OSETSDK/OSETSDK.h>

#import <AnyThinkSplash/AnyThinkSplash.h>

@interface OSETBiddingDelegate ()<OSETSplashAdDelegate,OSETRewardVideoAdDelegate,OSETInterstitialAdDelegate,OSETNativeAdDelegate,OSETBannerAdDelegate>

@end
@implementation OSETBiddingDelegate
-(void)splashDidReceiveSuccess:(id)splashAd slotId:(NSString *)slotId{
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    
    if (request.bidCompletion) {
        NSString * price = @"0";
        if(splashAd && [splashAd isKindOfClass:[OSETSplashAd class]]){
            OSETSplashAd * s = splashAd;
            price = [NSString stringWithFormat:@"%ld",(long)s.eCPM];
        }
        ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:price currencyType:ATBiddingCurrencyTypeCNYCents expirationInterval:request.unitGroup.networkTimeout customObject:splashAd];
        request.bidCompletion(bidInfo, nil);
    }
    [[OSETBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];
}
-(void)splashLoadToFailed:(id)splashAd error:(NSError *)error{
    
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    if (request.bidCompletion) {
        request.bidCompletion(nil, error);
    }
    [[OSETBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];
}


- (void)rewardVideoDidReceiveSuccess:(nonnull id)rewardVideoAd slotId:(nonnull NSString *)slotId {
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    
    if (request.bidCompletion) {
        NSString * price = @"0";
        if(rewardVideoAd && [rewardVideoAd isKindOfClass:[OSETRewardVideoAd class]]){
            OSETRewardVideoAd * i = rewardVideoAd;
            price = [NSString stringWithFormat:@"%ld",(long)i.eCPM];
        }
        ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:price currencyType:ATBiddingCurrencyTypeCNYCents expirationInterval:request.unitGroup.networkTimeout customObject:rewardVideoAd];
        request.bidCompletion(bidInfo, nil);
    }
    [[OSETBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];

}
- (void)rewardVideoLoadToFailed:(nonnull id)rewardVideoAd error:(nonnull NSError *)error {
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    if (request.bidCompletion) {
        request.bidCompletion(nil, error);
    }
    [[OSETBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];
}

- (void)interstitialDidReceiveSuccess:(nonnull id)interstitialAd slotId:(nonnull NSString *)slotId {
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    
    if (request.bidCompletion) {
        NSString * price = @"0";
        if(interstitialAd && [interstitialAd isKindOfClass:[OSETInterstitialAd class]]){
            OSETInterstitialAd * i = interstitialAd;
            price = [NSString stringWithFormat:@"%ld",(long)i.eCPM];
        }
        ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:price currencyType:ATBiddingCurrencyTypeCNYCents expirationInterval:request.unitGroup.networkTimeout customObject:interstitialAd];
        request.bidCompletion(bidInfo, nil);
    }
    [[OSETBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];

}

- (void)interstitialLoadToFailed:(nonnull id)interstitialAd error:(nonnull NSError *)error {
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    if (request.bidCompletion) {
        request.bidCompletion(nil, error);
    }
    [[OSETBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];

}

- (void)nativeExpressAdLoadSuccessWithNative:(id)native nativeExpressViews:(NSArray *)nativeExpressViews{
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    if (request.bidCompletion) {
        NSString * price = @"0";
        if(nativeExpressViews && nativeExpressViews.count > 0){
            OSETBaseView * bv = nativeExpressViews.firstObject;
            price = [NSString stringWithFormat:@"%ld",(long)bv.eCPM];
        }
        ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:price currencyType:ATBiddingCurrencyTypeCNYCents expirationInterval:request.unitGroup.networkTimeout customObject:native];
        request.bidCompletion(bidInfo, nil);
    }
    [[OSETBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];
}

- (void)nativeExpressAdRenderSuccess:(id)nativeExpressView{

}
- (void)nativeExpressAdFailedToLoad:(nonnull id)nativeExpressAd error:(nonnull NSError *)error {
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    if (request.bidCompletion) {
        request.bidCompletion(nil, error);
    }
    [[OSETBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];

}

/// banner加载成功
/// @param bannerView banner实例
/// @param slotId 广告位ID
- (void)bannerDidReceiveSuccess:(id)bannerView slotId:(NSString *)slotId{
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    if (request.bidCompletion) {
        NSString * price = @"0";
        if(bannerView && [bannerView isKindOfClass:[OSETBaseView class]]){
            OSETBaseView * b = bannerView;
            price = [NSString stringWithFormat:@"%ld",(long)b.eCPM];
        }
        ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:price currencyType:ATBiddingCurrencyTypeCNYCents expirationInterval:request.unitGroup.networkTimeout customObject:bannerView];
        request.bidCompletion(bidInfo, nil);
    }
    [[OSETBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];

}

/// banner加载失败
- (void)bannerLoadToFailed:(id)bannerView error:(NSError *)error{
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    if (request.bidCompletion) {
        request.bidCompletion(nil, error);
    }
    [[OSETBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];

}

@end
