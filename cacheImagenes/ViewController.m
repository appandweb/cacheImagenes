//
//  ViewController.m
//  cacheImagenes
//
//  Created by Ruben on 25/01/15.
//  Copyright (c) 2015 AppAndWeb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pathImagenes = [[NSMutableArray alloc] init];
    [pathImagenes addObject:@"www.appandweb.es/imagenes/appweb-01.png"];
    [pathImagenes addObject:@"www.appandweb.es/imagenes/appweb-02.jpg"];
    [pathImagenes addObject:@"www.appandweb.es/imagenes/appweb-03.jpg"];
    [pathImagenes addObject:@"www.appandweb.es/imagenes/appweb-04.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pathImagenes count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    celdaPersonalizadaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[celdaPersonalizadaTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    [cell.iVCelda loadFromUrl: [pathImagenes objectAtIndex: indexPath.row] ];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    
    return cell;
}

@end
