//
// Created by David Clark on 2/02/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <YOLOKit/NSArray+reduce.h>
#import <YOLOKit/NSArray+inject.h>
#import <YOLOKit/NSArray+snip.h>
#import "SuggestionCell.h"


@implementation SuggestionCell {

	UILabel *_nameLabel;
	UILabel *_placesLabel;
	UILabel *_countryLabel;
	UILabel *_hotelsLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self setupSubviews];
	}

	return self;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	[_nameLabel setText:nil];
	[_placesLabel setText:nil];
	[_countryLabel setText:nil];
}

- (void)setupSubviews {
	_hotelsLabel = [[UILabel alloc] init];
	[_hotelsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_hotelsLabel setFont:[UIFont fontWithDescriptor:[[_hotelsLabel.font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:_hotelsLabel.font.pointSize]];
	[self addSubview:_hotelsLabel];
	[_hotelsLabel.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor].active = YES;
	[_hotelsLabel.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor].active = YES;

	// TODO: yeah, put these in a container view, that view is constrained to be from the left edge to the hotels label, then the labels in it (below) need to flow. good luck.
	// TODO: maybe we can change to NSAttributedString and just use a single label to make it wrap properly
	_nameLabel = [[UILabel alloc] init];
	[_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self addSubview:_nameLabel];
	[_nameLabel.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor].active = YES;
	[_nameLabel.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor].active = YES;

	_placesLabel = [[UILabel alloc] init];
	[_placesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self addSubview:_placesLabel];
	[_placesLabel.topAnchor constraintEqualToAnchor:_nameLabel.topAnchor].active = YES;
	[_placesLabel.leadingAnchor constraintEqualToAnchor:_nameLabel.trailingAnchor].active = YES;
	
	_countryLabel = [[UILabel alloc] init];
	[_countryLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_countryLabel setFont:[UIFont fontWithDescriptor:[[_countryLabel.font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:_countryLabel.font.pointSize]];
	[self addSubview:_countryLabel];
	[_countryLabel.topAnchor constraintEqualToAnchor:_placesLabel.topAnchor].active = YES;
	[_countryLabel.leadingAnchor constraintEqualToAnchor:_placesLabel.trailingAnchor].active = YES;
}

- (void)setName:(NSString *)name withPlaces:(NSMutableArray *)places {
	if([places count]) {
		[_nameLabel setText:name];

		[_placesLabel setText:[places
				.snip(1)
				.inject(@"", ^(NSString *memo, NSString *place) {
					return [memo stringByAppendingFormat:@", %@", place];
				}) stringByAppendingString:@", "]];
		[_countryLabel setText:[places lastObject]];
	}
	else {
		[_countryLabel setText:name];
	}
}

- (void)setHotels:(NSString *)hotels {
	[_hotelsLabel setText:[NSString stringWithFormat:@"(%@)", hotels]];
}

@end
