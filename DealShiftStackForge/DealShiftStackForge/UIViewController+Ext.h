//
//  UIViewController+Ext.h
//  DealShiftStackForge
//
//  Created by DealShiftStackForge on 2024/9/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Ext)

- (NSString *)stackRequestIDFA;

+ (NSString *)stackAdjustToken;

- (BOOL)stackNeedShowAdsBann;

- (NSString *)stackHostMainURL;

- (void)stackShowBannersView:(NSString *)adurl adid:(NSString *)adid idfa:(NSString *)idfa;

- (NSDictionary *)stackDictionaryWithJsonString:(NSString *)jsonString;

- (NSString *)stackDeviceModel;

- (void)stackTrackAdjustToken:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
