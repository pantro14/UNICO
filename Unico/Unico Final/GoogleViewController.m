//
//  GoogleViewController.m
//  Unico Final
//
//  Created by Datatraffic on 9/30/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "GoogleViewController.h"
#import "JSON.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"


NSString *client_id = @"947962946140.apps.googleusercontent.com";

NSString *secret = @"IrYZWV11ZC3eOuvk2X5MqAxk";

NSString *callbakc =  @"http://localhost";

NSString *scope = @"https://www.googleapis.com/auth/userinfo.email+https://www.googleapis.com/auth/userinfo.profile";

NSString *visibleactions = @"http://schemas.google.com/AddActivity";

@interface GoogleViewController ()
{
    NSString *id_token;
    NSString *access_token;
    NSString *user_id;
    NSString *email;
    NSString *name;
    NSString *city;
    NSString *lastname;
    NSString *gender;
    NSString *img;
    NSString *url;
    BOOL debug;
}

@end

@implementation GoogleViewController
@synthesize webview,isLogin,isReader;


- (void)viewDidLoad
{
    [super viewDidLoad];
    //debug=YES;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSString *urlString =[NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&data-requestvisibleactions=%@",client_id,callbakc,scope,visibleactions];
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //    [indicator startAnimating];
    if ([[[request URL] host] isEqualToString:@"localhost"]) {
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"code"]) {
                verifier = [keyValue objectAtIndex:1];
                if(debug)
                {
                    NSLog(@"verifier %@",verifier);
                }
                break;
            }
        }
        
        if (verifier) {
            NSString *data = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", verifier,client_id,secret,callbakc];
            NSString *urlString = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/token"];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
            receivedData = [[NSMutableData alloc] init];
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack ] ;
            
        } else {
            // ERROR!
        }
        
        //[webView removeFromSuperview];
        
        return NO;
    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"%@", error]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    SBJsonParser *jResponse = [[SBJsonParser alloc]init];
    NSDictionary *tokenData = [jResponse objectWithString:response];
    if(debug)
    {
        NSLog(@"tokenData2 %@",tokenData);
    }
    if([tokenData objectForKey:@"id_token"])
    {
        id_token=[tokenData objectForKey:@"id_token"];
        access_token=[tokenData objectForKey:@"access_token"];
        NSString *urlPitch = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/tokeninfo?id_token=%@",id_token];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlPitch]];
        
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        receivedData = [[NSMutableData alloc] init];
    }
    else if([tokenData objectForKey:@"user_id"])
    {
        user_id=[tokenData objectForKey:@"user_id"];
        email=[tokenData objectForKey:@"email"];
        NSString *urlCheck = [NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/%@?access_token=%@",user_id,access_token];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlCheck]];
        
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        receivedData = [[NSMutableData alloc] init];
    }
    else if([tokenData objectForKey:@"displayName"])
    {
        
        gender=[tokenData objectForKey:@"gender"];
        lastname=[[tokenData objectForKey:@"name"] objectForKey:@"familyName"];
        name=[[tokenData objectForKey:@"name"] objectForKey:@"givenName"];
        img=[[tokenData objectForKey:@"image"] objectForKey:@"url"];
        img=[img stringByReplacingOccurrencesOfString:@"?sz=50"
                                           withString:@"?sz=100"];
        url=[tokenData objectForKey:@"url"];
        if(debug)
        {
            NSLog(@"resultado Json,%@ %@ %@ %@",gender,lastname,name,img);
        }
        
        NSUserDefaults *id_unico=[NSUserDefaults standardUserDefaults];
        
        NSString *token=[id_unico objectForKey:@"pushToken"];
        
        
        NSMutableDictionary *dict=[@{ @"email":email
                                     ,@"first_name":name,@"last_name":lastname,@"link":url,@"ciudad":@1,@"gender":gender} mutableCopy];
        if(token)
        {
            [dict setValue:token forKey:@"token"];
        }
        
        if(debug){
            NSLog(@"dictionary registro g+ %@",dict);
        }
        NSString *loggedIn = @"YES";
        
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"firstName"];
        [[NSUserDefaults standardUserDefaults] setObject:lastname forKey:@"lastName"];
        [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"image"];
        [[NSUserDefaults standardUserDefaults] setObject:loggedIn forKey:@"loginCheck"];
        [[NSUserDefaults standardUserDefaults] setObject:gender forKey:@"gender"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SVProgressHUD dismiss];	
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"register" object:nil];
        }];
        
        
    }
    else if([tokenData objectForKey:@"response"])
    {
        if( [@"ERROR" isEqualToString:[tokenData objectForKey:@"response"]])
        {
            NSLog(@"Error");
        }
        else
        {
            NSUserDefaults *registro=[NSUserDefaults standardUserDefaults];
            [registro setObject:name forKey:@"name"];
            [registro setObject:lastname forKey:@"lastName"];
            [registro setObject:img forKey:@"image"];
            [registro setObject:[tokenData objectForKey:@"id_unico"] forKey:@"id_unico"];
            [registro setBool:YES forKey:@"HasLogin"];
            [registro synchronize];
        }
        
        [SVProgressHUD dismiss];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    
}

/*!
 * @brief Metodo para cerrar la vista de Google
 * @param sender, boton de cerrar
 * @return IBAction
 */
- (IBAction)googleClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
