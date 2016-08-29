//
//  CazaOfertasPlusViewController.h
//  Unico Final
//
//  Created by Francisco Garcia on 11/1/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase que representa la Vista de CazaOfertas Plus
//

#import <UIKit/UIKit.h>

@interface CazaOfertasPlusViewController : UIViewController <UIScrollViewDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

/*!
 * @brief Scroll View
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/*!
 * @brief Imagen de la promocion
 */
@property (weak, nonatomic) IBOutlet UIImageView *imagePromotion;
/*!
 * @brief Descripcion de la Promocion
 */
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
/*!
 * @brief Titulo de la promocion
 */
@property (weak, nonatomic) IBOutlet UITextField *textTitle;
/*!
 * @brief Descuento de la promocion
 */
@property (weak, nonatomic) IBOutlet UITextField *textDiscount;
/*!
 * @brief Tipo de descuento
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonTypeDiscount;
/*!
 * @brief Boton de seleccion de tienda
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonStore;
/*!
 * @brief Boton de seleccion marca
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonBrand;
/*!
 * @brief Boton de seleccion de categoria
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonCategory;
/*!
 * @brief Boton de seleccion de evento
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonEvent;
/*!
 * @brief Boton de seleccion de fecha de incio
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonStartDate;
/*!
 * @brief Boton de seleccion de fecha de finalizacion
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonEndDate;
/*!
 * @brief Picker de fecha
 */
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
/*!
 * @brief Picket de elementos
 */
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
/*!
 * @brief Toolbar del picker
 */
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
/*!
 * @brief Boton de Guardar
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;


/*!
 * @brief Metodo cuando se presiona el boton de menu
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonMenu:(id)sender;
/*!
 * @brief Metodo cuando se presiona el boton de cargar foto
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonPhoto:(id)sender;
/*!
 * @brief Metodo cuando se presiona el boton de terminar la eleccion del picker
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonDone:(id)sender;
/*!
 * @brief Metodo cuando se presiona el boton de guardar
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchbuttonSave:(id)sender;
/*!
 * @brief Metodo cuando se presiona el boton de seleccion de un elemento
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonStore:(id)sender;

@end
