//
//  DatePickerViewController.swift
//  Peppea-Driver
//
//  Created by EWW-iMac Old on 26/06/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class DatePickerViewController: UIViewController {

    @IBOutlet weak var txtDate : SkyFloatingLabelTextField!
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var btnDone : UIButton!
    var isDateOfBirth = Bool()

    var placeHolder = "DD/MM/YY"
    var dateFormat = "dd/MM/yy" // "dd MMM yyyy"
    override func viewDidLoad() {
        super.viewDidLoad()
        txtDate.placeholder = placeHolder
        btnDone.submitButtonLayout(isDark: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners([.topLeft,.topRight], radius: 16)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
    }
    var onDismiss : (() -> ())?
    var date = ""
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == view {
            //            guard Validator.validate([(txtDate.text, "",.isEmpty)]) else {
            //                return
            //            }
            self.dismiss(animated: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        view.backgroundColor = .clear
    }
    @IBAction func dp(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        if(isDateOfBirth)
        {
            datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -21, to: Date())

        } else {
            datePickerView.minimumDate = Date()
        }
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
    }
    @IBAction func doneClicked(_ sender: UIButton) {
        guard Validator.validate([(txtDate.text, dateErrorString,.isEmpty)]) else {
            return
        }
        self.dismiss(animated: true)
        
    }
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        txtDate.text = dateFormatter.string(from: sender.date)
        date = dateFormatter.string(from: sender.date)
        if onDismiss != nil { onDismiss!() }

    }
}
