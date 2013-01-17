//
//  ConfigViewController.h
//  EmojiFreak
//
//  Created by James Rutherford on 2013-01-17.
//  Copyright (c) 2013 Braxio Interactive. All rights reserved.
//

#import "ViewController.h"

@interface ConfigViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;

- (IBAction)saveOptions:(id)sender;

@end
