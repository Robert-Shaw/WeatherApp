//
//  CityWeatherTableViewController.h
//  WeatherApp
//
//  Created by Robert Shaw on 2016/09/05.
//  Copyright © 2016 com.glucode.corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityWeatherTableViewController : UITableViewController<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

-(id)initWithCity:(NSString *)cityName;

@end
