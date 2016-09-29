#import <Foundation/Foundation.h>

@protocol CityWeatherDataProviderDelegate <NSObject>

- (void)didReceiveData:(NSData *)data;

@end

@interface CityWeatherDataProvider : NSObject

@property (nonatomic, strong) NSMutableData *responseData;

- (void)startNetworkRequestWithDelegate:(id<CityWeatherDataProviderDelegate>)delegate cityName:(NSString *)cityName;

@end
