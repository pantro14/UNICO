//
//  ViewController.h
//  Unico Final
//
//  Created by Datatraffic on 9/23/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase que representa la vista de ingreso
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,FBLoginViewDelegate>

/*!
 * @brief Campo de texto del nombre de usuario
 */
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
/*!
 * @brief Campo de texto de la clave de usuario
 */
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
/*!
 * @brief Boton de registro
 */
@property (strong, nonatomic) IBOutlet UIButton *userRegister;
/*!
 * @brief Imagen del logo de la aplicacion
 */
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
/*!
 * @brief Boton de login por Facebook
 */
@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;


/*!
 * @brief Metodo cuando el usuario da clic en la pantalla
 * @param sender, button
 * @return void
 */
- (IBAction)tapped:(id)sender;
/*!
 * @brief Metodo llamado cuando se da clic en el boton de registrar
 * @param sender, button
 * @return void
 */
- (IBAction)registration:(id)sender;
/*!
 * @brief Metodo llamado cuando se da clic en el boton de olvido su contrasena
 * @param sender, button
 * @return void
 */
- (IBAction)forgotPassword:(id)sender;
/*!
 * @brief Metodo llamado cuando se da clic en el boton de login
 * @param sender, button
 * @return void
 */
- (IBAction)loginButton:(id)sender;
/*!
 * @brief Metodo llamado cuando se da clic en el boton de ingreso por facebook
 * @param sender, button
 * @return void
 */
- (IBAction)facebook:(id)sender;
/*!
 * @brief Metodo llamado cuando se da clic en el boton de ingreso por google
 * @param sender, button
 * @return void
 */
- (IBAction)googlePlus:(id)sender;


@end

