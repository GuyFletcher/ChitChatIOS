//
//  ViewController.swift
//  ChitChat
//
//  Created by Hart, Fletcher on 4/5/18.
//  Copyright © 2018 Hart, Fletcher. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var postImage: UIImageView!
    
    var message: Message = Message()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\n\n\n",message.lat!)
        
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: message.message!, options: [], range: NSRange(location: 0, length: (message.message?.utf16.count)!))
        var url: Any
        for match in matches {
            guard let range = Range(match.range, in: message.message!) else { continue }
            url = URL(string: String(message.message![range]))!
            print(url)
            let pictureData = NSData(contentsOf: url as! URL)
            print(pictureData)
            if((pictureData) != nil) {
                let img = UIImage(data: pictureData! as Data)
                postImage.image = img
                postImage.contentMode = UIViewContentMode.scaleAspectFit
            }
        }
        
        if let lat = message.lat, let long = message.long, let latDoub = Double(lat), let longDoub = Double(long) {
            let loc = CLLocationCoordinate2DMake(latDoub, longDoub)
            
            print("Can print")
            print(latDoub, longDoub)
            
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: loc, span: span)
            self.mapView.setRegion(region, animated: false)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = loc
            self.mapView.addAnnotation(annotation)
            self.mapView.isZoomEnabled = true
            
           
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

