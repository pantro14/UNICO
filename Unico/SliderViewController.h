//
//  SliderViewController.h
//  Unico Final
//
//  Created by Datatraffic on 10/16/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderViewController : UIViewController<UIScrollViewDelegate>

/*!
 * @brief ScrollView de la Vista
 */
@property (strong, nonatomic) IBOutlet UIScrollView *slicerScroll;
/*!
 * @brief Paginador
 */
@property (strong, nonatomic) IBOutlet UIPageControl *sliderPageControl;

/*!
 * @brief Metodo llamado cuando cambia de pagina la vista
 * @param sender, paginador
 * @return void
 */
- (IBAction)pageValueChange:(id)sender;

/*!
 * @brief Metodo para definir la accion cuando se da clic en continuar
 * @param action, Boolean
 * @return void
 */
-(void) setCloseAction:(BOOL) action;
/*!
 * @brief Metodo llamado para definir el comportamietno de la vista, si es ayuda general o ayuda del mapa
 * @param nType, tipo que se desea
 * @return void
 */
-(void) setType:(NSString*) nType;
/*!
 * @brief Metodo llamado cuando se da clic al boton de continuar
 * @param sender, boton
 * @return void
 */
- (IBAction)touchButtonContinuar:(id)sender;

@end
