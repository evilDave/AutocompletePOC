//
// Created by David Clark on 2/02/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import "ViewController.h"
#import "SuggestionCell.h"

#import <PromiseKit/PromiseKit.h>
#import <PromiseKit/NSURLConnection+AnyPromise.h>
#import <YOLOKit/NSArray+map.h>
#import <YOLOKit/NSArray+groupBy.h>
#import <YOLOKit/NSArray+uniq.h>
#import <YOLOKit/NSArray+reduce.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation ViewController {

    NSMutableDictionary *suggestions;

    NSString *query;
    UITableView *tableView;
    NSLayoutConstraint *_tableViewBottomConstraint;
    UITextField *_textField;
}

static NSString *const suggestionCellIdentifier = @"SuggestionCell";

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *testData = @{};
        suggestions = [NSMutableDictionary dictionaryWithDictionary:testData];
    }

    return self;
}

- (void)loadView {
    [self setView:[[UIView alloc] init]];
    [self.view setBackgroundColor:[UIColor grayColor]];

    _textField = [[UITextField alloc] init];
    [_textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_textField setBackgroundColor:[UIColor whiteColor]];
    [_textField setFont:[UIFont fontWithName:@"ArialMT" size:22]];
    [_textField addTarget:self action:@selector(queryChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_textField];
    [[_textField leadingAnchor] constraintEqualToAnchor:[self.view leadingAnchor]].active = YES;
    [[_textField topAnchor] constraintEqualToAnchor:[self.topLayoutGuide bottomAnchor]].active = YES;
    [[_textField widthAnchor] constraintEqualToAnchor:[self.view widthAnchor]].active = YES;

    tableView = [[UITableView alloc] init];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView registerClass:[SuggestionCell class] forCellReuseIdentifier:suggestionCellIdentifier];
    [self.view addSubview:tableView];
    [[tableView leadingAnchor] constraintEqualToAnchor:[self.view leadingAnchor]].active = YES;
    [[tableView topAnchor] constraintEqualToAnchor:[_textField bottomAnchor]].active = YES;
    [[tableView widthAnchor] constraintEqualToAnchor:[self.view widthAnchor]].active = YES;
    _tableViewBottomConstraint = [[tableView bottomAnchor] constraintEqualToAnchor:[self.bottomLayoutGuide topAnchor]];
    _tableViewBottomConstraint.active = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [_tableViewBottomConstraint setConstant:-[[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [_tableViewBottomConstraint setConstant:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [suggestions[query][@"types"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionType = suggestions[query][@"types"][section];
    return [suggestions[query][@"places"][sectionType] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return suggestions[query][@"types"][section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:suggestionCellIdentifier];

    NSString *sectionType = suggestions[query][@"types"][indexPath.section];

    id place = suggestions[query][@"places"][sectionType][indexPath.row];

    [cell setName:place[@"name"] withPlaces:place[@"places"]];
    [cell setHotels:place[@"hotels"]];
    return cell;
}

- (void)queryChanged:(id)sender {
    UITextField *textField = sender;
    if(textField && textField.text.length >= 2) {
        NSString *search = [textField.text lowercaseString];

        if(suggestions[search]) {
            query = search;
            [tableView reloadData];
        }
        else {
            AnyPromise *request = [NSURLConnection GET:@"https://www.hotelscombined.com/AutoUniversal.ashx" query:@{ @"search": search, @"limit": @"25", @"languageCode": @"EN" }];
            request.then(^(id data) {
                NSArray *places = (NSArray *)data;
                if (places) {
                    NSArray *typesInOrder = places.map(^(NSDictionary *place) {
                        return place[@"tn"];
                    }).uniq;
                    NSDictionary *placesByType = places.map(^(NSDictionary *place) {
                        return @{ @"type": place[@"tn"], @"name": place[@"n"], @"key": place[@"k"], @"places": place[@"p"], @"hotels": place[@"h"] };
                    }).groupBy(^(NSDictionary *place) {
                        return place[@"type"];
                    });
                    suggestions[search] = @{ @"types": typesInOrder, @"places": placesByType};
                }
                query = search;
                [tableView reloadData];
            });
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionType = suggestions[query][@"types"][indexPath.section];
    id place = suggestions[query][@"places"][sectionType][indexPath.row];
    [_textField setText:place[@"key"]];
    [_textField resignFirstResponder];
}

@end
