//
//  ModelBrand.h
//  Unico Final
//
//  Created by Francisco Garcia on 11/8/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBrand : NSObject

/*!
 * @brief Id de la Marca
 */
@property(nonatomic)int brandId;
/*!
 * @brief Nombre de la Marca
 */
@property(nonatomic,strong)NSString *brandName;
/*!
 * @brief Imagen de la Marca
 */
@property(nonatomic,strong)NSString *brandImage;

/*!
 * @brief Metodo para crear una marca desde Json
 * @param dictionary, Json con la informacion de la marca
 * @return void
 */
- (void) populateWithJson:(NSDictionary*) json;


@end
