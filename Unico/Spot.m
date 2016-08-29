//
//  Spot.m
//  Google Maps iOS Example
//
//  Created by Colin Edwards on 2/1/14.
//  Implementacion dela clase
//

#import "Spot.h"

@implementation Spot

/*!
 * @brief Metodo get para traer al posicion.
 */
- (CLLocationCoordinate2D)position {
    return self.location;
}

/*!
 * @brief Metodo set de la imagen
 */
- (void) setImageName:(NSString *)image
{
    self.image=image;
}

/*!
 * @brief Metodo get de la imagen
 */
- (NSString*) getImage
{
    return self.image;
}

/*!
 * @brief Metodo get para obtener la promocion
 */
- (id) getObjectContainer
{
    return self.promotion;
}


@end
