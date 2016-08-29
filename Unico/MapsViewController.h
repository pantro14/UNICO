//
//  MapsViewController.h
//  Unico Final
//
//  Created by Francisco Garcia on 11/3/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase que representa la vista del Mapa
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GClusterManager.h"
#import "ModelStore.h"

@interface MapsViewController : UIViewController<GMSMapViewDelegate,UIScrollViewDelegate,CLLocationManagerDelegate> {
    // Manager de los clusters
    GClusterManager *clusterManager;
}

//Elements marker Selection
/*!
 * @brief Vista del popup
 */
@property (weak, nonatomic) IBOutlet UIView *viewInfo;
/*!
 * @brief Scrollview del popup
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollElements;
/*!
 * @brief Boton del primer piso
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonFirstFloor;
/*!
 * @brief Boton del segundo piso
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonSecondFloor;
/*!
 * @brief Boton de borrar ruta
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonTrashRouting;
/*!
 * @brief Imagen del header
 */
@property (strong, nonatomic) IBOutlet UIImageView *header;
/*!
 * @brief Imagen del separador de elementos
 */
@property (strong, nonatomic) IBOutlet UIImageView *trashSeperator;
/*!
 * @brief Objeto del mapa
 */
@property (weak, nonatomic) IBOutlet GMSMapView *mapViewUI;

/*!
 * @brief Metodo llamado cuando tocan el boton del primer piso
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonFirstFloor:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el boton del segundo piso
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonSecondFloor:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el boton del filtro
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonFilter:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el boton de hacer ruta
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonRoute:(id)sender;
/*!
 * @brief Metodo para ejecutar la accion de como llegar
 * @param rStore, tienda a la que toca hacer la ruta
 * @return void
 */
- (void) setAutomaticRouting:(ModelStore*) rStore;
/*!
 * @brief Metodo llamado cuando tocan el boton del menu
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonMenu:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el boton de ayuda
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonHelp:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el boton de borrar ruta
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonTrashRouting:(id)sender;


@end
