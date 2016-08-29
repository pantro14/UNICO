//
//  SeachTableCellView.h
//  Unico Final
//
//  Created by Francisco Garcia on 11/4/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase que representa una celda de la busqeuda de tiendas
//

#import <UIKit/UIKit.h>

@interface SeachTableCellView : UITableViewCell

// Elemento de la interfaz para el nombre de la tienda
@property (weak, nonatomic) IBOutlet UILabel *labelStore;
// Elemento de la interfaz para el numero del local
@property (weak, nonatomic) IBOutlet UILabel *labelLocal;
// Elemento de la interfaz para la categoria principal de la tienda
@property (weak, nonatomic) IBOutlet UIImageView *imageStore;
// Elemento de la interfaz para la categoria secundaria de la tienda
@property (weak, nonatomic) IBOutlet UIImageView *imageSecondCategory;
// Elemento de la interfaz para la categoria terciaria de la tienda
@property (weak, nonatomic) IBOutlet UIImageView *imageThirdCategory;
@end
