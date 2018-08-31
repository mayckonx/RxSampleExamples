//
//  BubbleViewModel.swift
//  Example1
//
//  Created by Mayckon Barbosa da Silva on 8/29/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ChameleonFramework


class BubbleViewModel {
    
    var centerVariable = Variable<CGPoint?>(.zero)
    var backgroundColorObservable: Observable<UIColor>!
    
    init() {
        setup()
    }
    
   func setup() {
        backgroundColorObservable = centerVariable.asObservable()
        .map { center -> UIColor in
            
            guard let center = center else { return UIColor.flatten(.black)() }
            
            let red: CGFloat = ((center.x + center.y) .truncatingRemainder(dividingBy: 255.0)) / 255.0 // We just manipulate red, but you can do w/e
            let green: CGFloat = 0.0
            let blue: CGFloat = 0.0
            
            return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
        }
    }
}
