#import "CityWeatherDataProvider.h"

@interface CityWeatherDataProvider ()

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSString *cityNameFromService;
@property (nonatomic, weak) id delegate;

@end

@implementation CityWeatherDataProvider

- (NSMutableData *)responseData {
    if (_responseData) {
        return _responseData;
    }
    _responseData = [NSMutableData data];
    return _responseData;
}

- (NSURLRequest *)makeRequestWithCityName:(NSString *)cityName {
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString: [NSString stringWithFormat:@"http://api.worldweatheronline.com/premium/v1/weather.ashx?q=%@&format=json&num_of_days=5&key=fc5d2e78218d43dfac4142824160609", cityName]]];
    return request;
}

- (void)startNetworkRequest:(NSURLRequest *)request {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      [self didReceiveData:data];
                                  }];
    
    [task resume];
}

- (void)startNetworkRequestWithDelegate:(id<CityWeatherDataProviderDelegate>)delegate cityName:(NSString *)cityName {
    self.delegate = delegate;
    
    NSURLRequest *request;
    request = [self makeRequestWithCityName:cityName];
    
    [self startNetworkRequest:request];
}

- (void)didReceiveData:(NSData *)data {
    [self parseResponseData:data];
}

- (void)parseResponseData:(NSData *)data {
    
    self.maxTempsForCity = [[NSMutableArray alloc] init];
    self.maxTempDatesForCity = [[NSMutableArray alloc] init];
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&myError];
    
    // Retrieve Error
    NSDictionary *results = [res objectForKey:@"data"];
    NSDictionary *error = [results objectForKey:@"error"];
    
    if(error)
    {
        [self.maxTempsForCity addObject:@"No data to return for the selected city"];
        [self.maxTempDatesForCity addObject:@""];
    }
    
    // Retrieve City Name
    NSDictionary *request = [results objectForKey:@"request"];
    self.cityNameFromService = [request valueForKey:@"query"];
    
    // Retrieve temp and date
    NSDictionary *currentWeather= [results objectForKey:@"weather"];
    for (NSDictionary *maxTemp in currentWeather) {
        NSString *maxTempforCity = [maxTemp objectForKey:@"maxtempC"];
        [self.maxTempsForCity addObject:maxTempforCity];
        NSString *maxTempDate = [maxTemp objectForKey:@"date"];
        [self.maxTempDatesForCity addObject:maxTempDate];
    }
    
    if ([self.delegate respondsToSelector:@selector(didReceiveData)]) {
        [self.delegate didReceiveData];
    }
}

@end
