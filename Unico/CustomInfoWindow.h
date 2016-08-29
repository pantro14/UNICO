//
//  CustomInfoWindow.h
//  Google Maps iOS Example
//
//  Created by Francisco Garcia on 11/2/14.
//
//  Elemento de interfaz que representa el POPup al dar clic sobre una promocion en el mapa
//

#import <UIKit/UIKit.h>
#import "ModelPromotion.h"

@interface CustomInfoWindow : UIView

// Elemento de interfaz que contiene la imagen de la promocion
@property (weak, nonatomic) IBOutlet UIImageView *imagePromotion;
// Elemento de interfaz que contiene nombde de la promocion
@property (weak, nonatomic) IBOutlet UILabel *labelPromotion;
// Elemento de interfaz que contiene nombre de la tienda
@property (weak, nonatomic) IBOutlet UILabel *labelStore;
// Elemento de interfaz que contiene el descuento de la promocion
@property (weak, nonatomic) IBOutlet UILabel *labelDiscount;
// Elemento de interfaz que contiene objeto de la promocion
@property (weak, nonatomic) ModelPromotion *promotion;

- (IBAction)touchButtonElementPromotion:(id)sender;

@end
