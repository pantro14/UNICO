//
//  MenuViewController.h
//  Unico Final
//
//  Created by Datatraffic on 10/10/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase para el manejo de la vista del menu
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UITextViewDelegate,UITextFieldDelegate>

///Views

/*!
 * @brief Scroll View de toda la Vista
 */
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
/*!
 * @brief View de los elementos de Mi Cuenta
 */
@property (strong, nonatomic) IBOutlet UIView *myAccount;
/*!
 * @brief View de los botones del menu
 */
@property (strong, nonatomic) IBOutlet UIView *buttonSet;
/*!
 * @brief View de los elementos de Ayuda
 */
@property (strong, nonatomic) IBOutlet UIView *helpView;
/*!
 * @brief View de los elementos de PQRS
 */
@property (strong, nonatomic) IBOutlet UIView *faqView;
/*!
 * @brief View de los elementos de Acerca de
 */
@property (strong, nonatomic) IBOutlet UIView *aboutView;

/// Button Properties

/*!
 * @brief Boton de mi cuenta
 */
@property (strong, nonatomic) IBOutlet UIButton *myAccountButton;
/*!
 * @brief Boton de mapa
 */
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
/*!
 * @brief Boton de promociones
 */
@property (strong, nonatomic) IBOutlet UIButton *promotionButton;
/*!
 * @brief Boton de Caza Ofertas
 */
@property (strong, nonatomic) IBOutlet UIButton *houseOfOffersButton;
/*!
 * @brief Boton de eventos
 */
@property (strong, nonatomic) IBOutlet UIButton *eventButton;
/*!
 * @brief Boton de Ayuda
 */
@property (strong, nonatomic) IBOutlet UIButton *helpButton;
/*!
 * @brief Boton de PQRS
 */
@property (strong, nonatomic) IBOutlet UIButton *faqButton;
/*!
 * @brief Boton de Acerca de
 */
@property (strong, nonatomic) IBOutlet UIButton *aboutUsButton;


//Elements My acount

/*!
 * @brief Vista Mi cuenta
 */
@property (weak, nonatomic) IBOutlet UIView *mcElementView;
/*!
 * @brief Label nombre del usuario
 */
@property (weak, nonatomic) IBOutlet UILabel *mcNombreLabel;
/*!
 * @brief Campo de texto del nombre del usuario
 */
@property (weak, nonatomic) IBOutlet UITextField *mcNombreText;
/*!
 * @brief Nombre de la Marca
 */
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *mcSections;
/*!
 * @brief Label email del usuario
 */
@property (weak, nonatomic) IBOutlet UILabel *mcEmailLabel;
/*!
 * @brief Campo de texto del email del usuario
 */
@property (weak, nonatomic) IBOutlet UITextField *mcEmailText;
/*!
 * @brief Label apellido del usuario
 */
@property (weak, nonatomic) IBOutlet UILabel *mcApellidoLabel;
/*!
 * @brief Campo de texto del appellido del usuario
 */
@property (weak, nonatomic) IBOutlet UITextField *mcApellidoText;
/*!
 * @brief Label puntos del usuario
 */
@property (weak, nonatomic) IBOutlet UILabel *labelPoints;
/*!
 * @brief Boton seleccion ciudad
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonCity;
/*!
 * @brief Boton guardar nueva clave
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonSavePass;
/*!
 * @brief Boton seleccion de categorias
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonUpdateCategories;
/*!
 * @brief Campo de texto de la calve vieja del usuario
 */
@property (weak, nonatomic) IBOutlet UITextField *textOldPassword;
/*!
 * @brief NCampo de texto de la clave nueva del usuario
 */
@property (weak, nonatomic) IBOutlet UITextField *textNewPassword;
/*!
 * @brief Campo de texto de la calve nueva del usuario
 */
@property (weak, nonatomic) IBOutlet UITextField *textRePassword;
/*!
 * @brief Picker de la ciudad
 */
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCity;
/*!
 * @brief Boton guardar cambis de los datos del usuario
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
/*!
 * @brief Toolbar del picker
 */
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

