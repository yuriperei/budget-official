//
//  MapaViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 4/1/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController{

    var local: Local?
    var endereco:String?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let local = local {
            endereco = local.rua! + " - " + local.cidade! + " - " + local.estado!
        }
                
        let geo: CLGeocoder = CLGeocoder()
        geo.geocodeAddressString(endereco!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível localizar com o endereço cadastrado")
                self.presentViewController(alert, animated: true, completion: nil)
            }
            if let placemark = placemarks?.first {
                
                let location = placemark.location
                let coords:CLLocationCoordinate2D = location!.coordinate
                let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coords, 1000, 1000)
                self.mapView.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                
                if let local = self.local {

                    annotation.coordinate = coords
                    annotation.title = local.nome! + " / " + placemark.locality! + " - " + placemark.administrativeArea!
                    annotation.subtitle = placemark.subLocality! + " - " + placemark.name!
                    
                }else{

                    annotation.coordinate = coords
                    annotation.title = placemark.locality! + " - " + placemark.administrativeArea!
                    annotation.subtitle = placemark.subLocality! + " - " + placemark.name!

                }
                 self.mapView.addAnnotation(annotation)
            }
        })
        

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
