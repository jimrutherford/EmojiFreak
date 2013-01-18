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
#import "TSEmojiView.h"
#import "SettingsManager.h"
@interface ViewController ()

@end


@implementation ViewController

@synthesize toneGenerator;
@synthesize rioRef;
@synthesize currentFrequency;
@synthesize characterArray;
@synthesize emojiView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
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
	
	
	emojiView = [[TSEmojiView alloc] initWithFrame:CGRectMake((ScreenWidth - 320)/2, self.view.frame.size.height - 216, 320, 216)];
    emojiView.delegate = self;
	emojiView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:.4];
    [self.view addSubview:emojiView];
	
	[self resetKeyboard];
	
	self.emojiImageView.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboard)];
	[self.emojiImageView addGestureRecognizer:tapGesture];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sendEmoticonWithIndex:(int)index {
	
	SettingsManager *sm = [SettingsManager sharedManager];
	
	NSString *s = sm.username;
	
		
	s = [s lowercaseString];
	for (int a = 0; a < [s length]; a++)
	{
		int code = [[NSNumber numberWithChar: [s characterAtIndex:a]] integerValue] - 96;
		code = asciiOffset + (code * 100);
		[characterArray addObject:[NSNumber numberWithInt:code]];
	}
	
	int emotiCode = emojiOffset + (index * 100);
	[characterArray addObject:[NSNumber numberWithInt:emotiCode]];
	
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
	[self updateNameLabel];
}

- (void) broadcastCharacter
{
	int code = [characterArray[0] integerValue];
	NSLog(@"%i", code);
	[characterArray removeObjectAtIndex:0];
	
	
	toneGenerator.transmissionBitFrequency = code;
	[toneGenerator startToneUnit];

}


#pragma mark - ROIInterface Delegate Method implementations
// This method gets called by the rendering function. Update the UI with
// the character type and store it in our string.
- (void)frequencyChangedWithValue:(int)newFrequency{
	
	self.currentFrequency = newFrequency;
	
	
	int asciiCode;
	
	
	if (newFrequency >= emojiOffset)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			int emojiCode = (newFrequency - emojiOffset)/100;
			NSLog(@"emojiCode = %i", emojiCode);
			
			NSString *imageName = [NSString stringWithFormat:@"emo_%i", emojiCode];
			self.emojiImageView.image = [UIImage imageNamed:imageName];
		});
		
	}
	else if (newFrequency >= asciiOffset)
	{
		asciiCode = ((newFrequency - asciiOffset)/100) + 96;

		NSString *nameText = self.currentName;
		
		nameText = [nameText stringByAppendingFormat:@"%c", asciiCode];
		
		NSLog(@"%i, %@", asciiCode, nameText);
		
		self.currentName = nameText;
		
		dispatch_async(dispatch_get_main_queue(), ^{
			NSLog(@"update label - %@", self.currentName);
			self.nameLabel.text = self.currentName;
			self.frequencyDebug.text = [NSString stringWithFormat:@"%i", newFrequency];
		});
	}

}

- (void)updateNameLabel {
	NSLog(@"update label - %@", self.currentName);
	self.nameLabel.text = self.currentName;
	[self.nameLabel setNeedsDisplay];
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
	self.currentName = @"";
		dispatch_async(dispatch_get_main_queue(), ^{
	[self showThinkingImage];
				});
}

- (void)didStopMessage
{
	NSLog(@"Transmission Complete");
	
		dispatch_async(dispatch_get_main_queue(), ^{
			[self hideThinkingImage];
				});
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
	self.thinkingImageView.frame = CGRectMake(0.0f - oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
}


- (void) resetKeyboard
{
	self.emojiView.alpha = 0.0f;
	CGRect oldFrame = self.emojiView.frame;
	self.emojiView.frame = CGRectMake((ScreenWidth - 320)/2, ScreenHeight + oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
}


- (void) showKeyboard
{
	[self resetKeyboard];
	
	[UIView animateWithDuration:0.3f animations:^{
		self.emojiView.alpha = 1.0f;
		CGRect frame = self.emojiView.frame;
		self.emojiView.frame = CGRectMake((ScreenWidth - 320)/2, ScreenHeight - frame.size.height, frame.size.width, frame.size.height);
	}];
}

- (void) hideKeyboard
{
	[UIView animateWithDuration:0.3f animations:^{
		self.emojiView.alpha = 0.0f;
		CGRect frame = self.emojiView.frame;
		self.emojiView.frame = CGRectMake(frame.origin.x, ScreenHeight + frame.size.height, frame.size.width, frame.size.height);
	}];
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

- (void) didTouchEmojiView:(TSEmojiView *)emojiView touchedEmojiIndex:(int)index
{
	index = index + 1;
	[self hideKeyboard];
	[self sendEmoticonWithIndex:index];
	
	NSString *imageName = [NSString stringWithFormat:@"emo_%i", index];
	self.emojiImageView.image = [UIImage imageNamed:imageName];

	
	NSLog(@"Emoji - %i", index);
}

@end
