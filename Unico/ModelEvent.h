//
//  ModelEvent.h
//  Unico Final
//
//  Created by Datatraffic on 10/7/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase que representa un evento
//

#import <Foundation/Foundation.h>

@interface ModelEvent : NSObject

/*!
 * @brief Id del evento
 */
@property(nonatomic)int eventId;
/*!
 * @brief Nombre del evente
 */
@property(nonatomic,strong)NSString *eventName;
/*!
 * @brief Imagen del evento
 */
@property(nonatomic,strong)NSString *eventImage;
/*!
 * @brief Descripcion del evento
 */
@property(nonatomic,strong)NSString *eventDescription;
/*!
 * @brief Numero de likes del evento
 */
@property(nonatomic)int eventLikes;
/*!
 * @brief Fecha de inicio del evento
 */
@property(nonatomic,strong)NSString *startDate;
/*!
 * @brief Fecha fin del evento
 */
@property(nonatomic,strong)NSString *endDate;
/*!
 * @brief Indica si hay un swipe sobre el evento
 */
@property(nonatomic)BOOL swipe;
/*!
 * @brief Indica si el usuario le dio like al evento
 */
@property(nonatomic)BOOL liked;
/*!
 * @brief Arreglo de promociones relacionadas al evento
 */
@property(nonatomic,strong) NSMutableArray *promotionsName;

/*!
 * @brief Metodo para crear un evento desde un json
 * @param json, Json para crear un nuevo objeto tipo evento
 * @return void
 */
- (void) populateWithJson:(NSDictionary*) json;

@end
