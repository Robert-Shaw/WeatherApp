#import "CityWeatherDataProvider.h"

@implementation CityWeatherDataProvider

- (void)startNetworkRequestWithDelegate:(id)delegate cityName:(NSString *)cityName {
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString: [NSString stringWithFormat:@"http://api.worldweatheronline.com/premium/v1/weather.ashx?q=%@&format=json&num_of_days=5&key=fc5d2e78218d43dfac4142824160609", cityName]]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    [connection start];
}

@end
