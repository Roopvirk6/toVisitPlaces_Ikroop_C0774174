//
//  MapViewController.swift
//  toVisitPlaces_Ikroop_C0774174
//
//  Created by VirkIkroop on 2020-06-15.
//  Copyright © 2020 VirkIkroop. All rights reserved.
//
import MapKit
import UIKit

class MapViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate  {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
