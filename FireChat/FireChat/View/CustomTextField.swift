//
//  CustomTextField.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 6/4/21.
//

import UIKit

class CustomTextField: UITextField {

    init(placeholder: String){
        super.init(frame: .zero)
        
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = .white
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [.foregroundColor: UIColor.white])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
