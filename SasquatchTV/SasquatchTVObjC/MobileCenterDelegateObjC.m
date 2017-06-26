#import "MSAlertController.h"
#import "MobileCenterDelegateObjC.h"

@import MobileCenter;
@import MobileCenterAnalytics;
@import MobileCenterCrashes;

/**
 * MobileCenterDelegate implementation in Objective C.
 */
@implementation MobileCenterDelegateObjC

#pragma mark - MSMobileCenter section.
- (BOOL)isMobileCenterEnabled {
  return [MSMobileCenter isEnabled];
}
- (void)setMobileCenterEnabled:(BOOL)isEnabled {
  return [MSMobileCenter setEnabled:isEnabled];
}
- (NSString *)installId {
  return [[MSMobileCenter installId] UUIDString];
}
- (NSString *)appSecret {
  // TODO: Uncomment when appSecret is moved from internal to public.
  // return [[MSMobileCenter sharedInstance] appSecret];
  return @"Internal";
}
- (NSString *)logUrl {
  // TODO: Uncomment when logUrl is moved from internal to public.
  // return [[MSMobileCenter sharedInstance] logUrl];
  return @"Internal";
}
- (BOOL)isDebuggerAttached {
  return [MSMobileCenter isDebuggerAttached];
}

#pragma mark - Modules section.
- (BOOL)isAnalyticsEnabled {
  return [MSAnalytics isEnabled];
}
- (void)setAnalyticsEnabled:(BOOL)isEnabled {
  [MSAnalytics setEnabled:isEnabled];
}
- (BOOL)isCrashesEnabled {
  return [MSCrashes isEnabled];
}

- (void)setCrashesEnabled:(BOOL)isEnabled {

  // TODO: Uncomment when Crashes will allowed for tvOS.
  [MSCrashes setEnabled:isEnabled];
}

#pragma mark - MSAnalytics section.
- (void)trackEvent:(NSString *)eventName {
  [MSAnalytics trackEvent:eventName];
}
- (void)trackEvent:(NSString *)eventName withProperties:(NSDictionary<NSString *, NSString *> *)properties {
  [MSAnalytics trackEvent:eventName withProperties:properties];
}
- (void)trackPage:(NSString *)pageName {
  // TODO: Uncomment when trackPage is moved from internal to public module.
  // [MSAnalytics trackPage:pageName];
}
- (void)trackPage:(NSString *)pageName withProperties:(NSDictionary<NSString *, NSString *> *)properties {
  // TODO: Uncomment when trackPage is moved from internal to public module.
  // [MSAnalytics trackPage:pageName withProperties:properties];
}

#pragma mark - MSCrashes section.
- (BOOL)hasCrashedInLastSession {
  return [MSCrashes hasCrashedInLastSession];
}
- (void)generateTestCrash {
  return [MSCrashes generateTestCrash];
}

#pragma mark - Last crash report section.
- (NSString *)lastCrashReportIncidentIdentifier {
  return [[MSCrashes lastSessionCrashReport] incidentIdentifier];
}
- (NSString *)lastCrashReportReporterKey {
  return [[MSCrashes lastSessionCrashReport] reporterKey];
}
- (NSString *)lastCrashReportSignal {
  return [[MSCrashes lastSessionCrashReport] signal];
}
- (NSString *)lastCrashReportExceptionName {
  return [[MSCrashes lastSessionCrashReport] exceptionName];
}
- (NSString *)lastCrashReportExceptionReason {
  return [[MSCrashes lastSessionCrashReport] exceptionReason];
}
- (NSString *)lastCrashReportAppStartTimeDescription {
  return [[[MSCrashes lastSessionCrashReport] appStartTime] description];
}
- (NSString *)lastCrashReportAppErrorTimeDescription {
  return [[[MSCrashes lastSessionCrashReport] appErrorTime] description];
}
- (NSUInteger)lastCrashReportAppProcessIdentifier {
  return [[MSCrashes lastSessionCrashReport] appProcessIdentifier];
}
- (BOOL)lastCrashReportIsAppKill {
  return [[MSCrashes lastSessionCrashReport] isAppKill];
}
- (NSString *)lastCrashReportDeviceModel {
  return [[[MSCrashes lastSessionCrashReport] device] model];
}
- (NSString *)lastCrashReportDeviceOemName {
  return [[[MSCrashes lastSessionCrashReport] device] oemName];
}
- (NSString *)lastCrashReportDeviceOsName {
  return [[[MSCrashes lastSessionCrashReport] device] osName];
}
- (NSString *)lastCrashReportDeviceOsVersion {
  return [[[MSCrashes lastSessionCrashReport] device] osVersion];
}
- (NSString *)lastCrashReportDeviceOsBuild {
  return [[[MSCrashes lastSessionCrashReport] device] osBuild];
}
- (NSString *)lastCrashReportDeviceLocale {
  return [[[MSCrashes lastSessionCrashReport] device] locale];
}
- (NSNumber *)lastCrashReportDeviceTimeZoneOffset {
  return [[[MSCrashes lastSessionCrashReport] device] timeZoneOffset];
}
- (NSString *)lastCrashReportDeviceScreenSize {
  return [[[MSCrashes lastSessionCrashReport] device] screenSize];
}
- (NSString *)lastCrashReportDeviceAppVersion {
  return [[[MSCrashes lastSessionCrashReport] device] appVersion];
}
- (NSString *)lastCrashReportDeviceAppBuild {
  return [[[MSCrashes lastSessionCrashReport] device] appBuild];
}
- (NSString *)lastCrashReportDeviceAppNamespace {
  return [[[MSCrashes lastSessionCrashReport] device] appNamespace];
}
- (NSString *)lastCrashReportDeviceCarrierName {
  return [[[MSCrashes lastSessionCrashReport] device] carrierName];
}
- (NSString *)lastCrashReportDeviceCarrierCountry {
  return [[[MSCrashes lastSessionCrashReport] device] carrierCountry];
}

@end
