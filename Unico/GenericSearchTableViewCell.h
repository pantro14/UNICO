//
//  GenericSearchTableViewCell.h
//  Unico Final
//
//  Created by Francisco Garcia on 11/8/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clas que representa una celda de al busqueda generica de elementos
//

#import <UIKit/UIKit.h>

@interface GenericSearchTableViewCell : UITableViewCell

/*!
 * @brief Elemento de interfaz que representa el texto del resultado
 */
@property (weak, nonatomic) IBOutlet UILabel *labelResult;
@end
