//
//  UISegmentedControl.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 20.06.2023.
//

import UIKit

extension UISegmentedControl {
    func getSelectedValue() -> String? {
        let selectedIndex = self.selectedSegmentIndex
        
        let selectedValue: String?
        
        if selectedIndex != UISegmentedControl.noSegment {
            selectedValue = self.titleForSegment(at: selectedIndex)
        } else {
            selectedValue = nil
        }
        
        return selectedValue
    }
}
