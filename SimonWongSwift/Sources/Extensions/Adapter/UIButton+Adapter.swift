//
//  UIButton+Adapter.swift
//  SimonWongSwift
//
//  Created by SimonWong on 2019/2/28.
//  Copyright © 2020 SimonWong. All rights reserved.
//

import UIKit

extension UIButton {
    
    static func useAdapter() {
        DispatchQueue.once(token: "UIButton+Adapter") {
            if
                let originalMethod = class_getInstanceMethod(Self.self, #selector(Self.init(coder:))),
                let exchangingMethod = class_getInstanceMethod(Self.self, #selector(Self.adapterInit(coder:)))
            {
                method_exchangeImplementations(originalMethod, exchangingMethod)
            }
        }
    }
    
    @objc private func adapterInit(coder aDecoder: NSCoder) -> UIButton {
        let button = adapterInit(coder: aDecoder)
        if (button.titleLabel == nil) { return button }
        var fontSize = button.titleLabel!.font.pointSize
        if UIDevice.iPhoneSeries.screenSizeIsEqual_iPhoneX || UIDevice.iPhoneSeries.screenSizeIsEqual_iPhone12 {
            fontSize += FontSizeDecrement.decrement_1
        } else if UIDevice.iPhoneSeries.screenSizeIsEqual_iPhone8 {
            fontSize += FontSizeDecrement.decrement_2
        } else if UIDevice.iPhoneSeries.screenSizeIsLessThanOrEqual_iPhoneSE {
            fontSize += FontSizeDecrement.decrement_3
        }
        button.titleLabel!.font = button.titleLabel!.font.withSize(fontSize)
        return button
    }
    
}
