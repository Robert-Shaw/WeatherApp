#import <XCTest/XCTest.h>
#import "CityWeatherTableViewController.h"
#import "CityWeatherTableViewController_TestingPrivates.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>

@interface CityWeatherTableViewControllerTests : XCTestCase

@property (nonatomic, strong) CityWeatherTableViewController *cityWeatherTableViewController;

@end

@implementation CityWeatherTableViewControllerTests

- (void)testThatItPopulatesResponseData {
    // given
    NSString *cityName = @"Pretoria";
    self.cityWeatherTableViewController = [[CityWeatherTableViewController alloc] initWithCity:cityName];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        if ([request.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"http://api.worldweatheronline.com/premium/v1/weather.ashx?q=%@&format=json&num_of_days=5&key=fc5d2e78218d43dfac4142824160609", cityName]]) {
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"weatherResponse.json", self.class) statusCode:200 headers:nil];
    }];
        
    // when
    [self.cityWeatherTableViewController view];
    [self.cityWeatherTableViewController connectionDidFinishLoading:nil];
    
    // then
    XCTAssertNotNil(self.cityWeatherTableViewController.responseData);
}

@end
