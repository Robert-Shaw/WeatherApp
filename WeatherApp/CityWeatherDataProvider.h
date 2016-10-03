#import <Foundation/Foundation.h>

@protocol CityWeatherDataProviderDelegate <NSObject>

- (void)didReceiveData;

@end

@interface CityWeatherDataProvider : NSObject

@property (nonatomic, strong) NSMutableArray *maxTempsForCity;
@property (nonatomic, strong) NSMutableArray *maxTempDatesForCity;

- (void)startNetworkRequestWithDelegate:(id<CityWeatherDataProviderDelegate>)delegate cityName:(NSString *)cityName;
- (NSString *)weatherForCityAtIndex:(NSInteger)index;

@end
