// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import "MSAppCenterUserDefaults.h"
#import "MSAppCenterInternal.h"
#import "MSLogger.h"

static NSString *const kMSUserDefaultsTs = @"_ts";
static NSString *const kMSAppCenterUserDefaultsMigratedKeyFormat = @"%@310UserDefaultsMigratedKey";

static MSAppCenterUserDefaults *sharedInstance = nil;
static dispatch_once_t onceToken;

@implementation MSAppCenterUserDefaults

+ (instancetype)shared {
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MSAppCenterUserDefaults alloc] init];
    NSDictionary *migratedKeys = @{
      @"MSChannelStartTimer" : @"MSACChannelStartTimer",
      @"pastDevicesKey" : @"MSACPastDevicesKey",
      @"MSInstallId" : @"MSACInstallId",
      @"MSAppCenterIsEnabled" : @"MSACAppCenterIsEnabled",
      @"MSEncryptionKeyMetadata" : @"MSACEncryptionKeyMetadata",
      @"SessionIdHistory" : @"MSACSessionIdHistory",
      @"UserIdHistory" : @"MSACUserIdHistory"
    };
    [sharedInstance migrateKeys:migratedKeys forService:@"Core"];
  });
  return sharedInstance;
}

+ (void)resetSharedInstance {
  onceToken = 0; // resets the once_token so dispatch_once will run again
  sharedInstance = nil;
}

- (void)migrateKeys:(NSDictionary *)migratedKeys forService:(NSString *)serviceName {
  NSString *serviceHasMigratedKey = [NSString stringWithFormat:kMSAppCenterUserDefaultsMigratedKeyFormat, serviceName];
  NSNumber *serviceHasMigrated = [self objectForKey:serviceHasMigratedKey];
  if (serviceHasMigrated) {
    return;
  }
  MSLogVerbose([MSAppCenter logTag], @"Migrating the old NSDefaults keys to new ones.");
  for (NSString *oldKey in [migratedKeys allKeys]) {
    NSString *newKey = migratedKeys[oldKey];
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:oldKey];
    if (value != nil) {
      [[NSUserDefaults standardUserDefaults] setObject:value forKey:newKey];
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:oldKey];
      MSLogVerbose([MSAppCenter logTag], @"Migrating the key %@ -> %@", oldKey, newKey);
    }
  }
  [self setObject:@(1) forKey:serviceHasMigratedKey];
}

- (NSString *)getAppCenterKeyFrom:(NSString *)key {
    if ([key hasPrefix:kMSUserDefaultsPrefix]) {
        return key;
    } else {
        return [kMSUserDefaultsPrefix stringByAppendingString:key];
    }
}

- (id)objectForKey:(NSString *)key {
  NSString *keyPrefixed = [self getAppCenterKeyFrom:key];
  return [[NSUserDefaults standardUserDefaults] objectForKey:keyPrefixed];
}

- (void)setObject:(id)o forKey:(NSString *)key {
  NSString *keyPrefixed = [self getAppCenterKeyFrom:key];
  [[NSUserDefaults standardUserDefaults] setObject:o forKey:keyPrefixed];
}

- (void)removeObjectForKey:(NSString *)key {
  NSString *keyPrefixed = [self getAppCenterKeyFrom:key];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyPrefixed];
}

- (NSDictionary *)updateDictionary:(NSDictionary *)dict forKey:(NSString *)key expiration:(float)expiration {
  NSString *keyPrefixed = [self getAppCenterKeyFrom:key];
  NSMutableDictionary *update = [[NSMutableDictionary alloc] initWithDictionary:dict];

  // Get from local store.
  NSDictionary *store = [[NSUserDefaults standardUserDefaults] dictionaryForKey:keyPrefixed];

  CFAbsoluteTime ts = [(NSNumber *)store[kMSUserDefaultsTs] doubleValue];
  MSLogVerbose([MSAppCenter logTag], @"Settings:store[%@]=%@", keyPrefixed, store);

  // Force update if timestamp expiration is reached.
  if (ts <= 0.0 || expiration <= 0.0f || fabs(CFAbsoluteTimeGetCurrent() - ts) < (double)expiration) {

    // Remove if already in store and value is the same.
    for (NSString *k in [store allKeys]) {
      if (update[k] != nil && [(NSObject *)update[k] isEqual:store[k]])
        [update removeObjectForKey:k];
    }
  }

  // If still values to update.
  if ([update count] > 0) {
    MSLogDebug([MSAppCenter logTag], @"Settings:update[%@]=%@", keyPrefixed, update);

    // Copy store as a mutable version.
    NSMutableDictionary *d = [store mutableCopy];
    if (d == nil)
      d = [[NSMutableDictionary alloc] initWithCapacity:[update count]];

    // Append update to the current store.
    [d addEntriesFromDictionary:update];

    // Set new timestamp.
    d[kMSUserDefaultsTs] = @(CFAbsoluteTimeGetCurrent());

    // Save.
    [[NSUserDefaults standardUserDefaults] setObject:d forKey:keyPrefixed];
  }

  return update;
}

- (NSDictionary *)updateDictionary:(NSDictionary *)dict forKey:(NSString *)key {
  return [self updateDictionary:dict forKey:key expiration:0.0];
}

- (BOOL)updateObject:(id)o forKey:(NSString *)key expiration:(float)expiration {
  NSDictionary *update = [self updateDictionary:@{@"v" : o} forKey:key expiration:expiration];
  return update[@"v"] != nil;
}

- (BOOL)updateObject:(id)o forKey:(NSString *)key {
  return [self updateObject:o forKey:key expiration:0.0];
}

@end