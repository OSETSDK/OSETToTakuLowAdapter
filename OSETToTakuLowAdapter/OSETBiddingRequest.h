//
//  OSETBiddingRequest.h
//  YhsADSProject
//
//  Created by Shens on 21/3/2025.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, OSETAdFormat) {
    OSETAdFormatSplash = 0,
    OSETAdFormatBanner = 1,
    OSETAdFormatInterstitial = 2,
    OSETAdFormatReward = 4,
    OSETAdFormatNative = 5,
};

@interface OSETBiddingRequest : NSObject
@property(nonatomic, strong) id customObject;

@property(nonatomic, strong) ATUnitGroupModel *unitGroup;

@property(nonatomic, strong) ATAdCustomEvent *customEvent;

@property(nonatomic, copy) NSString *unitID;
@property(nonatomic, copy) NSString *placementID;

@property(nonatomic, copy) NSDictionary *extraInfo;

@property(nonatomic, copy) void(^bidCompletion)(ATBidInfo * _Nullable bidInfo, NSError * _Nullable error);

@property(nonatomic, assign) OSETAdFormat adType;


@end

NS_ASSUME_NONNULL_END
