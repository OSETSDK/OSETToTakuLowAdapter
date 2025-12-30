//
//  OSETCustomerToRewardAdapter.m
//  YhsADSProject
//
//  Created by Shens on 20/3/2025.
//

#import "OSETCustomerToRewardAdapter.h"
#import "OSETRewardedVideoCustomEvent.h"


#import "OSETBiddingRequest.h"
#import "OSETBiddingManager.h"

#import <OSETSDK/OSETSDK.h>

@interface OSETCustomerToRewardAdapter ()
@property (nonatomic, strong) OSETRewardedVideoCustomEvent *customEvent;
@property (nonatomic, strong) OSETRewardVideoAd *rewardAd;

@end
@implementation OSETCustomerToRewardAdapter

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
    _customEvent = [[OSETRewardedVideoCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    _customEvent.requestCompletionBlock = completion;
    OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:serverInfo[@"unit_id"]];
    if (request) {
        if (request.customObject != nil) { // load secced
            self.rewardAd = request.customObject;
            self.rewardAd.delegate = _customEvent;
            [_customEvent trackRewardedVideoAdLoaded:self.rewardAd adExtra:@{}];
        } else { // fail
            NSError *error = [NSError errorWithDomain:ATADLoadingErrorDomain code:1013 userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long to load placement stragety."}];
            [_customEvent trackRewardedVideoAdLoadFailed:error];
        }
        [[OSETBiddingManager sharedInstance] removeRequestItmeWithUnitID:serverInfo[@"unit_id"]];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rewardAd = [[OSETRewardVideoAd alloc] initWithSlotId:serverInfo[@"unit_id"] withUserId:@""];
            self.rewardAd.delegate = self.customEvent;
            [self.rewardAd loadRewardAdData];
        });
    }
}

//v 5.7.06 及以上版本中， splash 广告的 load 和 show 方法已经分开了
+(void) showRewardedVideo:(ATRewardedVideo*)rewardedVideo inViewController:(UIViewController*)viewController delegate:(id)delegate {
    OSETRewardVideoAd *rewardAd = rewardedVideo.customObject;
    if (rewardAd) {
        [rewardAd showRewardFromRootViewController:viewController];
    }
}

+(BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary*)info{
    if(customObject && [customObject isKindOfClass:[OSETRewardVideoAd class]]){
        OSETRewardVideoAd *rewardAd = customObject;
        return rewardAd.isAdValid;
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

    OSETRewardVideoAd *splash = [[OSETRewardVideoAd alloc] initWithSlotId:info[@"unit_id"] withUserId:@""];
    request.customObject = splash;
    [biddingManage startWithRequestItem:request];
    dispatch_async(dispatch_get_main_queue(), ^{
        [splash loadRewardAdData];
    });
}

+ (void) sendWinnerNotifyWithCustomObject:(id)customObject secondPrice:(NSString*)price userInfo:(NSDictionary<NSString *, NSString *> *)userInfo {
}

+ (void)sendLossNotifyWithCustomObject:(nonnull id)customObject lossType:(ATBiddingLossType)lossType winPrice:(nonnull NSString *)price userInfo:(NSDictionary *)userInfo {
}
@end
