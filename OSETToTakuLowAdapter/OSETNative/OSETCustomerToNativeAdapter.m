//
//  OSETCustomerToNativeAdapter.m
//  YhsADSProject
//
//  Created by Shens on 20/3/2025.
//

#import "OSETCustomerToNativeAdapter.h"
#import "OSETNativeCustomEvent.h"

#import "OSETNativeCustomRenderer.h"

#import "OSETBiddingRequest.h"
#import "OSETBiddingManager.h"

#import <OSETSDK/OSETSDK.h>

@interface OSETCustomerToNativeAdapter ()

@property (nonatomic, strong) OSETNativeCustomEvent *customEvent;
@property (nonatomic, strong) OSETNativeAd *nativeAd;

@end


@implementation OSETCustomerToNativeAdapter


///// 用于返回自定义Renderer类
+ (Class)rendererClass {
    return [OSETNativeCustomRenderer class];
}

-(instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
        if(![OSETManager checkConfigure]){
              dispatch_async(dispatch_get_main_queue(), ^{
                  [OSETManager configure:serverInfo[@"app_id"]];
              });
          }
    }
    return self;
}

- (void)loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    _customEvent = [[OSETNativeCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    _customEvent.requestCompletionBlock = completion;
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:serverInfo[@"unit_id"]];
    if (request) {
        if (request.customObject != nil) { // load secced
            self.nativeAd = request.customObject;
            self.nativeAd.delegate = _customEvent;
            NSMutableArray<NSDictionary*>* assetArray = [NSMutableArray<NSDictionary*> array];
            NSMutableDictionary *assetDic = [NSMutableDictionary dictionary];
            [assetDic setValue:_customEvent forKey:kATAdAssetsCustomEventKey];
            [assetDic setValue:@YES forKey:kATNativeADAssetsIsExpressAdKey];
            [assetDic setValue:self.nativeAd.currentArray.firstObject forKey:kATAdAssetsCustomObjectKey];
            [assetArray addObject:assetDic];
            [_customEvent trackNativeAdLoaded:assetArray];
        } else { // fail
            NSError *error = [NSError errorWithDomain:ATADLoadingErrorDomain code:1013 userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long to load placement stragety."}];
            [_customEvent trackNativeAdLoadFailed:error];
        }
        [[OSETBiddingManager sharedInstance] removeRequestItmeWithUnitID:serverInfo[@"unit_id"]];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nativeAd = [[OSETNativeAd alloc] initWithSlotId:serverInfo[@"unit_id"] size:CGSizeMake(0, 0) rootViewController:nil];
            self.nativeAd.delegate = self.customEvent;
            [self.nativeAd loadAdData];
        });
    }
}

+(BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary*)info{
    if(customObject && [customObject isKindOfClass:[OSETNativeAd class]]){
        OSETNativeAd *rewardAd = customObject;
        if(rewardAd.currentArray.count>0){
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isSupportAdType:(nonnull ATUnitGroupModel *)unitGroupModel {
    return YES;
}
#pragma mark - Header bidding
#pragma mark - c2s
+(void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    
    if(![OSETManager checkConfigure]){
          dispatch_async(dispatch_get_main_queue(), ^{
              [OSETManager configure:info[@"app_id"]];
          });
    }
    OSETBiddingManager *biddingManage = [OSETBiddingManager sharedInstance];
    OSETBiddingRequest *request = [OSETBiddingRequest new];
    request.unitGroup = unitGroupModel;
    request.placementID = placementModel.placementID;
    request.bidCompletion = completion;
    request.unitID = info[@"unit_id"];
    request.extraInfo = info;
    request.adType = OSETAdFormatSplash;

    OSETNativeAd *splash = [[OSETNativeAd alloc] initWithSlotId:info[@"unit_id"] size:CGSizeZero rootViewController:nil];
    request.customObject = splash;
    [biddingManage startWithRequestItem:request];
    dispatch_async(dispatch_get_main_queue(), ^{
        [splash loadAdData];
    });
}

+ (void) sendWinnerNotifyWithCustomObject:(id)customObject secondPrice:(NSString*)price userInfo:(NSDictionary<NSString *, NSString *> *)userInfo {
}

+ (void)sendLossNotifyWithCustomObject:(nonnull id)customObject lossType:(ATBiddingLossType)lossType winPrice:(nonnull NSString *)price userInfo:(NSDictionary *)userInfo {
}
@end
