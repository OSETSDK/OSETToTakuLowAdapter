//
//  OSETNativeCustomRenderer.m
//  YhsADSProject
//
//  Created by Shens on 24/3/2025.
//

#import "OSETNativeCustomRenderer.h"
#import "OSETNativeCustomEvent.h"
#import <AnyThinkNative/ATNativeADCache.h>
@interface OSETNativeCustomRenderer()

@property (nonatomic, weak) OSETNativeCustomEvent * customEvent;
@property (nonatomic, strong) UIView * adView;

@end
@implementation OSETNativeCustomRenderer
/// 将资源渲染到相关的广告视图上。
/// 您可以根据广告平台的要求，做渲染之后再做一些注册点击事件的功能
- (void)renderOffer:(ATNativeADCache *)offer {
    [super renderOffer:offer];
    _customEvent = offer.assets[kATAdAssetsCustomEventKey];
    _customEvent.adView = self.ADView;
    self.ADView.customEvent = _customEvent;
    self.adView = offer.assets[kATAdAssetsCustomObjectKey];
    [self.ADView addSubview: self.adView];
}
/////// 如果广告形式存在MediaView，则需要实现createMediaView，以返回mediaview对象给到TopOn iOS SDK
//- (__kindof UIView*)getNetWorkMediaView {
//}
@end
