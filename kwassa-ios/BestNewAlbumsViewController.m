//
//  BestNewAlbumsViewController.m
//  kwassa-ios
//
//  Created by Andoni Mendoza on 11/15/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import "BestNewAlbumsViewController.h"
#import "AlbumsCollectionViewController.h"

@interface BestNewAlbumsViewController ()

@end

@implementation BestNewAlbumsViewController

NSArray* years;
NSString* yearSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.yearPicker.delegate = self;
    self.yearPicker.dataSource = self;
    years = [NSArray arrayWithObjects:@"2014", @"2013", @"2012", @"2011", @"2010", @"2009", @"2008", @"2007", @"2006", @"2005", @"2004", @"2003", nil];
    
    yearSelected = @"2014";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return years.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [years objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    yearSelected = [years objectAtIndex:row];
}

- (IBAction)updateYear:(id)sender {
    AlbumsCollectionViewController* albumsCollectionViewController = self.childViewControllers[0];
    [albumsCollectionViewController setReviewInfo:yearSelected];
    [albumsCollectionViewController.collectionView reloadData];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    NSLog(@"perparing to unwind segue");
}

@end
