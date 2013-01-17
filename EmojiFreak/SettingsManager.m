//
//  SettingsManager.m
//  EmojiFreak
//
//  Created by James Rutherford on 2013-01-17.
//  Copyright (c) 2013 Braxio Interactive. All rights reserved.
//

#import "SettingsManager.h"

static SettingsManager *settingsManager = nil;

@implementation SettingsManager

@synthesize username;

#pragma mark - Singleton methods

+(SettingsManager *)sharedManager
{
    static dispatch_once_t once;
    
    dispatch_once( &once, ^{
        settingsManager = [[SettingsManager alloc] init];
    } );
    
    return settingsManager;
}

+(id)alloc
{
    if (!settingsManager)
    {
        return [super alloc];
    }
    
    NSLog(@"DataBaseManager: use +sharedManager to access singleton instance.");
    return nil;
}

+ (id)new
{
    return [self alloc];
}

+ (id)allocWithZone:(NSZone *)zone
{
    if (!settingsManager)
    {
        return [super allocWithZone:zone];
    }
    return [self alloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    // -copy inherited from NSObject calls -copyWithZone:
    NSLog(@"SettingsManager: attempt to -copy may be a bug");
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    // -mutableCopy inherited from NSObject calls -mutableCopyWithZone:
    return [self copyWithZone:zone];
}

#pragma mark - Initializations

- (id)init {
	if (self = [super init]) {
		[self setup];
	}
	return self;
}

- (void) setup
{

}

@end
