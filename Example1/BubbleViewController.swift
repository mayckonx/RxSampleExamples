//
//  BubbleViewController.swift
//  Example1
//
//  Created by Mayckon Barbosa da Silva on 8/29/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ChameleonFramework

class BubbleViewController: UIViewController {

    
    var circleView: UIView!
    var bubbleViewModel: BubbleViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100, height: 100)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = .green
        view.addSubview(circleView)
        
        bubbleViewModel = BubbleViewModel()
        
        circleView
        .rx.observe(CGPoint.self, "center")
        .bind(to: bubbleViewModel.centerVariable)
        .disposed(by: disposeBag)
        
        bubbleViewModel.backgroundColorObservable
        .subscribe(onNext: { [weak self] backgroundColor in
            UIView.animate(withDuration: 0.1, animations: {
                self?.circleView.backgroundColor = backgroundColor
                let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
                
                if viewBackgroundColor != backgroundColor {
                    self?.view.backgroundColor = viewBackgroundColor
                }
            })
        })
        .disposed(by: disposeBag)
        
        
        // Add gesture recognizer
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
