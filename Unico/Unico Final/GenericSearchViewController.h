//
//  GenericSearchViewController.h
//  Unico Final
//
//  Created by Francisco Garcia on 11/8/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase usada para la busqueda general (Marcas/Tiendas/Eventos)
//

#import <UIKit/UIKit.h>

@interface GenericSearchViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

/*!
 * @brief Label del titulo
 */
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
/*!
 * @brief Campo de texto de la busqueda
 */
@property (weak, nonatomic) IBOutlet UITextField *textSearch;
/*!
 * @brief Tabla de resultados
 */
@property (weak, nonatomic) IBOutlet UITableView *tableResults;

/*!
 * @brief Metodo llamado cuando dan clic al boton de cerrar
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonClose:(id)sender;

/*!
 * @brief Metodo llamado para definir el tipo y metodo a llamar
 * @param nType, tipo de elemento a contener
 * @param nCaller, mensaje a ser lamado despues de la seleccion
 * @return IBAction
 */
- (void) setType:(NSString*)nType andCaller:(NSString*) nCaller;


@end
