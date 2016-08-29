//
//  CategoryViewController.h
//  Unico Final
//
//  Created by Datatraffic on 10/7/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase que representa la vista de seleccion de Categorias
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController

/*!
 * @brief Titulo de la Vista
 */
@property (strong, nonatomic) IBOutlet UILabel *categoriesTitle;
/*!
 * @brief Boton de cerrar la vista
 */
@property (strong, nonatomic) IBOutlet UIButton *buttonDismiss;
/*!
 * @brief Coleccion de botones que representa cada una de las categorias
 */
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *categoriesButtons;
/*!
 * @brief Boton de Ok
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonOk;

/*!
 * @brief Boton de cancelar
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;

/*!
 * @brief Metodo establecer que categorias estan seleccionadas
 * @param input, Array con la lsita de categorias seleccioandas
 * @return void
 */
- (void) setStateCatgories:(NSMutableArray *) input;

/*!
 * @brief Metodo llamado cuando seleccionan una categoria
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchCategory:(id)sender;

/*!
 * @brief Metodo llamado cuando precionan el boton Close
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)close:(id)sender;

/*!
 * @brief Metodo llamado cuando precionan el boton Ok
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)okButton:(id)sender;

/*!
 * @brief Metodo para definir el mensaje a ser llamado cuando termine la ejecucion de la vista
 * @param nCaller, nombre del mensaje
 * @return void
 */
- (void) setCaller:(NSString*) nCaller;

/*!
 * @brief Metodo que define el tipo de comportamiento de la vista (Tipo Perfilamiento o tipo filtro)
 * @param nType, Tipo de Vista
 * @return void
 */
- (void) changeBehaviorTipo:(BOOL) nType;
@end
