//
//  PromotionsViewController.h
//  Unico Final
//
//  Created by Datatraffic on 9/23/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>


/*!
 * @brief Objeto que representa la flecha de seleccion superior
 */
@property (strong, nonatomic) IBOutlet UIImageView *arrow;
/*!
 * @brief tabla de resultados
 */
@property (strong, nonatomic) IBOutlet UITableView *listings;

//Serbar hadler
/*!
 * @brief Metodo llamado cuando presionan el boton de buscar
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonSearch:(id)sender;
/*!
 * @brief Metodo llamado cuando presionan el boton de volver de busqueda
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonBack:(id)sender;

/*!
 * @brief Label titulo de la vista
 */
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
/*!
 * @brief Objeto de barra de busqueda
 */
@property (weak, nonatomic) IBOutlet UISearchBar *serachBar;
/*!
 * @brief Boton de busqueda
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
/*!
 * @brief Boton para desplegar el filtro
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonUnicoLogo;
/*!
 * @brief Boton del menu
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonMenu;
/*!
 * @brief Imagen para el header
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageHeaderTwo;
/*!
 * @brief Texto del Menu
 */
@property (weak, nonatomic) IBOutlet UILabel *textMenu;
/*!
 * @brief Imagen para el header
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageHeader;
/*!
 * @brief Boton de volver
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;

/*!
 * @brief Metodo para definir una oferta o evento cuando es llega una notificacion
 * @param of, oferta/tienda
 * @return void
 */
- (void) setOffer:(NSString*) of;
/*!
 * @brief Metodo llamado cuando presionan el boton del filtro
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)promotionButton:(id)sender;
/*!
 * @brief Metodo llamado cuando presionan el boton de abrir el menu
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)menuButton:(id)sender;
/*!
 * @brief Metodo llamado cuando elusuario toca la pantalla
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)tapped:(id)sender;

//--


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
/*!
 * @brief Metodo para definir el tipo de vista
 * @param newViewType, Boton
 * @return void
 */
- (void) setTypeofView:(NSString* )newViewType;

@end
