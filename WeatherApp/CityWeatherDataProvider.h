#import <Foundation/Foundation.h>
#import "WeatherItem.h"

@protocol CityWeatherDataProviderDelegate <NSObject>

- (void)didReceiveData;

@end

@interface CityWeatherDataProvider : NSObject

@property (nonatomic, strong) NSMutableArray *maxTempsForCity;
@property (nonatomic, strong) NSMutableArray *maxTempDatesForCity;
@property (nonatomic, strong) NSMutableArray <WeatherItem *> *weatherItemArray;

- (void)startNetworkRequestWithDelegate:(id<CityWeatherDataProviderDelegate>)delegate cityName:(NSString *)cityName;
- (NSString *)weatherForCityAtIndex:(NSInteger)index;

@end
