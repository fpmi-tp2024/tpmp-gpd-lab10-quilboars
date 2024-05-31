//
//  MapViewController.swift
//  QuilBus
//
// Created by Michael Romanov on 5/29/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet weak var departurePointTextField: UITextField!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var getToLabel: UILabel!
    @IBOutlet weak var findButton: UIButton!
    
    var suggestions: [String]! = []
    var activeAnnotations: [Artwork]! = []
    
    public var CtxManager: ContextManager!;
    var _userRepository: UserRepository!;
    var _localityRepository: LocalityRepository!;
    var _roureRepository: RouteRepository!;
    var _ridesRepository: RideRepository!;
    var _bookedTicketRepository: BookedTicketRepository!;
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        return !autoCompleteText(in: textField, using: string, suggestionsArray: suggestions);
    }
    
    @IBAction func findButtonClicked(_ sender: Any) {
        let request = departurePointTextField.text;
        
        if(request == nil){
            validationLabel.isHidden = false;
            return;
        }
        
        if(!suggestions.contains(request!)){
            validationLabel.isHidden = false;
            return;
        }
        
        validationLabel.isHidden = true;
        
        let locality = _localityRepository.GetLocalityByName(name: request!);
        
        var localities: [Locality] = []
        
        let routes = locality![0].routesFrom!.allObjects as! [Route];
        for route in routes{
            localities.append(route.to!);
        }
        RefreshAnnotations(localities: localities, departure: locality![0]);
    }
    
    func RefreshAnnotations(localities: [Locality], departure: Locality){
        map.removeAnnotations(activeAnnotations);
        map.reloadInputViews()
        print(localities)
        
        let coordDep = CLLocationCoordinate2D(latitude: departure.latitude, longitude: departure.longitude);
        
        var loc = Artwork(title: departure.name, locationName: departure.name! + ", Belarus", discipline: "Departure", coordinate: coordDep)
        
        map.addAnnotation(loc);
        activeAnnotations.append(loc);
        
        for locality in localities
        {
            var desc = locality.name! + ", Belarus";
            var coord = CLLocationCoordinate2D(latitude: locality.latitude, longitude: locality.longitude);
            let loc2 = Artwork(title: locality.name, locationName: desc, discipline: "Arrival", coordinate: coord)
            
            /*let loc = MKPointAnnotation();
            
            loc.title = locality.name;
            loc.coordinate = CLLocationCoordinate2D(latitude: locality.latitude, longitude: locality.longitude);*/
            map.addAnnotation(loc2);
            activeAnnotations.append(loc2);
        }
        map.reloadInputViews()
    }
    
    func autoCompleteText(in textField: UITextField, using string: String, suggestionsArray: [String]) -> Bool{
        if !string.isEmpty,

           let selectedTextRange = textField.selectedTextRange,

           selectedTextRange.end == textField.endOfDocument,

           let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),

           let text = textField.text( in : prefixRange) {

            let prefix = text + string

            let matches = suggestionsArray.filter {

                $0.hasPrefix(prefix)

            }

            if (matches.count > 0) {

                textField.text = matches[0]

                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {

                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)

            return true

        }

            }

        }

        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

            textField.resignFirstResponder()

            return true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self;
        map.register(
          ArtworkMarkerView.self,
          forAnnotationViewWithReuseIdentifier:
            "artwork")
        
        let ctx = ContextRetriever.RetrieveContext();
        CtxManager = ContextManager(context: ctx);
        _userRepository = UserRepository(contextManager: CtxManager);
        _localityRepository = LocalityRepository(contextManager: CtxManager);
        _roureRepository = RouteRepository(contextManager: CtxManager);
        _ridesRepository = RideRepository(contextManager: CtxManager);
        _bookedTicketRepository = BookedTicketRepository(contextManager: CtxManager);
        
        let localities = _localityRepository.GetLocalities()!;
        
        for locality in localities{
            suggestions.append(locality.name!);
        }
        
        departurePointTextField.delegate = self;
        
        getToLabel.text = NSLocalizedString("MAP_GET_TO", comment: "")
        findButton.setTitle(NSLocalizedString("FIND", comment: ""), for: .normal)
        departurePointTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("DEPARTURE_POINT", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        validationLabel.text = NSLocalizedString("DEPARTURE_NOT_FOUND", comment: "")
    }
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
      ) -> MKAnnotationView? {
        print("in annot view")
        // 2
        guard let annotation = annotation as? Artwork else {
          return nil
        }
        // 3
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKMarkerAnnotationView {
            print("MkMarkerAnnotView")
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
          // 5
          view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
          view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
      }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 7
            return renderer
        }

        return MKOverlayRenderer()
    }
    
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
