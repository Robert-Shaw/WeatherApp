#import <UIKit/UIKit.h>
#import "CityWeatherDataProvider.h"

@interface CityWeatherTableViewController : UITableViewController <CityWeatherDataProviderDelegate>

- (id)initWithCity:(NSString *)cityName;

@end
