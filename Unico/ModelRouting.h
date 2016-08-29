//
//  ModelRouting.h
//  Unico Final
//
//  Created by Francisco Garcia on 11/4/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase que representa una ruta
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface ModelRouting : NSObject

/*!
 * @brief Orden de la ruta
 */
@property(nonatomic)int order;
/*!
 * @brief Piso de la Ruta
 */
@property(nonatomic)int floor;
/*!
 * @brief Geometria de la ruta
 */
@property(nonatomic,strong)NSString *geometry;

//StartPoint
/*!
 * @brief Latitud del punto de inicio
 */
@property(nonatomic)float sLatitude;
/*!
 * @brief Longitud del punto inicio
 */
@property(nonatomic)float sLongitude;
/*!
 * @brief Tipo de punto de inicio
 */
@property(nonatomic,strong)NSString *sType;

//EndPoint
/*!
 * @brief Latitud del punto final
 */
@property(nonatomic)float eLatitude;
/*!
 * @brief Longitud del punto final
 */
@property(nonatomic)float eLongitude;
/*!
 * @brief Tipo de punto final
 */
@property(nonatomic,strong)NSString *eType;

/*!
 * @brief Metodo para crear una ruta desde Json
 * @param dictionary, Json con la informacion de la Ruta
 * @return void
 */
- (void) populateWithJson:(NSDictionary *)dictionary;

/*!
 * @brief Metodo para crear una ruta por parametros
 * @param Datos de una ruta
 * @return void
 */
- (void) populateWithOrder:(int)nOrder floor:(int) nfloor geometry:(NSString*)nGeometry sLatitude:(float)nsLatitude sLongitude:(float) nsLongitude sType:(NSString*)nsType eLatitude:(float)neLatitude eLongitude:(float)neLongitude eType:(NSString*)neType;

/*!
 * @brief Metodo que indica si la ruta es el punto inicial de uan ruta total
 * @return BOOL, si es punto de inicio
 */
- (BOOL) iamStratPoint;

@end
