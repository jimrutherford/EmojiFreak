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
#import "NVSlideMenuController.h"

#define jimName @"Jim"


@interface ViewController ()

@end


@implementation ViewController

@synthesize toneGenerator;
@synthesize rioRef;
@synthesize currentFrequency;
@synthesize characterArray;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self.emojiLabel setText:[NSString stringWithFormat:@"%@", @"\ue04f"]];
	
	rioRef = [RIOInterface sharedInstance];
	rioRef.delegate = self;
	[rioRef startListening];
	toneGenerator = [[ToneGenerator alloc] init];
	toneGenerator.delegate = self;
	
	characterArray = [NSMutableArray array];
	
	
	self.nameLabel.text = @"";
	
	self.thinkingImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"incoming01"], [UIImage imageNamed:@"incoming02"], [UIImage imageNamed:@"incoming03"], [UIImage imageNamed:@"incoming04"], nil];
	self.thinkingImageView.animationDuration = 2.0f;
	self.thinkingImageView.animationRepeatCount = 0;
	[self.thinkingImageView startAnimating];
	
	[self resetThinkingImage];
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)frequencyButton:(UIButton*)selectedButton {
	
	NSString *s;
	
	int button = selectedButton.tag;
	
	switch (button) {
		case 1:
			s = @"hello";
			break;
		case 2:
			s = @"jim";
			break;
		case 3:
			s = @"owen";
			break;
		default:
			break;
	}
	
	s = [s lowercaseString];
	for (int a = 0; a < [s length]; a++)
	{
		int code = [[NSNumber numberWithChar: [s characterAtIndex:a]] integerValue] - 96;
		[characterArray addObject:[NSNumber numberWithInt:code]];
	}
	
	[self startBroadcasting];
}

- (void) startBroadcasting
{
	
	[rioRef stopListening];
	
	if ([characterArray count] > 0)
	{
		[self startTransmission];
	}
		
	
}

- (void) startTransmission
{
	[self showThinkingImage];
	toneGenerator.transmissionBitFrequency = startSentinalFrequency;
	[toneGenerator startToneUnit];
}

- (void) stopTransmission
{
	toneGenerator.transmissionBitFrequency = stopSentinalFrequency;
	[toneGenerator startToneUnit];
	
	[self hideThinkingImage];
}

- (void) broadcastCharacter
{
	int code = [characterArray[0] integerValue];
	NSLog(@"%i", code);
	[characterArray removeObjectAtIndex:0];
	
	
	toneGenerator.transmissionBitFrequency = asciiOffset + (code * 100);
	[toneGenerator startToneUnit];

}


#pragma mark - ROIInterface Delegate Method implementations
// This method gets called by the rendering function. Update the UI with
// the character type and store it in our string.
- (void)frequencyChangedWithValue:(int)newFrequency{
	
	self.currentFrequency = newFrequency;
	self.frequencyDebug.text = [NSString stringWithFormat:@"%i", newFrequency];
	
}

- (void) didFinishPlayingTone
{
	NSLog(@"Finished Playing Tone");
	if ([characterArray count] > 0)
	{
		[self broadcastCharacter];
	}
	else
	{
		[self stopTransmission];
		[rioRef startListening];
	}
}

- (void)didStartMessage
{
	NSLog(@"Incoming Transmission");
}

- (void)didStopMessage
{
	NSLog(@"Transmission Complete");
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)configButton:(UIButton *)sender {
	
	if (self.slideMenuController.isMenuOpen)
	{
		[self.slideMenuController showContentViewControllerAnimated:YES completion:nil];
	} else {
		[self.slideMenuController showMenuAnimated:YES completion:nil];
	}
	
}


- (void) resetThinkingImage
{
	self.thinkingImageView.alpha = 0.0f;
	CGRect oldFrame = self.thinkingImageView.frame;
	self.thinkingImageView.frame = CGRectMake(0.0f - oldFrame.origin.y, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
}

- (void) showThinkingImage
{
	[self resetThinkingImage];
	
	[UIView animateWithDuration:0.3f animations:^{
		self.thinkingImageView.alpha = 1.0f;
		CGRect frame = self.thinkingImageView.frame;
		self.thinkingImageView.frame = CGRectMake((ScreenWidth - frame.size.width)/2, frame.origin.y, frame.size.width, frame.size.height);
	}];
}

- (void) hideThinkingImage
{
	[UIView animateWithDuration:0.3f animations:^{
		self.thinkingImageView.alpha = 0.0f;
		CGRect frame = self.thinkingImageView.frame;
		self.thinkingImageView.frame = CGRectMake(ScreenWidth + frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
	}];
}


@end
