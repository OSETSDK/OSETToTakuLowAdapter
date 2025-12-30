//
//  OSETBiddingManager.h
//  YhsADSProject
//
//  Created by Shens on 21/3/2025.
//

#import <Foundation/Foundation.h>
#import "OSETBiddingRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSETBiddingManager : NSObject
+ (instancetype)sharedInstance;

- (void)startWithRequestItem:(OSETBiddingRequest *)request;

- (OSETBiddingRequest *)getRequestItemWithUnitID:(NSString *)unitID;

- (void)removeRequestItmeWithUnitID:(NSString *)unitID;

- (void)removeBiddingDelegateWithUnitID:(NSString *)unitID;
@end

NS_ASSUME_NONNULL_END
