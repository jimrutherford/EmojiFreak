//
//  ConfigViewController.m
//  EmojiFreak
//
//  Created by James Rutherford on 2013-01-17.
//  Copyright (c) 2013 Braxio Interactive. All rights reserved.
//

#import "ConfigViewController.h"
#import "SettingsManager.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
	
	self.nameField.text = username;
	[[SettingsManager sharedManager] setUsername:username];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveOptions:(id)sender {
	
	NSString *username = self.nameField.text;
	
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings setObject:username forKey:@"userName"];
	[[SettingsManager sharedManager] setUsername:username];
	[settings synchronize];
	
}

@end
