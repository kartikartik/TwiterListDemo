//
//  PassengerListVC.swift
//  kartik_testPratical
//
//  Created by kartik on 30/06/21.
//

import UIKit

class PassengerListVC: UIViewController {
    
    @IBOutlet weak var passListTbl: UITableView!
    var passengerListArr = [PassengerListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Passenger List"
        loadPassengerList()
    }
    
    func loadPassengerList(){
        ApiManger.sharedInstance.getUserMapple { (passModel) in
            print(passModel)
            self.passengerListArr.append(passModel)
            
            DispatchQueue.main.async {
                self.passListTbl.reloadData()
            }
        }
    }
}


extension PassengerListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if passengerListArr.count > 0,let tempData = self.passengerListArr[0].data {
            
            if tempData.count == 0 {
                tableView.setEmptyMessage("No Data Found...")
            } else {
                tableView.restore()
            }

            return tempData.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PassengerTblCell
        cell.mainView.layer.shadowColor = UIColor.gray.cgColor
        cell.mainView.layer.shadowOpacity = 0.3
        cell.mainView.layer.shadowOffset = CGSize.zero
        cell.mainView.layer.shadowRadius = 6
        if let tempData = self.passengerListArr[0].data?[indexPath.row] {
            
            cell.passNameLbl.text = tempData.name
            cell.railNameLbl.text = tempData.airline?.name
            cell.countryLbl.text = tempData.airline?.country
            cell.slogonLbl.text = tempData.airline?.slogan
            
            cell.logoImg.imageFromURL(urlString: tempData.airline?.logo ?? "")
        }
        return cell
    }
    
    
}
