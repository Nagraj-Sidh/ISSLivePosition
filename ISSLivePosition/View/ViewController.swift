//
//  ViewController.swift
//  ISSLivePosition
//
//  Created by Nagraj on 2/25/23.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    private var viewModel = ISSPositionViewModel()
    private var interval = 3.0
    private var pointAnnotation: MKPointAnnotation?
    private var timer = Timer()
    
    private let mapView : MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.pointAnnotation = MKPointAnnotation()
        self.setMapConstraints()
        self.loadISSPosition()
        self.navigationItem.title = "ISS Live Position"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupTimer()
    }
    
    private func loadISSPosition() {
        viewModel.fetchISSLivePosition { [weak self] in
            self?.updateLocation()
        }
    }

    private func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: interval,
                             repeats: true) { timer in
            self.loadISSPosition()
        }
    }
    
    func setMapConstraints() {
        self.view.addSubview(self.mapView)
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.mapView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
        self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func updateLocation() {
        if let issLatitude = self.viewModel.position?.latitude, let issLongitude = self.viewModel.position?.longitude {
            let coordinateCenter:CLLocationCoordinate2D = CLLocationCoordinate2DMake(issLatitude, issLongitude);
            let coordinateRegion = MKCoordinateRegion(center: coordinateCenter,
                                                      latitudinalMeters: 10000000,
                                                      longitudinalMeters: 10000000)
            
            guard let point = self.pointAnnotation else { return }
            point.title = "ISS"
            point.subtitle = String("(latiTude = \(issLatitude)&longiTude = \(issLongitude))")
            point.coordinate = coordinateCenter
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.mapView.setRegion(coordinateRegion, animated: true)
                self.mapView.addAnnotation(point)
                self.showCircle(coordinate: point.coordinate, radius: 1000000)
            })
        }
    }
    
    func showCircle(coordinate: CLLocationCoordinate2D,
                    radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate,
                              radius: radius)
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.addOverlay(circle)
    }
    
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.fillColor = .red
            circleRenderer.alpha = 0.2
            circleRenderer.strokeColor = .red
            return circleRenderer
        }
        
        return MKOverlayRenderer()
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}

