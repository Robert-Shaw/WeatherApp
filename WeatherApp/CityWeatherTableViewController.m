//
//  CityWeatherTableViewController.m
//  WeatherApp
//
//  Created by Robert Shaw on 2016/09/05.
//  Copyright © 2016 com.glucode.corp. All rights reserved.
//

#import "CityWeatherTableViewController.h"

@interface CityWeatherTableViewController ()

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *tableDataMaxTempDate;
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
    
    self.tableData = [[NSMutableArray alloc] init];
    self.tableDataMaxTempDate = [[NSMutableArray alloc] init];
    
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString: [NSString stringWithFormat:@"http://api.worldweatheronline.com/premium/v1/weather.ashx?q=%@&format=json&num_of_days=5&key=fc5d2e78218d43dfac4142824160609", self.cityName]]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
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
        [self.tableData addObject:@"No data to return for the selected city"];
    }
    
    // Retrieve temp and date
    NSDictionary *currentWeather= [results objectForKey:@"weather"];
    for (NSDictionary *maxTemp in currentWeather) {
        NSString *maxTempforCity = [maxTemp objectForKey:@"maxtempC"];
        [self.tableData addObject:maxTempforCity];
        NSString *maxTempDate = [maxTemp objectForKey:@"date"];
        [self.tableDataMaxTempDate addObject:maxTempDate];
    }
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    NSString *temp = [self.tableData objectAtIndex:indexPath.row];
    NSString *date = [self.tableDataMaxTempDate objectAtIndex:indexPath.row];
    
    NSString *stringsCombined = [NSString stringWithFormat:@"Degrees: %@    Date: %@", temp, date];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.textLabel.text = stringsCombined;
    
    return cell;
}
@end
