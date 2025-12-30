//
//  OSETCustomerToSplashAdapter.m
//  YhsADSProject
//
//  Created by Shens on 20/3/2025.
//

#import "OSETCustomerToSplashAdapter.h"
#import "OSETSplashCustomEvent.h"


#import "OSETBiddingRequest.h"
#import "OSETBiddingManager.h"

#import <OSETSDK/OSETSDK.h>
@interface OSETCustomerToSplashAdapter ()
@property (nonatomic, strong) OSETSplashCustomEvent *customEvent;
@property (nonatomic, strong) OSETSplashAd *splashView;

@end
@implementation OSETCustomerToSplashAdapter

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
    NSTimeInterval tolerateTimeout = localInfo[kATSplashExtraTolerateTimeoutKey] ? [localInfo[kATSplashExtraTolerateTimeoutKey] doubleValue] : 5.0;
    if (tolerateTimeout > 0) {
        _customEvent = [[OSETSplashCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
        _customEvent.requestCompletionBlock = completion;
        OSETBiddingRequest *request = [[OSETBiddingManager sharedInstance] getRequestItemWithUnitID:serverInfo[@"unit_id"]];
        if (request) {
            if (request.customObject != nil) { // load secced
                self.splashView = request.customObject;
                self.splashView.delegate = _customEvent;
                [_customEvent trackSplashAdLoaded:self.splashView];
            } else { // fail
                NSError *error = [NSError errorWithDomain:ATADLoadingErrorDomain code:1013 userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long to load placement stragety."}];
                [_customEvent trackSplashAdLoadFailed:error];
            }
            [[OSETBiddingManager sharedInstance] removeRequestItmeWithUnitID:serverInfo[@"unit_id"]];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.splashView = [[OSETSplashAd alloc] initWithSlotId:serverInfo[@"unit_id"] window:nil bottomView:nil];
                self.splashView.delegate = self.customEvent;
                [self.splashView loadSplashAd];
            });
        }
    } else {
        completion(nil, [NSError errorWithDomain:ATADLoadingErrorDomain code:1013 userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long to load placement stragety."}]);
    }

}

//v 5.7.06 及以上版本中， splash 广告的 load 和 show 方法已经分开了
+ (void)showSplash:(ATSplash *)splash localInfo:(NSDictionary*)localInfo delegate:(id<ATSplashDelegate>)delegate {
    OSETSplashAd *splashView = splash.customObject;
    if (splashView) {
        UIWindow *window = localInfo[kATSplashExtraWindowKey];
        splashView.window = window;
        [splashView showSplashAd];
    }
}

+(BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary*)info{
    if(customObject && [customObject isKindOfClass:[OSETSplashAd class]]){
        OSETSplashAd *splashView = customObject;
        return splashView.isAdValid;
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

    OSETSplashAd *splash = [[OSETSplashAd alloc] initWithSlotId:info[@"unit_id"] window:nil bottomView:nil];
    request.customObject = splash;
    [biddingManage startWithRequestItem:request];
    dispatch_async(dispatch_get_main_queue(), ^{
        [splash loadSplashAd];
    });
}

+ (void) sendWinnerNotifyWithCustomObject:(id)customObject secondPrice:(NSString*)price userInfo:(NSDictionary<NSString *, NSString *> *)userInfo {
    NSLog(@"%s", __FUNCTION__);
}

+ (void)sendLossNotifyWithCustomObject:(nonnull id)customObject lossType:(ATBiddingLossType)lossType winPrice:(nonnull NSString *)price userInfo:(NSDictionary *)userInfo {
    NSLog(@"%s", __FUNCTION__);
}
@end
