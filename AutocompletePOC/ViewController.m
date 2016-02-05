//
// Created by David Clark on 2/02/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import "ViewController.h"
#import "SuggestionCell.h"

#import <PromiseKit/PromiseKit.h>


@interface ViewController () <UITableViewDataSource>
@end

@implementation ViewController {

    NSMutableDictionary *suggestions;

    NSString *query;
    UITableView *tableView;
}

static NSString *const suggestionCellIdentifier = @"SuggestionCell";

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *testData = @{ @"syd": @[@"sydney", @"sydblah", @"sydxfoo", @"sydxxxx"], @"sydx": @[@"sydxfoo", @"sydxxxx"]};
        suggestions = [NSMutableDictionary dictionaryWithDictionary:testData];
    }

    return self;
}

- (void)loadView {
    [self setView:[[UIView alloc] init]];
    [self.view setBackgroundColor:[UIColor grayColor]];

    UITextField *textField = [[UITextField alloc] init];
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField addTarget:self action:@selector(queryChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:textField];
    [[textField leadingAnchor] constraintEqualToAnchor:[self.view leadingAnchor]].active = YES;
    [[textField topAnchor] constraintEqualToAnchor:[self.topLayoutGuide bottomAnchor]].active = YES;
    [[textField widthAnchor] constraintEqualToAnchor:[self.view widthAnchor]].active = YES;

    tableView = [[UITableView alloc] init];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    [tableView setDataSource:self];
    [tableView registerClass:[SuggestionCell class] forCellReuseIdentifier:suggestionCellIdentifier];
    [self.view addSubview:tableView];
    [[tableView leadingAnchor] constraintEqualToAnchor:[self.view leadingAnchor]].active = YES;
    [[tableView topAnchor] constraintEqualToAnchor:[textField bottomAnchor]].active = YES;
    [[tableView widthAnchor] constraintEqualToAnchor:[self.view widthAnchor]].active = YES;
    [[tableView bottomAnchor] constraintEqualToAnchor:[self.bottomLayoutGuide topAnchor]].active = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [suggestions[query] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:suggestionCellIdentifier];

    [cell.textLabel setText:suggestions[query][indexPath.row]];

    return cell;
}

- (void)queryChanged:(id)sender {
    UITextField *textField = sender;
    if(textField) {
        query = [textField.text lowercaseString];
        [tableView reloadData];
    }
}

@end
