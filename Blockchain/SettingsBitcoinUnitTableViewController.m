//
//  SettingsBitcoinUnitTableViewController.m
//  Blockchain
//
//  Created by Kevin Wu on 7/22/15.
//  Copyright (c) 2015 Qkos Services Ltd. All rights reserved.
//

#import "SettingsBitcoinUnitTableViewController.h"
#import "AppDelegate.h"

@interface SettingsBitcoinUnitTableViewController ()
@property (nonatomic, copy) NSArray *keysArray;
@property (nonatomic, copy) NSArray *namesArray;
@property (nonatomic) CurrencySymbol *currentCurrencySymbol;
@property (nonatomic) NSString *selectedCurrencyCode;
@end

@implementation SettingsBitcoinUnitTableViewController

- (void)alertForErrorLoadingSettings
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:BC_STRING_SETTINGS_ERROR_LOADING_TITLE message:BC_STRING_SETTINGS_ERROR_LOADING_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:BC_STRING_OK style:UIAlertActionStyleCancel handler:nil]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ANIMATION_DURATION_LONG * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (CurrencySymbol *)getBtcSymbolFromLatestResponse
{
    return app.latestResponse.symbol_btc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SettingsNavigationController *navigationController = (SettingsNavigationController *)self.navigationController;
    navigationController.headerLabel.text = BC_STRING_SETTINGS_BTC;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self changeCurrencySymbol:self.selectedCurrencyCode];
}

- (void)changeCurrencySymbol:(NSString *)code
{
    [app.wallet changeBtcCurrency:code];
}

- (void)setItemsDictionary:(NSDictionary *)itemsDictionary
{
    _itemsDictionary = itemsDictionary;
    self.keysArray = [[_itemsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    self.namesArray = [[_itemsDictionary allValues] sortedArrayUsingSelector:@selector(compare:)];

    self.currentCurrencySymbol = [self getBtcSymbolFromLatestResponse];
    
    NSString *loadedCurrencySymbol = [self getBtcSymbolFromLatestResponse].name;
    
    NSArray *temporaryArray = [self.itemsDictionary allKeysForObject:loadedCurrencySymbol];
    NSString *preferredCurrencySymbol = [temporaryArray firstObject];
    
    if (preferredCurrencySymbol == nil) {
        [self alertForErrorLoadingSettings];
    } else {
        self.selectedCurrencyCode = preferredCurrencySymbol;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.keysArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = self.namesArray[indexPath.row];

    NSString *currencyCode = [[self.itemsDictionary allKeysForObject:cell.textLabel.text] firstObject];
    
    if ([currencyCode isEqualToString:self.selectedCurrencyCode]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *currencyCode = [[self.itemsDictionary allKeysForObject:self.namesArray[indexPath.row]] firstObject];
    
    self.selectedCurrencyCode = currencyCode;
    
    [self.tableView reloadData];
}


@end
