//
//  ViewController.m
//  EmojiFreak
//
//  Created by James Rutherford on 2013-01-14.
//  Copyright (c) 2013 Braxio Interactive. All rights reserved.
//

#import "ViewController.h"
#import "ToneGenerator.h"
#import "RIOInterface.h"

@interface ViewController ()

@end


@implementation ViewController

@synthesize toneGenerator;
@synthesize rioRef;
@synthesize currentFrequency;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self.emojiLabel setText:[NSString stringWithFormat:@"%@", @"\ue04f"]];
	
	rioRef = [RIOInterface sharedInstance];
	rioRef.delegate = self;
	[rioRef startListening];
	toneGenerator = [[ToneGenerator alloc] init];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)frequencyButton:(UIButton*)selectedButton {
	toneGenerator.frequency = selectedButton.tag;
	[toneGenerator startToneUnit];
}

#pragma mark - ROIInterface Delegate Method implementations
// This method gets called by the rendering function. Update the UI with
// the character type and store it in our string.
- (void)frequencyChangedWithValue:(int)newFrequency{
	self.currentFrequency = newFrequency;
	self.frequencyDebug.text = [NSString stringWithFormat:@"%i", newFrequency];
	
}


- (void)didStartMessage
{
	
}

- (void)didStopMessage
{
	
}

@end
