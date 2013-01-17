//
//  ToneGenerator.h
//  EmojiFreak
//
//  Created by James Rutherford on 2013-01-14.
//  Copyright (c) 2013 Braxio Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol ToneGeneratorDelegate <NSObject>

- (void)didFinishPlayingTone;

@end

@interface ToneGenerator : NSObject
{
	AudioComponentInstance toneUnit;
}

@property (nonatomic, weak) id <ToneGeneratorDelegate> delegate;

@property (nonatomic, assign, readwrite) double sampleRate;
@property (nonatomic, assign, readwrite) double theta;
@property (nonatomic, assign, readwrite) double frequency;
@property (nonatomic, assign, readwrite) double transmissionBitFrequency;

- (void)stop;
- (void)createToneUnit;
- (void)startToneUnit;
- (void)stopToneUnit;
@end
