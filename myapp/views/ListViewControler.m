//
//  ListViewControler.m
//  myapp
//
//  Created by José Victor on 01/03/18.
//  Copyright © 2018 José Victor. All rights reserved.
//

#import "ListViewControler.h"
#import "AFNetworking.h"
#import "Generic.h"
#import "GenericTableViewCell.h"


@implementation ListViewControler

@synthesize tableData;

//- (IBAction)logout:(id)sender {
//    NSLog(@"%@",self.navigationController.viewControllers);
//
//    [self.navigationController popToRootViewControllerAnimated: TRUE];
//}
// https://restcountries.eu/rest/v2/all?fields=name




- (void)viewDidLoad{
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.tableData = [NSMutableArray new];
    [self loadData: self.tableView];
    [super viewDidLoad];
}

- (void) loadData:(UITableView *) tableView{
    
    NSString *URLString = @"https://restcountries.eu/rest/v2/all?fields=name;capital;region;languages";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET: URLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *myDictionary = responseObject;
//        self.tableData = [NSMutableArray arrayWithCapacity: [myDictionary count]];
        
        
        //NSDictionary *parameters = @{@"name": @"capital", @"currencies": @[@1, @2, @3]};
        for (id key in myDictionary) {
            Generic *obj = [[Generic alloc] init];
            obj.countryName = [key objectForKey:@"name"];
            obj.countryCapital = [key objectForKey:@"capital"];
            obj.countryRegion = [key objectForKey:@"region"];
            obj.countryLenguage = [[[key objectForKey:@"languages"] valueForKey:@"nativeName"] objectAtIndex:0];
            obj.rating = 3;
            [self.tableData addObject: obj];
        }
        [self.tableView reloadData];
    }
    failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"GenericCell";
    GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier forIndexPath:indexPath];
    Generic *generic = [tableData objectAtIndex:indexPath.row];
    cell.lblContent1.text = generic.countryName;
    cell.lblContent2.text = generic.countryCapital;
    return cell;
}

- (IBAction)logout:(id)sender {
    NSLog(@"%@",self.navigationController.viewControllers);
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated: true completion:nil];
}

- (IBAction)addCountry:(id)sender {
    AddCountryViewController *country = [self.storyboard instantiateViewControllerWithIdentifier: @"countrys"];
    country.delegate = self;
    [self.navigationController pushViewController:country animated:YES];
}

// Implement the method didMoveToParentViewController
-(void)didMoveToParentViewController:(UIViewController *)parent{
    [self.tableView reloadData];
}

-(void)addCountries:(Generic *) country{
    [tableData addObject:country];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Generic *generic = [tableData objectAtIndex:indexPath.row];
    DetailViewController *details = [self.storyboard instantiateViewControllerWithIdentifier: @"details"];
    details.country = generic;
    [self.navigationController pushViewController:details animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
