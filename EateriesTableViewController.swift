//
//  EateriesTableViewController.swift
//  TableViewAppNEXTGeneration
//
//  Created by Roman Kochnev on 31.01.2018.
//  Copyright © 2018 Roman Kochnev. All rights reserved.
//

import UIKit
import CoreData

class EateriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filteredResultArray: [Restaurant] = []
    var restaurants: [Restaurant] = []
    //        Restaurant(name: "Le Bourg 1905", type: "Ресторан", location: "Екатеринбург, улица Вайнера 9, Пассаж, 3 этаж", image: "ogonek.jpg", isVisited: false),
    //        Restaurant(name: "Friends", type: "Бар", location: "Екатеринбург", image: "elu.jpg", isVisited: false),
    //        Restaurant(name: "Balkan Grill", type: "Гриль-бар", location: "Екатеринбург", image: "bonsai.jpg", isVisited: false),
    //        Restaurant(name: "Dr. Живаго", type: "Ресторан", location: "Москва", image: "dastarhan.jpg", isVisited: false),
    //        Restaurant(name: "Sky View", type: "Ресторан", location: "Москва", image: "indokitay.jpg", isVisited: false),
    //
    //        Restaurant(name: "SSSR", type: "Ресторан", location: "Екатеринбург", image: "x.o.jpg", isVisited: false),
    //        Restaurant(name: "Mamina Mama", type: "Ресторан", location: "Екатеринбург", image: "balkan.jpg", isVisited: false),
    //        Restaurant(name: "Sverdlovsk One Love", type: "Ресторан", location: "Екатеринбург", image: "respublika.jpg", isVisited: false),
    //        Restaurant(name: "Vainer Oduvanchik", type: "Пекарня", location: "Екатеринбург", image: "speakeasy.jpg", isVisited: false),
    //        Restaurant(name: "Москва для лохов", type: "Забегаловка", location: "Москва", image: "morris.jpg", isVisited: false),
    //
    //        Restaurant(name: "Чай в троем", type: "Ресторан", location: "Санкт-Петербург", image: "istorii.jpg", isVisited: false),
    //        Restaurant(name: "Прага", type: "Ресторан", location: "Москва", image: "klassik.jpg", isVisited: false),
    //        Restaurant(name: "Chicago Village Pub", type: "Паб", location: "Владивосток", image: "love.jpg", isVisited: false),
    //        Restaurant(name: "Ural Federation", type: "Ресторан", location: "Екатеринбург", image: "shok.jpg", isVisited: false),
    //        Restaurant(name: "Hyatt Reach Bitch", type: "Кафе", location: "Екатеринбург", image: "bochka.jpg", isVisited: false),
    //        ]
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Убирать Navigation Bar при листании страницы
        //        navigationController?.hidesBarsOnSwipe = true
    }
    
    func filterContentFor(searchText text: String) {
        filteredResultArray = restaurants.filter{ (restaurant) -> Bool in
            return (restaurant.name?.lowercased().contains(text.lowercased()))!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        // Отменяем затемнение нашего VC при поиске
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        // Устанавливаем цвет панели поиска
        //searchController.searchBar.barTintColor = #colorLiteral(red: 0.1162125604, green: 0.6117347362, blue: 0.5950408836, alpha: 1)
        
        // Устанавливаем цвет текста панели поиска
        searchController.searchBar.tintColor = .white
        
        definesPresentationContext = true
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Убираем какой-либо текст у Navigation Bar'а, вместо него будет простая стрелочка
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Работа с Core Data
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                restaurants = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        let wasIntroWatched = userDefaults.bool(forKey: "wasIntroWatched")
        
        guard !wasIntroWatched else { return }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Fetch results controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        } else {
            return restaurants.count
        }
    }
    
    func restaurantToDisplayAt(indexPath: IndexPath) -> Restaurant {
        let restaurant: Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filteredResultArray[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        
        return restaurant
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        // Кастим, т.е. приводим к классу EateriesTableViewCell
        let restaurant = restaurantToDisplayAt(indexPath: indexPath)
        
        cell.thumbNailImageView.image = UIImage(data: restaurant.image! as Data)
        
        cell.thumbNailImageView.layer.cornerRadius = 22.5
        cell.thumbNailImageView.clipsToBounds = true
        
        cell.nameLabel.text = "fuck"
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        
        /*
         if self.restaurantsIsVisited[indexPath.row] {
         cell.accessoryType = .checkmark
         } else {
         cell.accessoryType = .none
         }
         */
        
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Убираем постоянное выделение ячейки
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let alectController = UIAlertController(title: nil, message: "Выберите действие", preferredStyle: .actionSheet)
     
     let alectAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
     
     // Выпадалка с передаваемым замыканием, создающее также другую выпадалку
     let call = UIAlertAction(title: "Позвонить: +7 (343) 555-46-7\(indexPath.row + 1)", style: .default) {
     (action: UIAlertAction) in
     let insideAlertController = UIAlertController(title: nil, message: "Вызов не может быть совершен", preferredStyle: .alert)
     let insideAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
     
     insideAlertController.addAction(insideAlertAction)
     
     self.present(insideAlertController, animated: true, completion: nil)
     }
     
     // Выпадалка с выставлением галочки о посещении с условиями
     let isVisitedTitle = self.restaurantsIsVisited[indexPath.row] ? "Я не был здесь" : "Я был здесь"
     let isVisited = UIAlertAction(title: isVisitedTitle, style: .default) {
     (action) in
     let cell = tableView.cellForRow(at: indexPath)
     
     self.restaurantsIsVisited[indexPath.row] = !self.restaurantsIsVisited[indexPath.row]
     cell?.accessoryType = self.restaurantsIsVisited[indexPath.row] ? .checkmark : .none
     }
     
     alectController.addAction(alectAction)
     alectController.addAction(isVisited)
     alectController.addAction(call)
     
     present(alectController, animated: true, completion: nil)
     
     // Убираем постоянное выделение ячейки
     tableView.deselectRow(at: indexPath, animated: true)
     }
     */
    
    /*
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     restaurantsNames.remove(at: indexPath.row)
     restaurantsImages.remove(at: indexPath.row)
     restaurantsIsVisited.remove(at: indexPath.row)
     }
     //tableView.reloadData()
     tableView.deleteRows(at: [indexPath], with: .fade)
     }
     */
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Действие "Поделиться"
        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
            let defaultText = "Я сейчас в " + self.restaurants[indexPath.row].name!
            if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        // Действие "Удалить"
        let delete = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            self.restaurants.remove(at: indexPath.row)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let restaurantToTrush = self.fetchResultsController.object(at: indexPath)
                context.delete(restaurantToTrush)
                
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        share.backgroundColor = #colorLiteral(red: 0.08923413604, green: 0.67247051, blue: 0.2700104117, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.9559139609, green: 0.04366312176, blue: 0.02865505219, alpha: 1)
        
        return [share, delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! EateryDetailViewController
                destinationViewController.restaurant = restaurantToDisplayAt(indexPath: indexPath)
            }
        }
    }
    
}

extension EateriesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Реализуем метод, чтобы при переходе из строки поиска на страницу конкретного ресторана результат был из нужного массива
        filterContentFor(searchText: searchController.searchBar.text!)
        // Обновить данные таблицы полностью
        tableView.reloadData()
    }
}

extension EateriesTableViewController: UISearchBarDelegate {
    // При листании и начале набора текста не убирать строку поиска
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchController.searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    // При листании и завершении набора текста не убирать строку поиска
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}
