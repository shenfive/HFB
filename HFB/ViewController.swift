//
//  ViewController.swift
//  HFB
//
//  Created by 申潤五 on 2022/10/25.
//

import UIKit
import FacebookLogin
import Firebase

class ViewController: UIViewController, LoginButtonDelegate {

    let loginButton = FBLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loginButton.permissions = ["public_profile", "email"]
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
    
        getFBuserData()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                
            }else{
                
            }
        }
        
    }
    
    
    
    func getFBuserData(){
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            print("已登入 FB \(token.userID):\(token.permissions)")
            GraphRequest(graphPath: "me", parameters: ["fields":"id, name, email"]).start { (connection, result, error) in
                // check error
                if error != nil {
                    print("Failed to start graph request: \(error?.localizedDescription)")
                    return
                }
                
                if let userDict = result as? NSDictionary {
                    let name = userDict["name"] as? String
                    let id = userDict["id"] as? String
                    let email = userDict["email"] as? String
                    
                    print(name as Any)
                    print(id as Any)
                    print(email as Any)
                }
            }
        }else{
            print("未登入 FB")
        }

    }
    
    
    

    //MARK: FBLogin Delegate
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        getFBuserData()
        if !(AccessToken.current?.isExpired ?? true) {
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential)
        }
        
        
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        getFBuserData()
    }
    
    
    
}

