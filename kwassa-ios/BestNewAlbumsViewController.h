//
//  BestNewAlbumsViewController.h
//  kwassa-ios
//
//  Created by Andoni Mendoza on 11/15/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import "ViewController.h"

@interface BestNewAlbumsViewController : ViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *yearPicker;

- (IBAction)updateYear:(id)sender;



@end
