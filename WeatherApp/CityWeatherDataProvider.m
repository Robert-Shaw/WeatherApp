#import "CityWeatherDataProvider.h"

@interface CityWeatherDataProvider ()

@property (nonatomic, strong) NSMutableArray *maxTempsForCity;
@property (nonatomic, strong) NSMutableArray *maxTempDatesForCity;
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

- (void)startNetworkRequestWithDelegate:(id<CityWeatherDataProviderDelegate>)delegate cityName:(NSString *)cityName {
    self.delegate = delegate;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString: [NSString stringWithFormat:@"http://api.worldweatheronline.com/premium/v1/weather.ashx?q=%@&format=json&num_of_days=5&key=fc5d2e78218d43dfac4142824160609", cityName]]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
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
    
    if ([self.delegate respondsToSelector:@selector(didReceiveData:)]) {
        [self.delegate didReceiveData:self.responseData];
    }
    
}

@end
