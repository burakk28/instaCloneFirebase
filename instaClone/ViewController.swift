//
//  ViewController.swift
//  instaClone
//
//  Created by Burak Kara on 7.12.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
    }


    @IBAction func signInClicked(_ sender: Any) {
        
        if (emailText.text != "" && passwordText.text != ""){
            
            //Autdata ve error ile sunucudan gelen hata mesajına bakılıyor.
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { [self] authdata, error in
                
                //sunucudan gelen hata mesaj dolu ise gelen hata mesajı ekrana yazdırılıyor
                //Boş ise segueperform ile farklı ekrana geçiş yapılıyor.
                
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
                
                
            }
            
        }else {
            makeAlert(titleInput: "Error!", messageInput: "Username/Password")
        }
       
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        
        if (emailText.text != "" && passwordText.text != ""){
            

            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authDataResult,error in
                
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "error")
                    
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
            }
            
        }else {
            makeAlert(titleInput: "Error!", messageInput: "Username/Password")
        }
        
        
    }
    
    func makeAlert(titleInput:String,messageInput:String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler:nil)
        alert.addAction(okButton)
        self.present(alert, animated: true , completion: nil)
        
    }
}