/*!
 * @brief Metodo llamado cuando se da clic a terminar de escoger ciudad
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)donePicker:(id)sender;
/*!
 * @brief Metodo llamado cuando se da clic al boton de ciudad
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonCity:(id)sender;
/*!
 * @brief Metodo llamado cuando se da clic al boton de guardar clave
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonSavePass:(id)sender;
/*!
 * @brief Metodo llamado cuando se da clic al boton de guardar datos del usuario
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonSave:(id)sender;
/*!
 * @brief Metodo llamado cuando se da clic al boton cambiar preferencias
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonUpdateCategories:(id)sender;
/*!
 * @brief Metodo llamado cuando se da clic al boton de cerrar sesion
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonSignOut:(id)sender;

//Elements Help

/*!
 * @brief Vista de Ayuda
 */
@property (weak, nonatomic) IBOutlet UIView *hElementView;
/*!
 * @brief Metodo llamado cuando se da clic al boton de ver tutorial
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonTutorial:(id)sender;

/*!
 * @brief Boton ver tutorial
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonTutorial;



//Elements PQRS

/*!
 * @brief Vista PQRS
 */
@property (weak, nonatomic) IBOutlet UIView *pElementView;
/*!
 * @brief Campo de texto del texto Nombre de la persona
 */
@property (weak, nonatomic) IBOutlet UITextField *textNamePqrs;
/*!
 * @brief Campo de texto del Comentario
 */
@property (weak, nonatomic) IBOutlet UITextView *textViewComment;
/*!
 * @brief Boton de enviar informacion
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
/*!
 * @brief Campo de texto del asuto del PQRS
 */
@property (weak, nonatomic) IBOutlet UITextField *textSubject;

/*!
 * @brief Metodo llamado cuando dan clic al boton de enviar PQRS
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonSendPqrs:(id)sender;

//Elements About

/*!
 * @brief Vista Acerca de
 */
@property (weak, nonatomic) IBOutlet UIView *aElementView;
/*!
 * @brief WebView de acerca de
 */
@property (weak, nonatomic) IBOutlet UIWebView *webAbout;

///Button Press Actions

/*!
 * @brief Metodo llamado cuando dan clic al boton de ir a mapa
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)mapTapped:(id)sender;
/*!
 * @brief Metodo llamado cuando dan clic al boton de ir a promocion
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)promotionTapped:(id)sender;
/*!
 * @brief Metodo llamado cuando dan clic al boton de ir a cazaofertas
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)houseOfOffersTapped:(id)sender;
/*!
 * @brief Metodo llamado cuando dan clic al boton de ir a evento
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)eventTapped:(id)sender;
/*!
 * @brief Metodo llamado cuando dan clic al boton de compartir aplicacion
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)shareTapped:(id)sender;
/*!
 * @brief Metodo llamado cuando dan clic al boton a abrir una seccion
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)openSectionMenu:(id)sender;
/*!
 * @brief Metodo llamado cuando dan clic al boton de cerrar una seccion
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)closeSectionMenu:(id)sender;

//Close Button Properties

/*!
 * @brief Boton de cerrar Mi cuenta
 */
@property (strong, nonatomic) IBOutlet UIButton *myAccountClose;
/*!
 * @brief Boton de cerrar Ayuda
 */
@property (strong, nonatomic) IBOutlet UIButton *helpClose;
/*!
 * @brief Boton de cerrar PQRS
 */
@property (strong, nonatomic) IBOutlet UIButton *faqClose;
/*!
 * @brief Boton de cerrar Acerca de
 */
@property (strong, nonatomic) IBOutlet UIButton *aboutUsClose;

/*!
 * @brief Metodo llamado cuando da clic a cerrar el menu
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)dismissMenu:(id)sender;

//Otros

/*!
 * @brief Boton de compartir aplicacion
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonShareUnico2;
/*!
 * @brief Vista del toolbar inferior
 */
@property (weak, nonatomic) IBOutlet UIView *customToolBar;

//Methods

/*!
 * @brief Metodo llamado ara definir que vista llamo el menu
 * @param ncaller, Boton seleccionado
 * @return void
 */
-(void) setViewCaller:(NSString*) ncaller;

@end
