//
//  MapViewController.swift
//  test_yape_ios
//
//  Created by iMac on 24/02/23.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    var datum: Datum?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initComponent()
    }
    func initComponent() {
        let pin = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: datum?.lat ?? 0, longitude: datum?.lot ?? 0))
        self.map.addAnnotation(pin)
        
        let center = CLLocationCoordinate2D(latitude: datum?.lat ?? 0, longitude: datum?.lot ?? 0)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.map.setRegion(region, animated: true)
    }

    @IBAction func onClose(button: UIButton) {
        self.dismiss(animated: true)
    }
    static func show(controller: UIViewController, datum: Datum) {
        let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
        mapViewController.datum = datum
        mapViewController.modalPresentationStyle = .overFullScreen
        controller.present(mapViewController, animated: true)
    }
}
