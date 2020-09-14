//
//  MultiplePickerViewController.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 29/06/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class MultiplePickerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    var titlesArray = [String]()
    var selectedIndices = [String]()
    var selectedTitles = [String]()
    
    var onDismiss : (() -> ())?
    
    @IBAction func doneClicked(_ sender: UIButton){
        if onDismiss != nil { onDismiss!() }
        self.dismiss(animated: true)
    }
}
extension MultiplePickerViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MultiplePickerTableViewCell.identifier, for: indexPath) as! MultiplePickerTableViewCell
        
        let strTitle = titlesArray[indexPath.row]
        
        cell.lblVehicleName.text = strTitle
//        let selectedName  = selectedTitles[indexPath.row]
//        if selectedTitles.count > indexPath.row
//        {
        
        var index = Int()
            
        if selectedTitles.contains(strTitle)
        {
            index = (titlesArray.index(of: strTitle)!)
            if indexPath.row  == index
            {
                cell.btnCheckMark.isSelected = true//selectedIndices.contains("\(index)")
            }
            else
            {
                cell.btnCheckMark.isSelected = false
            }
        }
        else
        {
            cell.btnCheckMark.isSelected = false
        }
        
            //selectedTitles[indexPath.row]

//            let selectedID = ((Singleton.shared.vehicleListData?.data.filter({$0.name == selectedName}).first)?.id)
            
//        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MultiplePickerTableViewCell
        
//        let index = "\(indexPath.row)"

        
            cell.btnCheckMark.isSelected = !cell.btnCheckMark.isSelected
        
        /*
         var arrSelectedID = [String]()
         
         for (item) in selectorVC.selectedTitles.enumerated()
         {
         let selectedID = ((Singleton.shared.vehicleListData?.data.filter({$0.name == item.element}).first)?.id)
         arrSelectedID.append(selectedID as! String)
         }
 */
        let strTitle = titlesArray[indexPath.row]
        let selectedID = ((Singleton.shared.vehicleListData?.data.filter({$0.name == strTitle}).first)?.id)
        if !selectedIndices.contains(selectedID!), cell.btnCheckMark.isSelected
            {
                if selectedIndices.count < 3
                {
                    selectedIndices.append(selectedID!)
                    selectedTitles.append(titlesArray[indexPath.row])
                }
                else
                {
                    cell.btnCheckMark.isSelected = false
                    AlertMessage.showMessageForError("You can select only three types.")
                }

            }
            else
            {
                selectedIndices.remove(at: selectedIndices.firstIndex(of: selectedID!)!)
                selectedTitles.remove(at: selectedTitles.firstIndex(of: titlesArray[indexPath.row])!)
            }
        
    }
    
    
}
