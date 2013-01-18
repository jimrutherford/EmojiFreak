//
//  TSEmojiView.m
//  TSEmojiView
//
//  Created by Shawn Ma on 7/24/12.
//  Copyright (c) 2012 Telenav Software, Inc. All rights reserved.
//

#import "TSEmojiView.h"

#define TSEMOJIVIEW_COLUMNS 7
#define TSEMOJIVIEW_SPACES  0.7
#define TSEMOJIVIEW_KEYTOP_WIDTH 82
#define TSEMOJIVIEW_KEYTOP_HEIGHT 111
#define TSKEYTOP_SIZE 55
#define TSEMOJI_SIZE 45

//==============================================================================
// TSEmojiViewLayer
//==============================================================================
@interface TSEmojiViewLayer : CALayer {
@private
    CGImageRef _keytopImage;;
}
@property (nonatomic, retain) UIImage* emoji;
@end

@implementation TSEmojiViewLayer
@synthesize emoji = _emoji;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    _keytopImage = nil;
    _emoji = nil;
}

- (void)drawInContext:(CGContextRef)context
{
    _keytopImage = [[UIImage imageNamed:@"emoji_touch.png"] CGImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(TSEMOJIVIEW_KEYTOP_WIDTH, TSEMOJIVIEW_KEYTOP_HEIGHT));
    CGContextTranslateCTM(context, 0.0, TSEMOJIVIEW_KEYTOP_HEIGHT);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, TSEMOJIVIEW_KEYTOP_WIDTH, TSEMOJIVIEW_KEYTOP_HEIGHT), _keytopImage);
    UIGraphicsEndImageContext();
    
    //
    UIGraphicsBeginImageContext(CGSizeMake(TSKEYTOP_SIZE, TSKEYTOP_SIZE));
    CGContextDrawImage(context, CGRectMake((TSEMOJIVIEW_KEYTOP_WIDTH - TSKEYTOP_SIZE) / 2 , 45, TSKEYTOP_SIZE, TSKEYTOP_SIZE), [_emoji CGImage]);
    UIGraphicsEndImageContext();
}

@end

//==============================================================================
// TSEmojiView
//==============================================================================
@interface TSEmojiView() {
    NSMutableArray *_emojiArray;
    NSMutableArray *_symbolArray;
    
    NSInteger _touchedIndex;
    TSEmojiViewLayer *_emojiPadLayer;
}
@end

@implementation TSEmojiView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _emojiArray = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"emo_1.png"],
                       [UIImage imageNamed:@"emo_2.png"],
                       [UIImage imageNamed:@"emo_3.png"],
                       [UIImage imageNamed:@"emo_4.png"],
                       [UIImage imageNamed:@"emo_5.png"],
                       [UIImage imageNamed:@"emo_6.png"],
                       [UIImage imageNamed:@"emo_7.png"],
                       [UIImage imageNamed:@"emo_8.png"],
                       [UIImage imageNamed:@"emo_9.png"],
                       [UIImage imageNamed:@"emo_10.png"],
                       [UIImage imageNamed:@"emo_11.png"],
                       [UIImage imageNamed:@"emo_12.png"],
                       [UIImage imageNamed:@"emo_13.png"],
                       [UIImage imageNamed:@"emo_14.png"],
                       [UIImage imageNamed:@"emo_15.png"],
                       [UIImage imageNamed:@"emo_16.png"],
                       [UIImage imageNamed:@"emo_17.png"],
                       [UIImage imageNamed:@"emo_18.png"],
                       [UIImage imageNamed:@"emo_19.png"],
                       [UIImage imageNamed:@"emo_20.png"],
                       [UIImage imageNamed:@"emo_21.png"],
                       [UIImage imageNamed:@"emo_22.png"],
                       [UIImage imageNamed:@"emo_23.png"],
                       [UIImage imageNamed:@"emo_24.png"],
                       [UIImage imageNamed:@"emo_25.png"],
                       [UIImage imageNamed:@"emo_26.png"],
                       [UIImage imageNamed:@"emo_27.png"],
                       [UIImage imageNamed:@"emo_28.png"],
                       nil];
        
        _symbolArray = [NSArray arrayWithObjects:
                        @"\U0001F604", //@"\ue415",
                        @"\U0001F60A", //@"\ue056",
                        @"\U0001F603", //@"\ue057",
                        @"\u263A",     //@"\ue414",
                        @"\U0001F609", //@"\ue405",
                        @"\U0001F60D", //@"\ue106",
                        @"\U0001F618", //@"\ue418",
                        @"\U0001F61A", //@"\ue417",
                        @"\U0001F633", //@"\ue40d",
                        @"\U0001F60C", //@"\ue40a",
                        @"\U0001F601", //@"\ue404",
                        @"\U0001F61C", //@"\ue105",
                        @"\U0001F61D", //@"\ue409",
                        @"\U0001F612", //@"\ue40e",
                        @"\U0001F60F", //@"\ue402",
                        @"\U0001F613", //@"\ue108",
                        @"\U0001F614", //@"\ue403",
                        @"\U0001F61E", //@"\ue058",
                        @"\U0001F616", //@"\ue407",
                        @"\U0001F625", //@"\ue401",
                        @"\U0001F630", //@"\ue40f",
                        @"\U0001F628", //@"\ue40b",
                        @"\U0001F623", //@"\ue406",
                        @"\U0001F622", //@"\ue413",
                        @"\U0001F62D", //@"\ue411",
                        @"\U0001F602", //@"\ue412",
                        @"\U0001F632", //@"\ue410",
                        @"\U0001F631", //@"\ue107",
                        nil];
        
        //Layer
        _emojiPadLayer = [TSEmojiViewLayer layer];
        [self.layer addSublayer:_emojiPadLayer];

        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    _emojiArray = nil;
    _symbolArray = nil;
    _emojiPadLayer = nil;
}

