//
//  UIImageViewAsyn.m
//  cacheImagenes
//
//  Created by Ruben on 25/01/15.
//  Copyright (c) 2015 AppAndWeb. All rights reserved.
//

#import "UIImageViewAsyn.h"

@implementation UIImageViewAsyn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Carga asíncrona
-(void)loadFromUrl:(NSString*)url {
    pathImagen = url;
    // Se busca si existe la imagen
    // La función buscarImagenCache está implementada más abajo
    UIImage *imagen = [self buscarImagenCache:url];
    if (imagen == NULL){
        // Creamos el buffer donde se almacenarán los datos
        imageData = [[NSMutableData alloc] init];
        // Añadimos el http:// para la conexion
        url = [NSString stringWithFormat:@"http://%@", url];
        // Creamos la URL
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *urlLimpia = [url stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSURL* urlImage = [NSURL URLWithString:urlLimpia];
        // Creamos la conexión de datos
        NSURLRequest *request = [NSURLRequest requestWithURL:urlImage
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:15.0];
        // Lanzamos la conexión
        imageConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }else{
        [self setImage: imagen];
    }
}

/**
 *  Recepción de datos asíncrona
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [imageData appendData:data];
}

/**
 *  La conexión finaliza con error; imagen no descargada
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    imageData = nil;
    imageConnection = nil;
    //NSLog(@"Error en la carga: %@", error.description);
}

/**
 *  Conexión finaliza con éxito; imagen descargada
 */
-(void)connectionDidFinishLoading:(NSURLConnection*)connection {
    UIImage *imagen = [UIImage imageWithData:imageData];
    // Se almacena la imagen en el dispositivo
    [self almacenarImagen: imagen];
    // Se asigna la imagen al UIImageView y por tanto se mostrará
    [self setImage: imagen];
    imageData = nil;
    imageConnection = nil;
}

/*
 * Resescala una imagen al ancho del iphone 5S manteniendo las proporciones
 *
 */
- (UIImage *)convertSize:(UIImage *)image{
    // Para reescalarla y mantener las proporciones se calcula el nuevo tamaño proporcinal
    // width --> 320 // Ancho del iphone
    float height = (320 * image.size.height) / image.size.width;
    CGSize newSize = image.size;
    newSize.width = 320;
    newSize.height = height;
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

-(void) almacenarImagen: (UIImage *) imagen{
    // Se extrae el nombre de la imagen
    NSString *nombreImagen = [self extraerNombreImagen];
    if ([nombreImagen length] > 0){
        // Se reescala
        imagen = [self convertSize: imagen];
        // Se convierte a png
        NSData *imgData = UIImagePNGRepresentation(imagen);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nombreImagen]];
        // Se escribe la imagen en disco
        if (![imgData writeToFile:imagePath atomically:NO])
        {
            NSLog(@"Fallo al cachear la imagen");
        }
        else
        {
            NSLog(@"La imagen ha sido cacheada. Path: %@",imagePath);
        }
    }
}

/*
 * Extraer nombre imagen.
 * Extre el nombre de la imagen que se encuentra en la url
 * www.appandweb.es/miimagen.jpj
 * Devolvería miimagen
 *
 */
-(NSString *) extraerNombreImagen{
    NSString *nombreImagen = @"";
    // Se para la URL por /
    NSArray *lines = [pathImagen componentsSeparatedByString: @"/"];
    if ([lines count] == 3){
        // Extrae la ultima parte de la url
        nombreImagen = lines[2];
        // Comprueba si el formato es correcto
        if ([nombreImagen rangeOfString:@"png"].location != NSNotFound ||
            [nombreImagen rangeOfString:@"jpg"].location != NSNotFound ||
            [nombreImagen rangeOfString:@"jpeg"].location != NSNotFound) {
            NSRange range = [nombreImagen rangeOfString:@".png"];
            if (range.location == NSNotFound) {
                range = [nombreImagen rangeOfString:@".jpg"];
                if (range.location == NSNotFound) {
                    range = [nombreImagen rangeOfString:@".jpeg"];
                }
            }
            // Elimina la extensión
            NSRange searchRange = NSMakeRange(0 , range.location);
            nombreImagen = [nombreImagen substringWithRange:searchRange];
        }
    }
    return nombreImagen;
}

/*
 * Buscar Imagen Cache.
 * Estrae en nombre de la imagen y busca si se ha almacenado anteriormente
 * En el caso de no existir devuelve NULL
 */
-(UIImage *) buscarImagenCache: (NSString *) path{
    UIImage *customImage = NULL;
    NSString *nombreImagen = [self extraerNombreImagen];
    if ([nombreImagen length] > 0){
        // Extrae el path de la imagenes
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nombreImagen]];
        // Intenta cargar la imagen
        customImage = [UIImage imageWithContentsOfFile: imagePath];
    }
    
    return customImage;
}


@end
