//
//  PageViewController.swift
//  TableViewAppNEXTGeneration
//
//  Created by Roman Kochnev on 07.02.2018.
//  Copyright © 2018 Roman Kochnev. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var headersArray = ["Записывайте", "Находите"]
    var subheadersArray = ["Создайте свой список любимых мест", "Находите и отмечайте на карте ваши любимые места"]
    var imagesArray = ["food", "iphoneMap"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Подписываемся, что мы действительно реализуем методы протокола UIPageViewControllerDataSource
        dataSource = self

        if let firstViewController = displayViewController(atIndex: 0) {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayViewController(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        guard let contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else { return nil }
        
        contentViewController.header = headersArray[index]
        contentViewController.subheader = subheadersArray[index]
        contentViewController.imageFile = imagesArray[index]
        contentViewController.index = index
        
        return contentViewController
    }
    
    func nextViewController(atIndex index: Int) {
        if let contentViewController = displayViewController(atIndex: index + 1) {
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

// Подписываемся под протокол для возможности листать взад-вперед ContentVC
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
    
    // Реализуем стандартный навигатор из точек с черной панелью снизу
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return headersArray.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        let contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController
//        return contentViewController!.index
//    }
}
