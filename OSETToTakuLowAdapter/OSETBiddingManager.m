//
//  OSETBiddingManager.m
//  YhsADSProject
//
//  Created by Shens on 21/3/2025.
//

#import "OSETBiddingManager.h"
#import "OSETBiddingDelegate.h"

@interface OSETBiddingManager ()

@property (nonatomic, strong) NSMutableDictionary *bidingAdStorageAccessor;
@property (nonatomic, strong) NSMutableDictionary *bidingAdDelegate;

@end

@implementation OSETBiddingManager

+ (instancetype)sharedInstance {
    static OSETBiddingManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OSETBiddingManager alloc] init];
        sharedInstance.bidingAdStorageAccessor = [NSMutableDictionary dictionary];
        sharedInstance.bidingAdDelegate = [NSMutableDictionary dictionary];
    });
    return sharedInstance;
}

- (OSETBiddingRequest *)getRequestItemWithUnitID:(NSString *)unitID {
    @synchronized (self) {
        return [self.bidingAdStorageAccessor objectForKey:unitID];
    }
    
}

- (void)removeRequestItmeWithUnitID:(NSString *)unitID {
    @synchronized (self) {
        [self.bidingAdStorageAccessor removeObjectForKey:unitID];
    }
}

- (void)savaBiddingDelegate:(OSETBiddingDelegate *)delegate withUnitID:(NSString *)unitID {
    @synchronized (self) {
        [self.bidingAdDelegate setObject:delegate forKey:unitID];
    }
}

- (void)removeBiddingDelegateWithUnitID:(NSString *)unitID {
    @synchronized (self) {
        if (unitID.length) {
            [self.bidingAdDelegate removeObjectForKey:unitID];
        }
    }
}

- (void)startWithRequestItem:(OSETBiddingRequest *)request {
    
    [self.bidingAdStorageAccessor setObject:request forKey:request.unitID];
    switch (request.adType) {
            case OSETAdFormatSplash:
            case OSETAdFormatInterstitial:
            case OSETAdFormatReward:
            case OSETAdFormatNative:
            case OSETAdFormatBanner:{
            // 获取代理
            OSETBiddingDelegate *delegate = [[OSETBiddingDelegate alloc] init];
            delegate.unitID = request.unitID;
            [request.customObject setValue:delegate forKey:@"delegate"];
            [self savaBiddingDelegate:delegate withUnitID:request.unitID];
            break;
        }
        default:
            break;
    }
}
@end
