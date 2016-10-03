#import "CityWeatherTableViewController.h"
#import "CityWeatherDataProvider.h"

@interface CityWeatherTableViewController ()

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) CityWeatherDataProvider *dataProvider;

@end

@implementation CityWeatherTableViewController

-(id)initWithCity:(NSString *)cityName
{
    self = [self init];
    if(self)
    {
        _cityName = cityName;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.cityName;
    
    [self startNetworkRequestWithDelegate:self cityName:self.cityName];
}

- (void)startNetworkRequestWithDelegate:(id)delegate cityName:(NSString *)cityName {
    self.dataProvider = [CityWeatherDataProvider new];
    [self.dataProvider startNetworkRequestWithDelegate:delegate cityName:cityName];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataProvider.maxTempsForCity count];
}

- (void)didReceiveData {
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.textLabel.text = [self.dataProvider weatherForCityAtIndex:indexPath.row];
    
    return cell;
}

@end
