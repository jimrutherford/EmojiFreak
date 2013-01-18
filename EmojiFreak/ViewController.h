//
//  ViewController.h
//  EmojiFreak
//
//  Created by James Rutherford on 2013-01-14.
//  Copyright (c) 2013 Braxio Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIOInterface.h"
#import "ToneGenerator.h"
#import "TSEmojiView.h"

@interface ViewController : UIViewController <RIOInterfaceDelegate, ToneGeneratorDelegate, TSEmojiViewDelegate>
{
	RIOInterface *__weak rioRef;
}

@property(nonatomic, weak) RIOInterface *rioRef;
@property (strong, nonatomic) ToneGenerator *toneGenerator;
@property(nonatomic, assign) int currentFrequency;
@property (nonatomic, strong) NSString *currentName;

@property (strong, nonatomic) NSMutableArray *characterArray;

@property (nonatomic, strong) TSEmojiView *emojiView;


// UI Actions
- (IBAction)configButton:(UIButton *)sender;
- (IBAction)frequencyButton:(UIButton*)selectedButton;

// UI Outlets

@property (weak, nonatomic) IBOutlet UIImageView *thinkingImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *emojiImageView;


// for debugging
@property (weak, nonatomic) IBOutlet UILabel *frequencyDebug;


@end
