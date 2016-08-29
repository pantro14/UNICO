//
//  CazaOfertasViewController.h
//  Unico Final
//
//  Created by Francisco Garcia on 10/31/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase que representa la Vista de CazaOfertas
//

#import <UIKit/UIKit.h>

@interface CazaOfertasViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>

/*!
 * @brief Descripcion de la Promocion
 */
@property (weak, nonatomic) IBOutlet UITextView *textViewDescripcion;
/*!
 * @brief Boton de Guardar
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
/*!
 * @brief Boton de seleccion de tienda
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonStore;
/*!
 * @brief Scroll View
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/*!
 * @brief Titulo de la promocion
 */
@property (weak, nonatomic) IBOutlet UITextField *textTitle;
/*!
 * @brief Descuento de la promocion
 */
@property (weak, nonatomic) IBOutlet UITextField *textDiscount;

/*!
 * @brief Metodo cuando se presiona el boton de seleccion de un elemento
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonStores:(id)sender;
/*!
 * @brief Metodo cuando se presiona el boton de menu
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonMenu:(id)sender;
/*!
 * @brief Metodo cuando se presiona el boton de guardar
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonSave:(id)sender;

@end
