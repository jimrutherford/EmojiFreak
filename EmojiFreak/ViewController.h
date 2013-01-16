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

@interface ViewController : UIViewController <RIOInterfaceDelegate>
{
	RIOInterface *__weak rioRef;
}
@property(nonatomic, weak) RIOInterface *rioRef;
@property(nonatomic, assign) int currentFrequency;

@property (weak, nonatomic) IBOutlet UIButton *midRangeButton;
@property (weak, nonatomic) IBOutlet UILabel *emojiLabel;

@property (strong, nonatomic) ToneGenerator *toneGenerator;

- (IBAction)frequencyButton:(UIButton*)selectedButton;

@property (weak, nonatomic) IBOutlet UILabel *frequencyDebug;

@end
