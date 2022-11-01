//
//  UIView+Ext.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 29.10.2022.
//

import UIKit

extension UIView {
    @discardableResult func prepareForAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
