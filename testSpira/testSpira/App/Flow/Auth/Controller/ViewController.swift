//
//  ViewController.swift
//  TestSpira
//
//  Created by Pedro Alonso Daza B on 30/04/23.
//

import UIKit
import Toast_Swift
class ViewController: UIViewController {

    @IBOutlet weak var googleButton: CustomButton!
    @IBOutlet weak var emailCustomTextField: CustomTextField!
    @IBOutlet weak var passwordCustomTextField: CustomTextField!
    @IBOutlet weak var signButton: CustomButton!

    var authViewModel: AuthViewModel?
    
    var userData: UserData?
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        // Do any additional setup after loading the view.
    }

    func initComponent() {
        authViewModel = AuthViewModel(authViewModelViewModelToView: self)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authViewModel?.validateUser()
    }
    @IBAction func signInGoogle(button: UIButton) {
        
        authViewModel?.signInGoogle(controller: self)
    }
    
    @IBAction func signInEmail(button: UIButton) {
        if (emailCustomTextField.textFieldInput.text ?? "").isEmpty || (passwordCustomTextField.textFieldInput.text ?? "").isEmpty {
            self.view.makeToast("Please fill all fields")
            return
        }
        if !(emailCustomTextField.textFieldInput.text ?? "").isValidEmail() {
            self.view.makeToast("Please enter valid email")
        }
        authViewModel?.signInEmail(userModel: UserModel(email: (emailCustomTextField.textFieldInput.text ?? "").lowercased(), token: "", password: passwordCustomTextField.textFieldInput.text ?? ""))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if let listRecipesViewController = segue.destination as? ListRecipesViewController {
            listRecipesViewController.userData = userData
        }*/
    }
}
//MARK: -AuthViewModelDelegate
extension ViewController: AuthViewModelViewModelToView {
    func onCompleteGetUser(userData: UserData) {
        self.userData = userData
        performSegue(withIdentifier: "goToList", sender: nil)
    }
    
    func onShowError(error: String) {
        self.view.makeToast(error)
    }
}

