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
    
    var locationManager = CLLocationManager()
        var destinationCoordinates : CLLocationCoordinate2D!
        let destCoordinate = MKDirections.Request()
        let button = UIButton()
       // var places:[Places]?
        
   
        
        var favPlace: CLLocation?

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
            mapView.isZoomEnabled = false
            mapView.delegate = self
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
                   tap.numberOfTapsRequired = 2
                   mapView.addGestureRecognizer(tap)
           
            
            
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

        
    @IBAction func locationBtn(_ sender: Any) {
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
                "Do you want to add marked Location to favourites?", preferredStyle: .actionSheet)
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


