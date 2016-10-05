#import <Foundation/Foundation.h>

@interface WeatherItem : NSObject

@property (nonatomic, readonly) NSString *date;
@property (nonatomic, readonly) int temperature;

- (instancetype)initWithMaxTemperature:(int)temperature forDateString:(NSString *)dateString;

@end
