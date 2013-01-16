//
//  ToneGenerator.h
//  EmojiFreak
//
//  Created by James Rutherford on 2013-01-14.
//  Copyright (c) 2013 Braxio Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ToneGenerator : NSObject
{
	AudioComponentInstance toneUnit;
}

@property (nonatomic, assign, readwrite) double sampleRate;
@property (nonatomic, assign, readwrite) double theta;
@property (nonatomic, assign, readwrite) double frequency;

- (void)stop;
- (void)createToneUnit;
- (void)startToneUnit;
- (void)stopToneUnit;
@end
