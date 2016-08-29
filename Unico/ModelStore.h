//
//  ModelStore.h
//  Unico Final
//
//  Created by Datatraffic on 10/7/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase que representa una tienda
//

#import <Foundation/Foundation.h>

@interface ModelStore : NSObject

/*!
 * @brief Id de la tienda
 */
@property(nonatomic)int storeId;

/*!
 * @brief Nombre de la Tienda
 */
@property(nonatomic,strong)NSString *storeName;

/*!
 * @brief Imagen de la tienda
 */
@property(nonatomic,strong)NSString *storeImage;

/*!
 * @brief Descripcion de la tienda
 */
@property(nonatomic,strong)NSString *storeDescription;

/*!
 * @brief Numero de likes que tiene la tienda
 */
@property(nonatomic)int storeLikes;

/*!
 * @brief Id del local
 */
@property(nonatomic)int idlocal;
/*!
 * @brief Numero del local
 */
@property(nonatomic,strong)NSString *numlocal;
/*!
 * @brief Latitud donde esta ubicado el local
 */
@property(nonatomic)float latitude;
/*!
 * @brief Longitud donde esta ubicado el local
 */
@property(nonatomic)float longitude;
/*!
 * @brief Piso donde esta ubicado el local
 */
@property(nonatomic)int floor;
/*!
 * @brief Categorias de la tienda
 */
@property(nonatomic,strong) NSMutableArray* StoreCategories;
/*!
 * @brief Si la tienda tiene like del usuario
 */
@property(nonatomic)BOOL liked;


/*!
 * @brief Metodo para crear una tienda desde un json.
 */
- (void) populateWithJson:(NSDictionary *)dictionary;

/*!
 * @brief Metodo para convetir a string el objeto
 */
- (NSString *) convertToString;

/*!
 * @brief Metodo para crear una tienda por parametros
 */
- (void) populateWithName:(NSString*)sName image:(NSString*)sImage description:(NSString*)sDescription likes:(int)sLikes id:(int)sid latitude:(float)sLatitude longitude:(float)sLongitude floor:(int)sfloor numlocal:(NSString*)snumlocal;

@end
