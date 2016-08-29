//
//  TableViewCell.m
//  Unico Final
//
//  Created by Datatraffic on 10/6/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

// Inicializacion rapida de metodos GET y SET
@synthesize imagePromotion,promotionName,discountPromotions,storeName;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*!
 * @brief Metodo para agregar el id de la celda para su identificacion
 * @param value, valor a ser asginado
 * @return void
 */
- (void) setId:(int) value
{
    self.actionButton.tag=value;
    
}

/*!
 * @brief Metodo para obtener el identificador de la celda
 * @return int, identificador de la celda
 */
- (int) getId
{
    return self.actionButton.tag;
    
}

/*!
 * @brief Metodo llamado cuando dan clic a una celda
 * @param sender, boton presionado
 * @return IBaction, accion de al interfaz
 */
- (IBAction)tappedCell:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellView" object:self];
    
}


@end
