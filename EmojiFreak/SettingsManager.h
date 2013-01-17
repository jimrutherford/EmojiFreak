//
//  SettingsManager.h
//  EmojiFreak
//
//  Created by James Rutherford on 2013-01-17.
//  Copyright (c) 2013 Braxio Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

+(SettingsManager *) sharedManager;

@property (nonatomic, strong) NSString *username;

@end
