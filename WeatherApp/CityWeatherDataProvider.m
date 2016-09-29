#import "CityWeatherDataProvider.h"

@interface CityWeatherDataProvider ()

@property (nonatomic, strong) NSMutableData *responseData;
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
    if ([self.delegate respondsToSelector:@selector(didReceiveData:)]) {
        [self.delegate didReceiveData:data];
    }
}

@end