- (void)drawRect:(CGRect)rect
{
    int index =0;
    for(UIImage *image in _emojiArray) {
        float originX = (self.bounds.size.width / TSEMOJIVIEW_COLUMNS) * (index % TSEMOJIVIEW_COLUMNS) + ((self.bounds.size.width / TSEMOJIVIEW_COLUMNS) - TSEMOJI_SIZE ) / 2;
        float originY = (index / TSEMOJIVIEW_COLUMNS) * (self.bounds.size.width / TSEMOJIVIEW_COLUMNS) + ((self.bounds.size.width / TSEMOJIVIEW_COLUMNS) - TSEMOJI_SIZE ) / 2;
        
        
        [image drawInRect:CGRectMake(originX, originY, TSEMOJI_SIZE, TSEMOJI_SIZE)];
        index++;
    }
}

#pragma mark -
#pragma mark Actions
- (NSUInteger)indexWithEvent:(UIEvent*)event
{
    UITouch* touch = [[event allTouches] anyObject];
    NSUInteger x = [touch locationInView:self].x / (self.bounds.size.width / TSEMOJIVIEW_COLUMNS);
    NSUInteger y = [touch locationInView:self].y / (self.bounds.size.width / TSEMOJIVIEW_COLUMNS);
    
    return x + (y * TSEMOJIVIEW_COLUMNS);
}

- (void)updateWithIndex:(NSUInteger)index
{
    if(index < _emojiArray.count) {
        _touchedIndex = index;
        
        if (_emojiPadLayer.opacity != 1.0) {
            _emojiPadLayer.opacity = 1.0;
        }
        
        float originX = (self.bounds.size.width / TSEMOJIVIEW_COLUMNS) * (index % TSEMOJIVIEW_COLUMNS) + ((self.bounds.size.width / TSEMOJIVIEW_COLUMNS) - TSEMOJI_SIZE ) / 2;
        float originY = (index / TSEMOJIVIEW_COLUMNS) * (self.bounds.size.width / TSEMOJIVIEW_COLUMNS) + ((self.bounds.size.width / TSEMOJIVIEW_COLUMNS) - TSEMOJI_SIZE ) / 2;
        
        [_emojiPadLayer setEmoji:[_emojiArray objectAtIndex:index]];
        [_emojiPadLayer setFrame:CGRectMake(originX - (TSEMOJIVIEW_KEYTOP_WIDTH - TSEMOJI_SIZE) / 2, originY - (TSEMOJIVIEW_KEYTOP_HEIGHT - TSEMOJI_SIZE), TSEMOJIVIEW_KEYTOP_WIDTH, TSEMOJIVIEW_KEYTOP_HEIGHT)];
        [_emojiPadLayer setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger index = [self indexWithEvent:event];
    if(index < _emojiArray.count) {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        [self updateWithIndex:index];
        [CATransaction commit];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger index = [self indexWithEvent:event];
    if (_touchedIndex >=0 && index != _touchedIndex && index < _emojiArray.count) {
        [self updateWithIndex:index];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && _touchedIndex >= 0) {
        if ([self.delegate respondsToSelector:@selector(didTouchEmojiView:touchedEmoji:)]) {
            [self.delegate didTouchEmojiView:self touchedEmoji:[_symbolArray objectAtIndex:_touchedIndex]];
        }
    }
	
	if (self.delegate && _touchedIndex >= 0) {
        if ([self.delegate respondsToSelector:@selector(didTouchEmojiView:touchedEmojiIndex:)]) {
            [self.delegate didTouchEmojiView:self touchedEmojiIndex:_touchedIndex];
        }
    }
	
    _touchedIndex = -1;
    _emojiPadLayer.opacity = 0.0;
    [self setNeedsDisplay];
    [_emojiPadLayer setNeedsDisplay];
}

@end
