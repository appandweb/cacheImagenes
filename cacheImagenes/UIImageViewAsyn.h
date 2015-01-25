//
//  UIImageViewAsyn.h
//  cacheImagenes
//
//  Created by Ruben on 25/01/15.
//  Copyright (c) 2015 AppAndWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageViewAsyn : UIImageView<NSURLConnectionDelegate>{
    NSURLConnection *imageConnection;
    NSMutableData *imageData;
    NSString *pathImagen;
}

-(void)loadFromUrl:(NSString*)url;

@end
