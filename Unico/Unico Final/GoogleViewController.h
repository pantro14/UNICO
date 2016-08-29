//
//  GoogleViewController.h
//  Unico Final
//
//  Created by Datatraffic on 10/2/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleViewController : UIViewController <UIWebViewDelegate>

{
    IBOutlet UIWebView *webview;
    NSMutableData *receivedData;
}

/*!
 * @brief Web vio para mostrar el login por Google
 */
@property (nonatomic, retain) IBOutlet UIWebView *webview;

/*!
 * @brief Indica si ha iniciado sesion
 */
@property (nonatomic, retain) NSString *isLogin;
/*!
 * @brief Booblean para el lector
 */
@property (assign, nonatomic) Boolean isReader;
/*!
 * @brief Boton de cerrar de la vista
 */
@property (weak, nonatomic) IBOutlet UIButton *googleCloseBtn;

@end
