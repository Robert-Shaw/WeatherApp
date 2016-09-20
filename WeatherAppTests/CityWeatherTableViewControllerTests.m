#import <XCTest/XCTest.h>
#import "CityWeatherTableViewController.h"
#import "CityWeatherTableViewController_TestingPrivates.h"

@interface CityWeatherTableViewControllerTests : XCTestCase

@property (nonatomic, strong) CityWeatherTableViewController *cityWeatherTableViewController;

@end

@implementation CityWeatherTableViewControllerTests

- (void)testThatItPopulatesResponseData {
    // given
    self.cityWeatherTableViewController = [[CityWeatherTableViewController alloc] initWithNibName:nil bundle:nil];
    
    // when
    [self.cityWeatherTableViewController view];
    [self.cityWeatherTableViewController connectionDidFinishLoading:nil];
    
    // then
    XCTAssertNotNil(self.cityWeatherTableViewController.responseData);
}

@end
