//
// Created by David Clark on 2/02/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <YOLOKit/NSArray+inject.h>
#import <YOLOKit/NSArray+snip.h>
#import "SuggestionCell.h"


@implementation SuggestionCell {

	UILabel *_placeLabel;
	UILabel *_hotelsLabel;
	UIFont *_placeFontBold;
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
	[_placeLabel setAttributedText:nil];
}

- (void)setupSubviews {
	_hotelsLabel = [[UILabel alloc] init];
	[_hotelsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_hotelsLabel setFont:[UIFont fontWithDescriptor:[[_hotelsLabel.font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:_hotelsLabel.font.pointSize]];
	[self.contentView addSubview:_hotelsLabel];
	[_hotelsLabel.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor].active = YES;
	[_hotelsLabel.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor].active = YES;
	[_hotelsLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal]; // ensure this label is not compressed by a long place text
	[_hotelsLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal]; // ensure this label is always fixed to the right even with a short place text

	_placeLabel = [[UILabel alloc] init];
	[_placeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_placeLabel setNumberOfLines:0];
	[self.contentView addSubview:_placeLabel];
	[_placeLabel.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor].active = YES;
	[_placeLabel.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor].active = YES;
	[_placeLabel.trailingAnchor constraintEqualToAnchor:_hotelsLabel.leadingAnchor].active = YES;
	[_placeLabel.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor].active = YES; // this constraint is needed to make auto sizing of the cell (contentView) to work

	_placeFontBold = [UIFont fontWithDescriptor:[[_placeLabel.font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:_placeLabel.font.pointSize];
}

- (void)setName:(NSString *)name withPlaces:(NSMutableArray *)places {
	NSMutableAttributedString *text;
	if([places count]) {
		text = [[NSMutableAttributedString alloc] initWithString:name];

		[text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[places
				.snip(1)
				.inject(@"", ^(NSString *memo, NSString *place) {
					return [memo stringByAppendingFormat:@", %@", place];
				}) stringByAppendingString:@", "]]];

		[text appendAttributedString:[[NSAttributedString alloc] initWithString:[places lastObject] attributes:@{NSFontAttributeName: _placeFontBold}]];
	}
	else {
		text = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName: _placeFontBold}];
	}
	[_placeLabel setAttributedText:text];
}

- (void)setHotels:(NSString *)hotels {
	[_hotelsLabel setText:[NSString stringWithFormat:@"(%@)", hotels]];
}

@end
