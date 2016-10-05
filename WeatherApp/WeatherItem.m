#import "WeatherItem.h"

@implementation WeatherItem

- (instancetype)initWithMaxTemperature:(int)temperature forDateString:(NSString *)dateString {
    self = [super init];
    if (self) {
        _date = dateString;
        _temperature = temperature;
    }
    return self;
}

@end
