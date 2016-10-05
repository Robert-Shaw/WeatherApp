#import "CityWeatherDataProvider.h"

@interface CityWeatherDataProvider ()

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableArray <WeatherItem *> *weatherItemArray;

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

- (void)setMaxTempAndDateForCity:(NSDictionary *)currentWeather {
    for (NSDictionary *maxTemp in currentWeather) {
        NSString *maxTempforCity = [maxTemp objectForKey:@"maxtempC"];
        NSString *maxTempDate = [maxTemp objectForKey:@"date"];
        WeatherItem *item = [[WeatherItem alloc] initWithMaxTemperature:[maxTempforCity intValue] forDateString:maxTempDate];
        
        [self.weatherItemArray addObject:item];
    }
}


- (void)addNoWeatherItem {
    WeatherItem *noweatherItem = [[WeatherItem alloc] initWithMaxTemperature:0 forDateString:@"No data to return for the selected city"];
    [self.weatherItemArray addObject:noweatherItem];
}

- (void)parseResponseData:(NSData *)data {
    self.weatherItemArray = [NSMutableArray new];
    
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&myError];
    
    NSDictionary *results = [res objectForKey:@"data"];
    NSDictionary *error = [results objectForKey:@"error"];
    
    //Begin here
    if(error) {
        [self addNoWeatherItem];
    } else {
        NSDictionary *currentWeather= [results objectForKey:@"weather"];
        [self setMaxTempAndDateForCity:currentWeather];
    }
    
    if ([self.delegate respondsToSelector:@selector(didReceiveData)]) {
        [self.delegate didReceiveData];
    }
}

- (NSString *)weatherForCityAtIndex:(NSInteger)index {
    
    WeatherItem *item = [self.weatherItemArray objectAtIndex:index];
    
    NSString *stringsCombined;
    
    if(![item.date isEqualToString:@""])
    {
        stringsCombined = [NSString stringWithFormat:@"Degrees: %d    Date: %@", item.temperature, item.date];
        
    } else {
        
        stringsCombined = [NSString stringWithFormat:@"%d", item.temperature];
    }
    
    return stringsCombined;
}

- (NSUInteger)numberOfRowsToDisplay{
    return [self.weatherItemArray count];
}

@end
