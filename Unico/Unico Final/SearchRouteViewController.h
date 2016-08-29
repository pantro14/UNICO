//
//  SearchRouteViewController.h
//  Unico Final
//
//  Created by Francisco Garcia on 11/4/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchRouteViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

/*!
 * @brief Campo de texto del punto de inicio
 */
@property (weak, nonatomic) IBOutlet UITextField *textStartPoint;
/*!
 * @brief Campo de texto del punto de destino
 */
@property (weak, nonatomic) IBOutlet UITextField *textEndPoint;
/*!
 * @brief Boton de buscar ruta
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonSearchRout;
/*!
 * @brief Tabla de resultados
 */
@property (weak, nonatomic) IBOutlet UITableView *tableStores;

/*!
 * @brief Metodo llamado cuando presionana el boton de buscar ruta
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonSearchRoute:(id)sender;
/*!
 * @brief Metodo llamado cuando presionana el boton de cerrar
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonClose:(id)sender;


@end
