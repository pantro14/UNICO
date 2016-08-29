//
//  PromotionDetailViewController.h
//  Unico Final
//
//  Created by Datatraffic on 10/7/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
// Clase que representa el detalle de una prmocion.evento/tienda
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ModelPromotion.h"
#import "ModelStore.h"
#import "ModelEvent.h"

@interface PromotionDetailViewController : UIViewController <UIScrollViewDelegate,UIWebViewDelegate>
/*!
 * @brief Imagen de backgroun
 */
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
/*!
 * @brief Scroll View de la vista
 */
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
/*!
 * @brief Webview del contenido
 */
@property (strong, nonatomic) IBOutlet UIWebView *textView;
/*!
 * @brief Barra superior
 */
@property (strong, nonatomic) IBOutlet UIView *topBar;
/*!
 * @brief Nombre de la promocion/tienda/evento
 */
@property (strong, nonatomic) IBOutlet UIButton *promoName;
/*!
 * @brief Boton como llegar
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonDoRouting;
/*!
 * @brief Boton de compartir
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
/*!
 * @brief Boton de like
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonLike;
/*!
 * @brief Boton del nombre de la tienda (caso promocion)
 */
@property (strong, nonatomic) IBOutlet UIButton *storeName;
/*!
 * @brief Boton de veces dadi like
 */
@property (strong, nonatomic) IBOutlet UILabel *shareLabel;
/*!
 * @brief Label de datos
 */
@property (strong, nonatomic) IBOutlet UILabel *labelDetails;

/*!
 * @brief Metodo que define una promocion para llenar la vista
 * @param promotionIn, Promocion para llenar el contnido
 * @return void
 */
- (void) setPromotion:(ModelPromotion *) promotionIn;
/*!
 * @brief Metodo que define una tienda para llenar la vista
 * @param storeIn, Tienda para llenar el contnido
 * @return void
 */
- (void) seStoreObject:(ModelStore *) storeIn;
/*!
 * @brief Metodo que evento una promocion para llenar la vista
 * @param eventIn, Evento para llenar el contnido
 * @return void
 */
-(void) setEventObject:(ModelEvent *) eventIn;

/*!
 * @brief Metodo llamado cuando presionan el boton de cerrar
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)backButton:(id)sender;

/*!
 * @brief Metodo llamado cuando presionan el boton ir a tienda
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)showShop:(id)sender;
/*!
 * @brief Metodo llamado cuando presionan el boton de compartir
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)sharingButton:(id)sender;
/*!
 * @brief Metodo llamado cuando presionan el boton de like
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonLike:(id)sender;
/*!
 * @brief Metodo llamado cuando presionan el boton de como llegar
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonRoute:(id)sender;
/*!
 * @brief Metodo llamado cuando presionan el boton de abrir el menu
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)openMenu:(id)sender;
/*!
 * @brief Metodo para definir el tipo de vista (promocion/tienda.evento)
 * @param nType, tipo de vista
 * @return void
 */
- (void) setType:(NSString *) nType;
/*!
 * @brief Metodo que retorna el tipo de vista
 * @return NSString, tipo de la vista
 */
- (NSString *) getType;


@end
