#import <Foundation/Foundation.h>

@interface CityWeatherDataProvider : NSObject

- (void)startNetworkRequestWithDelegate:(id)delegate cityName:(NSString *)cityName;

@end
