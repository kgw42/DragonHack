//
//  LoginViewController.swift
//  ARChess
//
//  Created by Kweku Aboagye on 4/17/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signIn(_ sender: Any) {
        let usernameText = username.text!
        
        let passwordText = password.text!
        
        if usernameText != "" && passwordText != "" {
            performSegue(withIdentifier: "LoginSegue", sender: nil)
        }
        else {
                let alertController = UIAlertController(title: "AR Chess", message:
                    "Username or password field empty", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                self.present(alertController, animated: true, completion: nil)
        }
        
    }
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        username.becomeFirstResponder()

        // Do any additional setup after loading the view.

          // Automatically sign in the user.
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
