//
//  ViewController.swift
//  Framework
//
//  Created by Clementine Ferreol on 29/01/2018.
//  Copyright © 2018 Clementine Ferreol. All rights reserved.
//

import UIKit


class ViewController: UITableViewController {
    
    @IBAction func addButon(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Join queue", message: "Tictactoe Online", preferredStyle: .alert)
        
        alert.addTextField { (image ) in
            image.text = ""
            image.placeholder = "URL de l'image"
        }
        
        alert.addTextField { (title ) in
            title.text = ""
            title.placeholder = "Titre de l'annonce"
        }
        
        alert.addTextField { (price) in
            price.text = ""
            price.placeholder = "Prix de l'annonce"
        }
        
        alert.addTextField { (type) in
            type.text = ""
            type.placeholder = "Type de de l'objet"
        }
        
        alert.addTextField { (adress) in
            adress.text = ""
            adress.placeholder = "Adresse du vendeur"
        }
        
        alert.addTextField { (date) in
            let dateAdd = Date()
            let formatter = DateFormatter()
            formatter.locale =  Locale(identifier: "fr")
            formatter.dateFormat = "dd MMMM yyyy à HH:mm"
            let result = formatter.string(from: dateAdd)
            date.text = result
        }

        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            //let titleAlert = alert?.title!
            
            let image = alert?.textFields![0] as UITextField!
            let title = alert?.textFields![1] as UITextField!
            let price = alert?.textFields![2] as UITextField!
            let type = alert?.textFields![3] as UITextField!
            let adress = alert?.textFields![4] as UITextField!
            let date = alert?.textFields![5] as UITextField!
            if((image?.text!)! != "" || (title?.text!)! != "" || (price?.text!)! != "" || (type?.text!)! != "" || (adress?.text!)! != "" ){
                self.tab.append([
                    "image" : (image?.text!)!,
                    "title" : (title?.text!)!,
                    "price" : (price?.text!)!,
                    "type" : (type?.text!)!,
                    "adress": (adress?.text!)!,
                    "date" : (date?.text!)!
                    ])
                let indexPath = IndexPath(row: (self.tab.count) - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    var tab = [
        ["image":"https://www.usinenouvelle.com/mediatheque/8/2/4/000244428_illustration_large.jpg",
         "title":"Bouteilles de Coca-Cola",
         "price":"35",
         "type":"Décoration",
         "adress":"8 rue Saint-Barthélémy Chauconin-Neufmontiers 77124",
         "date":"Le 23 Mars 2018 à 16h10"],
        
        ["image":"https://vignette.wikia.nocookie.net/kingdomhearts/images/e/ee/Chat_de_Cheshire_KH%CF%87.png/revision/latest?cb=20130710144744&path-prefix=fr",
         "title":"Chat de Cheshire",
         "price":"1000",
         "type":"Meow",
         "adress":"8 rue Saint-Barthélémy Chauconin-Neufmontiers 77124",
         "date":"Le 23 Mars 2018 à 16h27"],
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editModePressed))
        self.navigationItem.leftBarButtonItem = editButton
    }
    
    @objc func editModePressed() {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    //can move
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //can
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmp = self.tab[sourceIndexPath.row]
        self.tab.insert(tmp, at: destinationIndexPath.row)
        self.tab.remove(at: sourceIndexPath.row)

    }
    
    //can edit
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.tab.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tab.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        cell.prepareView(data: tab[indexPath.row])
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "showDetail"){
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! DetailViewController
            
            let index = self.tableView.indexPathForSelectedRow?.row
            print(tab[index!])
            controller.product = tab[index!]
        }
      
    }
}

import MapKit

class DetailViewController:UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    var product: [String: String]?
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        coordinates(forAddress: self.product!["adress"]!) {
            (location) in
            guard let location = location else {
                // Handle error here.
                return
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: false)
            self.mapView.addAnnotation(annotation)
        }
        
        self.scrollView.delegate = self
        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1024)
        
        
        let url = URL(string: self.product!["image"]!)
        let imageUrl = try? Data(contentsOf: url!)
        
        let image = UIImageView()
        image.image = UIImage(data: imageUrl!)
        image.contentMode = .scaleAspectFill
        /*let image = UIImageView()
        image.image = UIImage(named:self.product!["image"]!)
        image.contentMode = .scaleToFill*/
        
        self.view.addSubviewGrid(view: image, grid:["x": 1, "y":1, "width":10, "height":4])
        
        let title = UILabel()
        title.text = self.product!["title"]!
        title.font = title.font.withSize(12)
        title.font = UIFont.boldSystemFont(ofSize: title.font.pointSize)
        title.textAlignment = .left
        title.textColor = .black
        
        self.view.addSubviewGrid(view: title, grid:["x": 1, "y":4.5, "width":6, "height":2])
        
        let priceT = UILabel()
        priceT.text = "Prix :"
        priceT.font = priceT.font.withSize(12)
        priceT.textAlignment = .left
        priceT.textColor = .black
        
        self.view.addSubviewGrid(view: priceT, grid:["x": 1, "y": 5, "width":2, "height":2])
        
        let price = UILabel()
        price.text = self.product!["price"]! + "€"
        price.font = price.font.withSize(12)
        price.textAlignment = .left
        price.textColor = .orange
        
        self.view.addSubviewGrid(view: price, grid:["x": 2, "y": 5, "width":2, "height":2])
        
        let adress = UILabel()
        adress.text = self.product!["adress"]!
        adress.font = price.font.withSize(12)
        adress.textAlignment = .left
        adress.textColor = .black
        
        self.view.addSubviewGrid(view: adress, grid:["x": 1, "y": 5.5, "width":10, "height":2])
        
        let date = UILabel()
        date.text = self.product!["date"]!
        date.font = price.font.withSize(12)
        date.textAlignment = .left
        date.textColor = .gray
        
        self.view.addSubviewGrid(view: date, grid:["x": 1, "y": 6, "width":5, "height":2])
        
    }
}


extension UIView{
    func addSubviewGrid(view: UIView, grid: [String: CGFloat]){
        let x = self.frame.width /  12 * grid["x"]!,
        y = self.frame.height / 12 * grid["y"]!,
        width = self.frame.width / 12 * grid["width"]!,
        height = self.frame.height / 12 * grid["height"]!
       
        
        view.frame = CGRect(x: x, y: y, width: width, height: height)
        self.addSubview(view)
    }
}

