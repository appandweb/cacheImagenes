//
//  ViewController.h
//  cacheImagenes
//
//  Created by Ruben on 25/01/15.
//  Copyright (c) 2015 AppAndWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "celdaPersonalizadaTableViewCell.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *pathImagenes;
}


@end

