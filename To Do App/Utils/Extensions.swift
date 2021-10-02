//
//  Extensions.swift
//  To Do App
//
//  Created by Apple on 02/10/21.
//

import Foundation
import UIKit
extension Date{
    func toString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: self)
        return date
    }
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    func isTomorrow() -> Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
}
extension UIView{
    func setCardViewUI(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 7.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.7
    }
}
extension NSNotification.Name {
    static let reloadTable = NSNotification.Name("reload_tabledata")
}
