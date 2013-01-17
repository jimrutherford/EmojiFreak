//
//  ToneGenerator.m
//  EmojiFreak
//
//  Created by James Rutherford on 2013-01-14.
//  Copyright (c) 2013 Braxio Interactive. All rights reserved.
//

#import "ToneGenerator.h"
#import <AudioToolbox/AudioToolbox.h>


OSStatus RenderTone(
					void *inRefCon,
					AudioUnitRenderActionFlags 	*ioActionFlags,
					const AudioTimeStamp 		*inTimeStamp,
					UInt32 						inBusNumber,
					UInt32 						inNumberFrames,
					AudioBufferList 			*ioData)

{
	// Fixed amplitude is good enough for our purposes
	const double amplitude = 0.25;
	
	// Get the tone parameters out of the view controller
	ToneGenerator *toneGenerator = (__bridge ToneGenerator *)inRefCon;
	double theta = toneGenerator.theta;
	double theta_increment = 2.0 * M_PI * toneGenerator.frequency / toneGenerator.sampleRate;
	
	// This is a mono tone generator so we only need the first buffer
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
	// Generate the samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++)
	{
		buffer[frame] = sin(theta) * amplitude;
		
		theta += theta_increment;
		if (theta > 2.0 * M_PI)
		{
			theta -= 2.0 * M_PI;
		}
	}
	
	// Store the theta back in the view controller
	toneGenerator.theta = theta;
	
	return noErr;
}

void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
	ToneGenerator *toneGenerator = (__bridge ToneGenerator *)inClientData;
	
	[toneGenerator stop];
}

@implementation ToneGenerator

@synthesize frequency;
@synthesize transmissionBitFrequency;
@synthesize sampleRate;

- (id)init
{
    self = [super init];
    if (self) {
        frequency = 1440;
		sampleRate = 44100;
		
		OSStatus result = AudioSessionInitialize(NULL, NULL, ToneInterruptionListener, (__bridge void *)(self));
		if (result == kAudioSessionNoError)
		{
			UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
			AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
		}
		AudioSessionSetActive(true);
    }
    return self;
}


- (void)startToneUnit
{
	if (!toneUnit)
    {
        // Create the audio unit as shown above
        [self createToneUnit];
		
        // Finalize parameters on the unit
        OSErr err = AudioUnitInitialize(toneUnit);
        NSAssert1(err == noErr, @"Error initializing unit: %hd", err);
		
        // Start playback
        err = AudioOutputUnitStart(toneUnit);
        NSAssert1(err == noErr, @"Error starting unit: %hd", err);
		frequency = startBitFrequency;
		[NSTimer scheduledTimerWithTimeInterval:toneInterval target:self selector:@selector(playStopFreq) userInfo:nil repeats:NO];
    }
}

- (void) playStopFreq
{
	frequency = transmissionBitFrequency;
	[NSTimer scheduledTimerWithTimeInterval:toneInterval target:self selector:@selector(stopToneUnit) userInfo:nil repeats:NO];
}

- (void)stopToneUnit
{
	if (toneUnit)
	{
        // Tear it down in reverse
        AudioOutputUnitStop(toneUnit);
        AudioUnitUninitialize(toneUnit);
        AudioComponentInstanceDispose(toneUnit);
        toneUnit = nil;
		
		// if our current frequency is the stop sentinal frequency we don't need a callback
		if (frequency != stopSentinalFrequency)
		{
			SEL didFinishPlayingToneSelector = @selector(didFinishPlayingTone);
			if (self.delegate && [self.delegate respondsToSelector:didFinishPlayingToneSelector]) {
				
				[self.delegate didFinishPlayingTone];
			}
		}
    }
}

- (void)createToneUnit
{
	// Configure the search parameters to find the default playback output unit
	// (called the kAudioUnitSubType_RemoteIO on iOS but
	// kAudioUnitSubType_DefaultOutput on Mac OS X)
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	// Get the default playback output unit
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	NSAssert(defaultOutput, @"Can't find default output");
	
	// Create a new unit based on this that we'll use for output
	OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
	NSAssert1(toneUnit, @"Error creating unit: %hd", err);
	
	// Set our tone rendering function on the unit
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = (__bridge void *)(self);
	err = AudioUnitSetProperty(toneUnit,
							   kAudioUnitProperty_SetRenderCallback,
							   kAudioUnitScope_Input,
							   0,
							   &input,
							   sizeof(input));
	NSAssert1(err == noErr, @"Error setting callback: %hd", err);
	
	// Set the format to 32 bit, single channel, floating point, linear PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = sampleRate;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;
	streamFormat.mBytesPerFrame = four_bytes_per_float;
	streamFormat.mChannelsPerFrame = 1;
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (toneUnit,
								kAudioUnitProperty_StreamFormat,
								kAudioUnitScope_Input,
								0,
								&streamFormat,
								sizeof(AudioStreamBasicDescription));
	NSAssert1(err == noErr, @"Error setting stream format: %hd", err);
}

- (void)stop
{
	if (toneUnit)
	{
		//[self playToggle:self.midRangeButton];
	}
}

@end
