//
//  ModelPromotion.h
//  Unico Final
//
//  Created by Datatraffic on 10/7/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase que representa una promocion
//

#import <Foundation/Foundation.h>
#import "ModelStore.h"
#import "JSON.h"

@interface ModelPromotion : NSObject

/*!
 * @brief ID de la promocion
 */
@property(nonatomic)int promotionId;
/*!
 * @brief Id de la tienda
 */
@property(nonatomic)int storeId;
/*!
 * @brief Nombre de la promocion
 */
@property(nonatomic,strong)NSString *promotionNames;
/*!
 * @brief Descuento de la promocion
 */
@property(nonatomic,strong)NSString *promotionDiscount;
/*!
 * @brief Imagen de la promocion
 */
@property(nonatomic,strong)NSString *promotionImage;
/*!
 * @brief Descipcion de la promocion
 */
@property(nonatomic,strong)NSString *promotionDescription;
/*!
 * @brief Tienda de la promocion
 */
@property(nonatomic,strong)NSString *promotionStore;
/*!
 * @brief Categoria de la promocion
 */
@property(nonatomic)int promotionCategory;
/*!
 * @brief Prioridad de la promocion
 */
@property(nonatomic)int promotionPriority;
/*!
 * @brief Si se hizo swipe sobre la promocion
 */
@property(nonatomic)BOOL swipe;
/*!
 * @brief Si el usuario le dio like a la promocion
 */
@property(nonatomic)BOOL liked;
/*!
 * @brief Numero de likes de la promocion
 */
@property(nonatomic)int promotionLikes;
/*!
 * @brief Objeto que representa la Tienda
 */
@property(nonatomic)ModelStore* store;

/*!
 * @brief Numero de likes del evento
 * @param swipe, boolean si  el usuario hizo swipe o no
 * @return Void
 */
- (void) setSwipe:(BOOL)swipe;

/*!
 * @brief Crea una promocion desde un json
 * @param json, Json con la informacion de una promocion
 * @return Void
 */
- (void) populateWithJson:(NSDictionary*) json;

/*!
 * @brief Crear una promocion por parametros
 * @param Datos de la promocion
 * @return Void
 */
- (void) populateWithName:(NSString*)pName discount:(NSString*)pDiscount image:(NSString*)pImage description:(NSString*)pDescription store:(NSString*)pStore likes:(int)pLikes id:(int)pid storeId:(int)pStoreId ;

/*!
 * @brief Metodo que convierte una promocion a string
 * @return NSString, la promocion como un string
 */
- (NSString *) convertToString;

/*!
 * @brief Metodo que retorna la latitud de la promcion.
 * @return Void
 */
- (float) getLatitude;

/*!
 * @brief Metodo que retorna la longitud de la promcion.
 * @return Void
 */
- (float) getLongitude;

@end
