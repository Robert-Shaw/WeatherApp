#import <Foundation/Foundation.h>
#import "WeatherItem.h"

@protocol CityWeatherDataProviderDelegate <NSObject>

- (void)didReceiveData;

@end

@interface CityWeatherDataProvider : NSObject

- (void)startNetworkRequestWithDelegate:(id<CityWeatherDataProviderDelegate>)delegate cityName:(NSString *)cityName;
- (NSString *)weatherForCityAtIndex:(NSInteger)index;
- (NSUInteger)numberOfRowsToDisplay;

@end
