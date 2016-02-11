//
// Created by David Clark on 2/02/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface SuggestionCell : UITableViewCell

- (void)setName:(NSString *)name withPlaces:(NSMutableArray *)places;

- (void)setHotels:(NSString *)hotels;
@end
