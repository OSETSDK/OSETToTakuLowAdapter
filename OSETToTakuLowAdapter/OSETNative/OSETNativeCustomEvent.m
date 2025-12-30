//
//  OSETNativeCustomEvent.m
//  YhsADSProject
//
//  Created by Shens on 21/3/2025.
//

#import "OSETNativeCustomEvent.h"

@implementation OSETNativeCustomEvent
- (NSString *)networkUnitId {
    return self.serverInfo[@"unit_id"];
}
- (void)nativeExpressAdLoadSuccess:(NSArray *)nativeExpressViews{
    
    NSMutableArray<NSDictionary*>* assetArray = [NSMutableArray<NSDictionary*> array];
    NSMutableDictionary *assetDic = [NSMutableDictionary dictionary];
    [assetDic setValue:@(NO) forKey:kATNativeADAssetsIsExpressAdKey];
    [assetDic setValue:nativeExpressViews.firstObject forKey:kATAdAssetsCustomObjectKey];
    [assetArray addObject:assetDic];
    [self trackNativeAdLoaded:assetArray];
}

- (void)nativeExpressAdRenderSuccess:(id)nativeExpressView{
}
- (void)nativeExpressAdFailedToLoad:(nonnull id)nativeExpressAd error:(nonnull NSError *)error {
    [self trackNativeAdLoadFailed:error];
}
- (void)nativeExpressAdFailedToRender:(nonnull id)nativeExpressView {
}
- (void)nativeExpressAdDidClick:(nonnull id)nativeExpressView {
    [self trackNativeAdClick];
}
- (void)nativeExpressAdDidClose:(nonnull id)nativeExpressView {
    [self trackNativeAdClosed];
}
@end
