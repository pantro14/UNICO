//
//  CustomMarker.h
//  Google Maps iOS Example
//
//  Created by Francisco Garcia on 11/3/14.
//
//  Clase que representa un marcador en el mapa
//

#import <GoogleMaps/GoogleMaps.h>
#import "GCluster.h"
#import "ModelPromotion.h"

@interface CustomMarker : GMSMarker

/*!
 * @brief Elemento de Cluster
 */
@property(nonatomic,weak) id <GCluster> cluster;

/*!
 * @brief Indica si el marcador permite mostrar POPUP
 */
@property(nonatomic) BOOL popEnable;

/*!
 * @brief Objeto de la Promocion
 */
@property(nonatomic,weak) ModelPromotion* promotion;

/*!
 * @brief Array con los Objetos tipo Promocion 
 */
@property(nonatomic,strong) NSMutableArray* data;

@end
