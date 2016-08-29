//
//  TableViewCell.h
//  Unico Final
//
//  Created by Datatraffic on 10/6/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//
// Objeto que representa una fila en la tabla de promociones/eventos
//

#import <UIKit/UIKit.h>


@interface TableViewCell : UITableViewCell
// objeto de la interfaz que representa la imagen
@property (strong, nonatomic) IBOutlet UIImageView *imagePromotion;
// objeto de la interfaz label de la nombre de la tienda
@property (strong, nonatomic) IBOutlet UILabel *storeName;
// objeto de la interfaz label de la nombre de la promocion
@property (strong, nonatomic) IBOutlet UILabel *promotionName;
// objeto de la interfaz del background
@property (strong, nonatomic) IBOutlet UIView *backgorundView;
// objeto de la interfaz que representa la imagen del slide
@property (strong, nonatomic) IBOutlet UIImageView *slide;
// objeto de la interfaz que representa el boton del slider
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
// objeto de la interfaz label del porcentaje de descuento
@property (strong, nonatomic) IBOutlet UILabel *discountPromotions;


- (IBAction)tappedCell:(id)sender;
- (void) setId:(int) value;
- (int) getId;
@end
