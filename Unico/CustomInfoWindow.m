//
//  CustomInfoWindow.m
//  Google Maps iOS Example
//
//  Created by Francisco Garcia on 11/2/14.
//
//

#import "CustomInfoWindow.h"

@implementation CustomInfoWindow
// Inicializacion rapida de metodos SET y GET
@synthesize imagePromotion,labelPromotion,labelStore,labelDiscount,promotion;

- (void)awakeFromNib {
    // se inicializa el background
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];

}


/*!
 * @brief Metodo llamado cuando dan clic a una promocion
 * @param sender, boton presionado
 * @return IBaction, accion de al interfaz
 */
- (IBAction)touchButtonElementPromotion:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPromotion" object:self.promotion];
}
@end
