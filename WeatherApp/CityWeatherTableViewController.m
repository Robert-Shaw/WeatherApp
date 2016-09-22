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
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSMutableArray *maxTempsForCity;
@property (nonatomic, strong) NSMutableArray *maxTempDatesForCity;
@property (nonatomic, strong) NSString *cityNameFromService;

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
    
    self.maxTempsForCity = [[NSMutableArray alloc] init];
    self.maxTempDatesForCity = [[NSMutableArray alloc] init];
    
    self.responseData = [NSMutableData data];
    [self startNetworkRequestWithDelegate:self cityName:self.cityName];
}

- (void)startNetworkRequestWithDelegate:(id)delegate cityName:(NSString *)cityName {
    CityWeatherDataProvider *dataProvider = [CityWeatherDataProvider new];
    [dataProvider startNetworkRequestWithDelegate:delegate cityName:cityName];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.maxTempsForCity count];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    [self.tableView reloadData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // Retrieve Error
    NSDictionary *results = [res objectForKey:@"data"];
    NSDictionary *error = [results objectForKey:@"error"];
    
    // Retrieve City Name
    NSDictionary *request = [results objectForKey:@"request"];
    self.cityNameFromService = [request valueForKey:@"query"];
    
    if(error)
    {
        [self.maxTempsForCity addObject:@"No data to return for the selected city"];
        [self.maxTempDatesForCity addObject:@""];
    }
    
    // Retrieve temp and date
    NSDictionary *currentWeather= [results objectForKey:@"weather"];
    for (NSDictionary *maxTemp in currentWeather) {
        NSString *maxTempforCity = [maxTemp objectForKey:@"maxtempC"];
        [self.maxTempsForCity addObject:maxTempforCity];
        NSString *maxTempDate = [maxTemp objectForKey:@"date"];
        [self.maxTempDatesForCity addObject:maxTempDate];
    }
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    NSString *temp = [self.maxTempsForCity objectAtIndex:indexPath.row];
    NSString *date = [self.maxTempDatesForCity objectAtIndex:indexPath.row];
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
