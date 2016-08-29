//
//  ModelBrand.m
//  Unico Final
//
//  Created by Francisco Garcia on 11/8/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "ModelBrand.h"

@implementation ModelBrand

// Inicializacion rapida de los GET y SET
@synthesize brandId,brandName,brandImage;

/*!
 * @brief Metodo para crear una marca desde Json
 * @param dictionary, Json con la informacion de la marca
 * @return void
 */
- (void) populateWithJson:(NSDictionary*) dictionary
{
    brandName=[dictionary objectForKey:@"sname"];
    brandId =[[dictionary objectForKey:@"nreference"] integerValue];
    brandImage=[dictionary objectForKey:@"simage"];

}

@end
