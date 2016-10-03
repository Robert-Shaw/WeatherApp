//
//  CityWeatherTableViewController.m
//  WeatherApp
//
//  Created by Robert Shaw on 2016/09/05.
//  Copyright © 2016 com.glucode.corp. All rights reserved.
//

#import "CityWeatherTableViewController.h"
#import "CityWeatherDataProvider.h"

@interface CityWeatherTableViewController ()

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) CityWeatherDataProvider *dataProvider;

@end

@implementation CityWeatherTableViewController

-(id)initWithCity:(NSString *)cityName
{
    self = [self init];
    if(self)
    {
        _cityName = cityName;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.cityName;
    
    [self startNetworkRequestWithDelegate:self cityName:self.cityName];
}

- (void)startNetworkRequestWithDelegate:(id)delegate cityName:(NSString *)cityName {
    self.dataProvider = [CityWeatherDataProvider new];
    [self.dataProvider startNetworkRequestWithDelegate:delegate cityName:cityName];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataProvider.maxTempsForCity count];
}

- (void)didReceiveData {
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    NSString *temp = [self.dataProvider.maxTempsForCity objectAtIndex:indexPath.row];
    NSString *date = [self.dataProvider.maxTempDatesForCity objectAtIndex:indexPath.row];
    NSString *stringsCombined;
    
    if(![date isEqualToString:@""])
    {
        stringsCombined = [NSString stringWithFormat:@"Degrees: %@    Date: %@", temp, date];
        
    } else {
        
        stringsCombined = [NSString stringWithFormat:@"%@", temp];
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.textLabel.text = stringsCombined;
    
    return cell;
}
@end
