//
//  Map.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import Foundation
import MapKit

class Artwork: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let discipline: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    locationName: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return locationName
  }
    var markerTintColor: UIColor  {
      switch discipline {
      case "Arrival":
        return .blue
      case "Departure":
        return .green
      default:
        return .blue
      }
    }

}

//-----------------------------------------
class ArtworkMarkerView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      // 1
      guard let artwork = newValue as? Artwork else {
        return
      }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

      // 2
      markerTintColor = artwork.markerTintColor
      if let letter = artwork.discipline?.first {
        glyphText = String(letter)
      }
    }
  }
}



