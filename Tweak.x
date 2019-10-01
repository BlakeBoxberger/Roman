#import "Interfaces.h"

NSCalendar *calendar;

// End modern status bar code

%hook _UIStatusBarStringView

- (void)setText:(NSString *)text {
	if([text containsString:@":"]) {
		NSDate *date = [NSDate date];
		NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
		NSInteger hour = [components hour];
		NSInteger minute = [components minute];
		NSString *hourString = [self convertToRomanString:hour];
		NSString *minuteString = [self convertToRomanString:minute];
		%orig([NSString stringWithFormat:@"%@:%@", hourString, minuteString]);
	}
	else {
		%orig(text);
	}
}

%new
- (NSString *)convertToRomanString:(int)num {
	if (num < 0 || num > 9999) { return @""; } // out of range

    NSArray *r_ones = [NSArray arrayWithObjects:@"I", @"II", @"III", @"IV", @"V", @"VI", @"VII", @"VIII", @"IX", nil];
    NSArray *r_tens = [NSArray arrayWithObjects:@"X", @"XX", @"XXX", @"XL", @"L", @"LX", @"LXX",@"LXXX", @"XC", nil];
    NSArray *r_hund = [NSArray arrayWithObjects:@"C", @"CC", @"CCC", @"CD", @"D", @"DC", @"DCC",@"DCCC", @"CM", nil];
    NSArray *r_thou = [NSArray arrayWithObjects:@"M", @"MM", @"MMM", @"MMMM", @"MMMMM", @"MMMMMM", @"MMMMMMM", @"MMMMMMMM", @"MMMMMMMMM", nil];
	// real romans should have an horizontal   __           ___           _____
	// bar over number to make x 1000: 4000 is IV, 16000 is XVI, 32767 is XXXMMDCCLXVII...

    int thou = num / 1000;
    int hundreds = (num -= thou*1000) / 100;
    int tens = (num -= hundreds*100) / 10;
    int ones = num % 10; // cheap %, 'cause num is < 100!

    return [NSString stringWithFormat:@"%@%@%@%@",
        thou ? [r_thou objectAtIndex:thou-1] : @"",
        hundreds ? [r_hund objectAtIndex:hundreds-1] : @"",
        tens ? [r_tens objectAtIndex:tens-1] : @"",
        ones ? [r_ones objectAtIndex:ones-1] : @""];
}

%end

/*
%hook _UIStatusBarTimeItem

- (instancetype)init {
	%orig;

	self.shortTimeView.text = @":";
	self.pillTimeView.text = @":";

	self.shortTimeView.adjustsFontSizeToFitWidth = YES;
	self.pillTimeView.adjustsFontSizeToFitWidth = YES;

	self.transitionTimer = [self getTransitionTimer];
	[[NSRunLoop mainRunLoop] addTimer:self.transitionTimer forMode:NSRunLoopCommonModes];
	return self;
}

%end
*/

// End modern status bar code

// Start legacy status bar code

/*
UIStatusBarComposedData *data;
int actions;

%hook UIStatusBarTimeItemView

- (BOOL)updateForNewData:(UIStatusBarComposedData *)arg1 actions:(int)arg2 {
	data = arg1;
	actions = arg2;

	NSDate *date = [NSDate date];
	NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
	NSInteger hour = [components hour];
	NSInteger minute = [components minute];
	NSString *hourString = [self convertToRomanString:hour];
	NSString *minuteString = [self convertToRomanString:minute];
	[self setValue:[NSString stringWithFormat:@"%@:%@", hourString, minuteString] forKey:@"_timeString"];

	return %orig;
}

%new
- (NSString *)convertToRomanString:(int)num {
	if (num < 0 || num > 9999) { return @""; } // out of range

    NSArray *r_ones = [NSArray arrayWithObjects:@"I", @"II", @"III", @"IV", @"V", @"VI", @"VII", @"VIII", @"IX", nil];
    NSArray *r_tens = [NSArray arrayWithObjects:@"X", @"XX", @"XXX", @"XL", @"L", @"LX", @"LXX",@"LXXX", @"XC", nil];
    NSArray *r_hund = [NSArray arrayWithObjects:@"C", @"CC", @"CCC", @"CD", @"D", @"DC", @"DCC",@"DCCC", @"CM", nil];
    NSArray *r_thou = [NSArray arrayWithObjects:@"M", @"MM", @"MMM", @"MMMM", @"MMMMM", @"MMMMMM", @"MMMMMMM", @"MMMMMMMM", @"MMMMMMMMM", nil];
	// real romans should have an horizontal   __           ___           _____
	// bar over number to make x 1000: 4000 is IV, 16000 is XVI, 32767 is XXXMMDCCLXVII...

    int thou = num / 1000;
    int hundreds = (num -= thou*1000) / 100;
    int tens = (num -= hundreds*100) / 10;
    int ones = num % 10; // cheap %, 'cause num is < 100!

    return [NSString stringWithFormat:@"%@%@%@%@",
        thou ? [r_thou objectAtIndex:thou-1] : @"",
        hundreds ? [r_hund objectAtIndex:hundreds-1] : @"",
        tens ? [r_tens objectAtIndex:tens-1] : @"",
        ones ? [r_ones objectAtIndex:ones-1] : @""];
}

%end
*/

// End legacy status bar code

%ctor {
	// Fix rejailbreak bug
	if (![NSBundle.mainBundle.bundleURL.lastPathComponent.pathExtension isEqualToString:@"app"]) {
		return;
	}

	calendar = [NSCalendar currentCalendar];

	%init;
}
