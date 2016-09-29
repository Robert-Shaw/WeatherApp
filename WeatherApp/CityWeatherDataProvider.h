#import <Foundation/Foundation.h>

@interface CityWeatherDataProvider : NSObject

@property (nonatomic, strong) NSMutableData *responseData;

- (void)startNetworkRequestWithDelegate:(id)delegate cityName:(NSString *)cityName;

@end
