//
//  Spot.h
//  Google Maps iOS Example
//
//  Created by Colin Edwards on 2/1/14.
//  Clase para manejar los elementos en el mapa.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
#import "GClusterItem.h"
#import "ModelPromotion.h"

/*!
 * @brief Elemento que representa un punto en el mapa.
 */
@interface Spot : NSObject <GClusterItem>

/*!
 * @brief Objeto tipo location para manejar las coordenadas
 */
@property (nonatomic) CLLocationCoordinate2D location;

/*!
 * @brief String con la imagen que debe mostrar el marcador
 */
@property (nonatomic) NSString* image;

/*!
 * @brief Objeto tipo promocion
 */
@property (nonatomic) ModelPromotion* promotion;

@end
