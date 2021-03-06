//
//  MapViewController.swift
//  toVisitPlaces_Ikroop_C0774174
//
//  Created by VirkIkroop on 2020-06-15.
//  Copyright © 2020 VirkIkroop. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate  {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
        var locationManager = CLLocationManager()
        var destinationCoordinates : CLLocationCoordinate2D!
        let destCoordinate = MKDirections.Request()
        let button = UIButton()
        var places:[Places]?
        let defaults = UserDefaults.standard
        var lat : Double = 0.0
        var long : Double = 0.0
        var drag : Bool? = false
        
   
        
        

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
        
            
            mapView.isZoomEnabled = false
            mapView.delegate = self
            mapView.showsUserLocation = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
             locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
                   tap.numberOfTapsRequired = 2
                   mapView.addGestureRecognizer(tap)
            
            NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
            
            loadData()
            
            
        }
    
    func dragablePin(){
        self.lat = defaults.double(forKey: "latitude")
        self.long = defaults.double(forKey: "longitude")
        
        self.drag = defaults.bool(forKey: "bool")
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long )
        print(lat, long)
        mapView.addAnnotation(annotation)
    }
    
        
        
        
        func getDataFilePath() -> String {
               let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
               let filePath = documentPath.appending("/places-data.txt")
               return filePath
           }
        
        func loadData() {
            places = [Places]()
            
            let filePath = getDataFilePath()
            
            if FileManager.default.fileExists(atPath: filePath){
                do{
                    //creating string of file path
                 let fileContent = try String(contentsOfFile: filePath)
                    
                    let contentArray = fileContent.components(separatedBy: "\n")
                    for content in contentArray{
                       
                        let placeContent = content.components(separatedBy: ",")
                        if placeContent.count == 6 {
                           let place = Places(placeLat: Double(placeContent[0])!, placeLong: Double(placeContent[1])!, placeName: placeContent[2], city: placeContent[3], postalCode: placeContent[4], country: placeContent[5])
                            places?.append(place)
                        }
                    }
                }
                catch{
                    print(error)
                }
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             if let tableViewCell = segue.destination as? ViewController{
                 tableViewCell.places = self.places
             }
         }
         
        @objc func saveData() {
             let filePath = getDataFilePath()

             var saveString = ""
             for place in places!{
                saveString = "\(saveString)\(place.placeLat) \(place.placeLong) \(place.placeName) \(place.city) \(place.country) \(place.postalCode)\n"
                 do{
                try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
                 }
                 catch{
                     print(error)
                 }
             }
         }
        
         @objc func handleTap(recognizer: UITapGestureRecognizer) {
                
               let mapAnnotations  = self.mapView.annotations
               self.mapView.removeAnnotations(mapAnnotations)
               let tapLocation = recognizer.location(in: mapView)
               self.destinationCoordinates = mapView.convert(tapLocation, toCoordinateFrom: mapView)
                   
                   
                   if recognizer.state == .ended
                   {
                       
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = self.destinationCoordinates!
                        annotation.title = "Your destination"
                        self.mapView.addAnnotation(annotation)
                   }
               }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
                   let userLocation = locations[0]
                   let latitude = userLocation.coordinate.latitude
                   let longitude = userLocation.coordinate.longitude
                    
                   let latDelta: CLLocationDegrees = 0.05
                   let longDelta: CLLocationDegrees = 0.05
                    
                    // 3 - Creating the span, location coordinate and region
                   let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
                   let customLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                   let region = MKCoordinateRegion(center: customLocation, span: span)
                          
                    // 4 - assign region to map
                   mapView.setRegion(region, animated: true)
                }
    
    
    
    
    @IBAction func locBtn(_ sender: UIButton) {
        
        getRoute()
    }
    
       
        func getRoute() {
              
                      let sourceCoordinate = mapView.userLocation.coordinate
                      
                      let source = CLLocationCoordinate2DMake(sourceCoordinate.latitude, sourceCoordinate.longitude)
                        let destination = CLLocationCoordinate2DMake(self.destinationCoordinates?.latitude ?? 0.0, self.destinationCoordinates?.longitude ?? 0.0)
                      
                      let sourcePlacemark = MKPlacemark(coordinate: source)
                      let destPlacemark = MKPlacemark(coordinate: destination)
               
                        destCoordinate.transportType = .automobile
                                  for overlay in mapView.overlays{
                                      mapView.removeOverlay(overlay)
                                    }
                           
                        
               destCoordinate.source = MKMapItem(placemark: sourcePlacemark)
               destCoordinate.destination =  MKMapItem(placemark: destPlacemark)
               
               
               let direction = MKDirections(request: destCoordinate)
               direction.calculate{
                   (response, error) in
                      guard let locResponse = response else{
                                 if let error = error{
                                     print(error)
                                 }
                                 return
                           }
                       for route in locResponse.routes{
                              self.mapView.addOverlay(route.polyline,level:.aboveRoads)
                              self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                          }
                         
                      }
           }
        
        func geocode()  {
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: destinationCoordinates.latitude, longitude: destinationCoordinates.longitude)) {  placemark, error in
               if let error = error as? CLError {
                   print("CLError:", error)
                   return
                }
               else if let placemark = placemark?[0] {
                
                var placeName = ""
                var neighbourhood = ""
                var city = ""
                var state = ""
                var postalCode = ""
                var country = ""
                
                
                if let name = placemark.name {
                    placeName += name
                            }
                if let sublocality = placemark.subLocality {
                    neighbourhood += sublocality
                            }
                if let locality = placemark.subLocality {
                     city += locality
                            }
                if let area = placemark.administrativeArea {
                              state += area
                          }
                if let code = placemark.postalCode {
                              postalCode += code
                          }
                if let cntry = placemark.country {
                                        country += cntry
                                    }
    //          print(placeName ,city, state, postalCode , country)
                
                
                let place = Places(placeLat: self.destinationCoordinates.latitude, placeLong:self.destinationCoordinates.longitude, placeName: placeName, city: city, postalCode: postalCode, country: country)
              
    
              
                self.places?.append(place)
                self.saveData()
                self.navigationController?.popToRootViewController(animated: true)

                   
                
                
                   
                }
            
            }
        }
        
      
        
       
    }

    extension MapViewController {
        
           func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
                if annotation is MKUserLocation {
                    return nil
                }
            
                    let pinAnnotation = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
                    pinAnnotation.markerTintColor = .systemPink
                    pinAnnotation.glyphTintColor = .white
                    pinAnnotation.canShowCallout = true
            
                    button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                    pinAnnotation.rightCalloutAccessoryView = button
                    return pinAnnotation
        
            }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
             let alertController = UIAlertController(title: "Add to Favourites", message:
                "Do you like to add Location to favourites?", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Yes", style:  .default, handler: { (UIAlertAction) in
                self.geocode()
                
            }))
        
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alertController, animated: true, completion: nil)
                        
        }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)

        if (destCoordinate.transportType == .automobile){
                        renderer.strokeColor = UIColor.orange
                        renderer.lineWidth = 5.0
                        return renderer
        }  else if (destCoordinate.transportType == .walking){
                        renderer.strokeColor = UIColor.blue
                        renderer.lineDashPattern = [2,4]
                        renderer.lineWidth = 5.0
                        return renderer
        
        }
        return renderer
    }

    }

    
   
    
    
            
        
        
        
         
        
        
    
