//
//  SwiftyAccordionCells.swift
//  SwiftyAccordionCells
//
//  Created by Fischer, Justin on 9/24/15.
//  Copyright © 2015 Justin M Fischer. All rights reserved.
//

import Foundation

class SwiftyAccordionCells {
    fileprivate (set) var items = [Item]()
    
    class Item {
        var isHidden: Bool
        var value: String
        var isChecked: Bool
        var cellType: AnyObject
        var isHeaderExpanded: Bool = false
        
        init(_ hidden: Bool = true, value: String, checked: Bool = false, cellType: AnyObject) {
            self.isHidden = hidden
            self.value = value
            self.isChecked = checked
            self.cellType = cellType
        }
    }
    
    
    class HeaderItem: Item {
        init (value: String) {
            //super.init(false, value: value, checked: false)
            super.init(false, value: value, checked: false,cellType: "RentalCabListRateCardTableViewCell" as AnyObject)
            self.isHeaderExpanded = false
        }
    }
    
    func append(_ item: Item) {
        self.items.append(item)
    }
    
    func removeAll() {
        self.items.removeAll()
    }
    
    func expand(_ headerIndex: Int) {
        self.items[headerIndex].isHeaderExpanded = true
        self.toogleVisible(headerIndex, isHidden: false)
    }
    
    func collapse(_ headerIndex: Int) {
        self.items[headerIndex].isHeaderExpanded = false
        self.toogleVisible(headerIndex, isHidden: true)
    }
    
    private func toogleVisible(_ headerIndex: Int, isHidden: Bool) {
        var headerIndex = headerIndex
        headerIndex += 1
        
        while headerIndex < self.items.count && !(self.items[headerIndex] is HeaderItem) {
            self.items[headerIndex].isHidden = isHidden
            
            headerIndex += 1
        }
    }
}
