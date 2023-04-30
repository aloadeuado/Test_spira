//
//  CustomTextField.swift
//  test_yape_ios
//
//  Created by iMac on 23/02/23.
//

import Foundation
import UIKit

class CustomTextField: UIView {
    var textFieldInput = TextFieldCustomInsets()
    
    private var label: UILabel = UILabel(frame: CGRect.zero)
    private var errorLabel: UILabel = UILabel()
    private var buttonShowPassword = UIButton()
    private let labelHeight: CGFloat = 16
    private let labelTag = Int(Int.max / 7)
    private let labelPadding: CGFloat = 3
    private let labelFontSize: CGFloat = 12
    private var isTextFieldSet = false
    
    @IBInspectable var cornerRadiusCustom: CGFloat = 0 {
        didSet {
            textFieldInput.layer.cornerRadius = cornerRadiusCustom
            textFieldInput.layer.masksToBounds = cornerRadiusCustom > 0
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 0
    @IBInspectable var lineColor: UIColor = .clear
    
    private var lineBorder: CAShapeLayer?
    @IBInspectable var placeholder: String?
    @IBInspectable var font: UIFont = UIFont(name: "Helvetica Neue", size: 14)!
    @IBInspectable var secure: Bool = false
    @IBInspectable var minChars: Int = 0
    //MARK: -Vars Validations
    let validationAlphabetical = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ abcdefghijklmnñopqrstuvwxyz"
    let validationAlphabeticalCapital = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ "
    let validationNumric = "0123456789"
    
    private var isShowPassword: Bool = true
    /*
     0 - text
     1 - alphabetical
     2 - numeric
     3 - alphaNumeric
     4 - email
     */
    @IBInspectable var inputText: Int = 0
    @IBInspectable var rangeText: Int = 20
    
    var textError: String = "" {
        didSet{
            setTextError()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    private func initView() {
        backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tag = labelTag
        label.numberOfLines = 1
        label.font = UIFontMetrics.default.scaledFont(for: font)
        label.adjustsFontForContentSizeCategory = true
        
        
        
        textFieldInput.translatesAutoresizingMaskIntoConstraints = false
        textFieldInput.layer.borderColor = UIColor.clear.cgColor
        textFieldInput.borderStyle = .roundedRect
        textFieldInput.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        textFieldInput.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        
        textFieldInput.borderStyle = .none
        addSubview(textFieldInput)
        
        
    }
    
    func setTextError() {
        errorLabel.text = textError
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldInput.layer.cornerRadius = cornerRadiusCustom
        textFieldInput.placeholder = placeholder
        textFieldInput.font = font
        textFieldInput.isSecureTextEntry = secure
        label.text = placeholder
        label.textColor = lineColor
        label.font = font.withSize(labelFontSize)
        let view = UIView(frame: CGRect(x: 0, y: self.frame.height - lineWidth, width: self.frame.width, height: lineWidth))
        view.backgroundColor = lineColor
        self.addSubview(view)
        if secure {
            let sizeButtonPassword: CGFloat = 24
            let xPositionButtonPassword: CGFloat = self.frame.width - sizeButtonPassword - 12
            let yPositionButtonPassword: CGFloat = (self.frame.height / 2) - (sizeButtonPassword / 2)
            buttonShowPassword = UIButton(frame: CGRect(x: xPositionButtonPassword, y: yPositionButtonPassword, width: sizeButtonPassword, height: sizeButtonPassword))
            buttonShowPassword.setImage(UIImage(named: "asset-password-hide"), for: .normal)
            buttonShowPassword.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            buttonShowPassword.tintColor = #colorLiteral(red: 0.6308933496, green: 0.3684504032, blue: 0.7984480262, alpha: 1)
            self.addSubview(buttonShowPassword)
        }
        textFieldInput.delegate = self
        switch inputText {
        case 2:
            textFieldInput.keyboardType = .numberPad
            break
        case 4:
            textFieldInput.keyboardType = .emailAddress
            break
        case 6:
            textFieldInput.keyboardType = .numberPad
            break
        default:
            break
        }
        //Error label
        
        errorLabel.frame = CGRect(x: 0, y: view.frame.origin.y, width: view.frame.width - 32, height: 15)
        errorLabel.numberOfLines = 2
        errorLabel.font = UIFontMetrics.default.scaledFont(for: font)
        addSubview(errorLabel)
        
        errorLabel.textColor = #colorLiteral(red: 0.9921473861, green: 0.1454878151, blue: 0, alpha: 1)
        errorLabel.font = font.withSize(labelFontSize)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if isShowPassword {
            buttonShowPassword.setImage(UIImage(named: "asset-password-show"), for: .normal)
            textFieldInput.isSecureTextEntry = false
        } else {
            buttonShowPassword.setImage(UIImage(named: "asset-password-hide"), for: .normal)
            textFieldInput.isSecureTextEntry = true
        }
        isShowPassword = !isShowPassword
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isTextFieldSet {
            setupUITextField()
        }
        //setupUIBezierPath()
    }
}

class TextFieldCustomInsets: UITextField {
    
    @IBInspectable var leftPadding: CGFloat = 8
    @IBInspectable var gapPadding: CGFloat = 4
    
    private var textPadding: UIEdgeInsets {
        let p: CGFloat = leftPadding + gapPadding + (leftView?.frame.width ?? 0)
        return UIEdgeInsets(top: 0, left: p, bottom: 0, right: 5)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var r = super.leftViewRect(forBounds: bounds)
        r.origin.x += leftPadding
        return r
    }
}
// MARK: - DriverUITextFieldCustom
extension CustomTextField {
    
    // Add a floating label to the view on becoming first responder
    @objc func addFloatingLabel() {
        label.clipsToBounds = true

        addSubview(label)
        
        NSLayoutConstraint.activate([label.bottomAnchor.constraint(equalTo: textFieldInput.topAnchor, constant: CGFloat(-labelPadding)),
                 label.leadingAnchor.constraint(equalTo: textFieldInput.leadingAnchor, constant: textFieldInput.layoutMargins.left),
                 label.topAnchor.constraint(equalTo: self.topAnchor)])
        self.textFieldInput.placeholder = nil
        
        self.setNeedsDisplay()
    }
    
    
    @objc func removeFloatingLabel() {
        if self.textFieldInput.text?.isEmpty ?? true {
            UIView.animate(withDuration: 0.13) { [weak self] in
                if let viewWithTag = self!.viewWithTag(self!.labelTag) {
                    viewWithTag.removeFromSuperview()
                }
            }
            
            self.textFieldInput.placeholder = self.label.text
        }
        
        textFieldInput.layer.borderWidth = 0
        textFieldInput.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    private func setupUITextField() {
        NSLayoutConstraint.activate([textFieldInput.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                 textFieldInput.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                 textFieldInput.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                 textFieldInput.heightAnchor.constraint(equalTo: self.heightAnchor, constant: CGFloat(-labelHeight))])
        
        isTextFieldSet = true
    }
    
    func setPlaceHolder(placeholder: String) {
        textFieldInput.placeholder = placeholder
        label.text = placeholder
    }
}
// MARK: -Validations
extension CustomTextField : UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let isEmailValidate = (textField.text ?? "").isValidEmail()
        if inputText == 4 {
            if !isEmailValidate {
                textError = "Por favor ingrese un email valido"
            } else {
                textError = ""
            }
            return isEmailValidate
        }
        if (textField.text ?? "").count < minChars {
            textError = "Debe tener minimo {number} caracteres".replacingOccurrences(of: "{number}", with: "\(minChars)")
        } else {
            textError = ""
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if inputText == 4 {
            let isEmailValidate = (textField.text ?? "").isValidEmail()
            if !isEmailValidate {
                textError = "Por favor ingrese un email valido"
            } else {
                textError = ""
            }
        }
        if (textField.text ?? "").count < minChars {
            textError = "Debe tener minimo {number} caracteres".replacingOccurrences(of: "{number}", with: "\(minChars)")
        } else {
            textError = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch inputText {
        case 0:
            return (range.location < rangeText)
            
        case 1:
            let set = CharacterSet(charactersIn: validationAlphabetical).inverted
            let filtered = string.components(separatedBy: set).joined(separator: "")
            print("\((range.location < rangeText)) >>>>>>>>>>>>>>>>>>>>>>   text: \(textField.text)  \(range)")

            return (string == filtered) && (range.location < rangeText)
            
        case 2:
            let set = CharacterSet(charactersIn: validationNumric).inverted
            let filtered = string.components(separatedBy: set).joined(separator: "")
            return (string == filtered) && (range.location < rangeText)
            
        case 6:
            if let textData = textField.text {
                
                var intStringValue = getIntsString(string: textData + string)
                if string == "" {
                    intStringValue = String(intStringValue.dropLast(1))
                }
                if (range.location >= rangeText) {
                    return false
                }
                let intValue = NSNumber(value: Int(intStringValue) ?? 0)
                
                let formatter = NumberFormatter()
                formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
                formatter.numberStyle = .currency
                if let formattedTipAmount = formatter.string(from: intValue) {
                    if formatter.internationalCurrencySymbol == "COP" {
                        let substring1 = String(formattedTipAmount).dropFirst()       // "01234567"
                        let substring2 = String(substring1).dropFirst()

                        if substring2 == "0"{
                            textField.text = ""
                        }else {
                            textField.text = String(substring2)
                        }
                    } else if formatter.internationalCurrencySymbol == "¤¤"{
                        let substring1 = String(formattedTipAmount).replacingOccurrences(of: ".00", with: "")
                        let substring2 = substring1.replacingOccurrences(of: "¤", with: "")

                        if substring2 == "0"{
                            textField.text = ""
                        }else {
                            textField.text = substring2
                        }
                    } else if formatter.internationalCurrencySymbol == "USD"{
                        let substring1 = String(formattedTipAmount).replacingOccurrences(of: ".00", with: "")
                        let substring2 = substring1.replacingOccurrences(of: "$", with: "")

                        if substring2 == "0"{
                            textField.text = ""
                        }else {
                            textField.text = substring2
                        }
                    }
                    
                    
                }
                return false
            }
            
            return false
            
        case 7:
            /*let set = CharacterSet(charactersIn: validationAlphabeticalCapital).inverted
            let filtered = string.components(separatedBy: set).joined(separator: "")
            return (string == filtered) && (range.location < rangeText)*/
        
            var intStringValue = textField.text
            if string == "" {
                intStringValue = String(intStringValue!.dropLast(1))
            }
            let upperCaseString = string.uppercased()
            if let newText = textField.text{
                textField.text = newText + upperCaseString
            }
            


            return false
            
        default: break
        }
        
        return range.location < rangeText
    }
    
    
    func getIntsString(string: String) -> String{
        var numbers = ""
        
        for item in string {
            if item == "0" || item == "1" || item == "2" || item == "3" || item == "4" || item == "5" || item == "6" || item == "7" || item == "8" || item == "9" {
                numbers = numbers + "\(item)"
            }
        }
        
        return numbers
    }
}
