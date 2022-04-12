//
//  RateViewController.swift
//  TableViewAppNEXTGeneration
//
//  Created by Roman Kochnev on 02.02.2018.
//  Copyright © 2018 Roman Kochnev. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var rateStackView: UIStackView!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var brilliantButton: UIButton!
    var restRating: String?
    
    @IBAction func rateRestaurant(sender: UIButton) {
        switch sender.tag {
        case 0:
            restRating = "bad"
        case 1:
            restRating = "good"
        case 2:
            restRating = "brilliant"
        default:
            break
        }
        
        performSegue(withIdentifier: "unwindSegueToDVC", sender: sender)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    //    UIView.animate(withDuration: 0.4) {
    //        self.rateStackView.transform = CGAffineTransform(scaleX: 1, y: 1)
    //    }
        
        let buttonArray = [badButton, goodButton, brilliantButton]
        for (index, button) in buttonArray.enumerated() {
            let delay = Double(index) * 0.2
            UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                button?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        badButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        goodButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        brilliantButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        // Создаем эффект размытия
        let blurEffect = UIBlurEffect(style: .dark)
        // Создаем View для эффекта размытия
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        // Определяем размер новой blurEffectView - должен быть как рамки самого view
        blurEffectView.frame = self.view.bounds
        // Устанавливаем подвижную высоту и ширину эффекта размытия для горизонтального вида
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // Добавляем View поверх текущего
        self.view.insertSubview(blurEffectView, at: 1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
