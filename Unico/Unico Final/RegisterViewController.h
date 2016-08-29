//
//  RegisterViewController.h
//  Unico Final
//
//  Created by Datatraffic on 10/2/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase para la vista de Registro
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

/*!
 * @brief Scroll View de la vista
 */
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
/*!
 * @brief Boton de Registro
 */
@property (strong, nonatomic) IBOutlet UIButton *registerButtonProp;
/*!
 * @brief Piker view para genero/ciudad/
 */
@property (strong, nonatomic) IBOutlet UIPickerView *pickerSelection;
/*!
 * @brief Boton para seleccionar la ciudad
 */
@property (strong, nonatomic) IBOutlet UIButton *cityButton;
/*!
 * @brief Boton para seleccionar el genero
 */
@property (strong, nonatomic) IBOutlet UIButton *genderButton;
/*!
 * @brief Boton para seleccionar la fecha de nacimiento
 */
@property (strong, nonatomic) IBOutlet UIButton *dateOfBirthButton;
/*!
 * @brief Picker de fechas
 */
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
/*!
 * @brief Nombre del usuario
 */
@property (strong, nonatomic) IBOutlet UITextField *name;
/*!
 * @brief Apellido del usuario
 */
@property (strong, nonatomic) IBOutlet UITextField *lastName;
/*!
 * @brief cedula del usuario
 */
@property (strong, nonatomic) IBOutlet UITextField *cedula;
/*!
 * @brief email del usuario
 */
@property (strong, nonatomic) IBOutlet UITextField *email;
/*!
 * @brief Clave del usuario
 */
@property (strong, nonatomic) IBOutlet UITextField *password;
/*!
 * @brief Clave2 del usuario
 */
@property (strong, nonatomic) IBOutlet UITextField *repassword;
/*!
 * @brief El toolbar del picker
 */
@property (strong, nonatomic) IBOutlet UIToolbar *toolBarPicker;
/*!
 * @brief El boton limpiar del picker
 */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clearButton;
/*!
 * @brief Momento Unico Popup
 */
@property (strong, nonatomic) IBOutlet UIView *momentoUnicoPopup;
/*!
 * @brief Terminos y Condiciones Popup
 */
@property (strong, nonatomic) IBOutlet UIView *terminosCondicionesPopup;
/*!
 * @brief Metodo llamado cuando tocan el boton de registo
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)registerButton:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan la interfaz
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)tapped:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el boton seleccionar una ciudad
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)citySelection:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el boton seleccionar un genero
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)genderSelection:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el boton de seleccionar una fecha de nacimiento
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)dateOfBirthSelection:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el boton cerrar la vista
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)backToLogin:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el boton de finalizacion de seleccion
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)donePicker:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el check box de terminos
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)tappedCheck:(id)sender;
/*!
 * @brief Metodo llamado el login es realizado por facebook
 * @param userInfo, diccionario con los datos de facebook
 * @return void
 */
- (void) facebookPopulation:(id) userInfo;
/*!
 * @brief Metodo llamado cuando tocan el boton de Momento Unico
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)momentoButton:(id)sender;
/*!
 * @brief Metodo llamado cuando tocan el boton de cerrar en el Popup de Terminos y Condiciones
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)closeTerminos:(id)sender;
/*!
 * @brief Terminos y Condiciones
 */
@property (strong, nonatomic) IBOutlet UILabel *terminos;

@end
