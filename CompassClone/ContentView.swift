//
//  ContentView.swift
//  CompassClone
//
//  Created by Suyeon Cho on 15/11/23.
//

import SwiftUI
import MapKit


struct ContentView: View  {
    @ObservedObject private var locationMananger = LocationManager()
    
    @ObservedObject var compassHeading = CompassHeading()
    
    @State private var locationDataLbl: String = ""
    @State private var altitude: Double = 0.0
    
    private func angleLabel(label:Int64) -> String {
        if label == 0{
            return "N"}
        else if label > 0 && label<90{
            return "SE"
        }
        else if label == 90{
            return "E"
        }
        else if label > 90 && label<180{
            return "NW"
        }
        else if label == 180{
            return "S"
        }
        else if label > 180 && label<270{
            return "NW"
        }
        else if label == 270{
            return "W"
        }
        else if label > 270{
            return "SW"
        }
        return ""
    }
    
    private var geocoder: CLGeocoder!
       
    
    
    var body: some View {
        VStack {
            VStack{
                Capsule()
                    .frame(width: 5,
                           height: 50)
                ZStack {
                    // 2
                    ForEach(Marker.markers(), id: \.self) { marker in
                        MarkerCompassView(marker: marker,
                                          compassDegress: self.compassHeading.degrees)
                        
                    }
                    
                }
                .frame(width: 300,
                       height: 300)
                .rotationEffect(Angle(degrees: self.compassHeading.degrees))
                // 3
                .statusBar(hidden: true)
                
            }
            .accessibilityHidden(true)
            
            Text("\(abs(Int64(self.compassHeading.degrees))) ° \(angleLabel(label:abs(Int64(self.compassHeading.degrees)))) ")
                .font(.largeTitle)
                .padding(.bottom)
                .accessibilityLabel("\(abs(Int64(self.compassHeading.degrees))) ° \(angleLabel(label:abs(Int64(self.compassHeading.degrees)))) degree")
                
            
            //Coordinate
            let coordinate = self.locationMananger.location != nil ? self.locationMananger.location!.coordinate : CLLocationCoordinate2D()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            //Constrain
            Text("\(location.latitude)   \(location.longitude)").font(.title2).padding(.bottom, 2.0).accessibilityLabel("\(location.latitude)   \(location.longitude)")
            
            
            //Address
            Text("\(locationDataLbl)").font(.title2).padding(.bottom, 2.0)
                .accessibilityLabel("\(locationDataLbl)")
            
            Text("\(String(format: "%.1f m Elevation", altitude))").font(.title2)
                .accessibilityLabel("\(String(format: "%.1f m Elevation", altitude))")
           
        
           
            
           
        }.accessibilityElement(children: .combine).onAppear {
            fetchLocationData() // Fetch location data when the view appears
            if let altitude = locationMananger.location?.altitude {
                self.altitude = altitude
            }
        }
        
    }
    private func fetchLocationData() {
            guard let location = locationMananger.location else { return }

            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocoding error: \(error)")
                    return
                }

                // Extract placemark information
                if let placemark = placemarks?.first {
//                    let streetNumber = placemark.subThoroughfare ?? ""
//                    let streetName = placemark.thoroughfare ?? ""
                    let city = placemark.locality ?? ""
                    let state = placemark.administrativeArea ?? ""
//                    let zipCode = placemark.postalCode ?? ""

                    // Update locationDataLbl asynchronously
                    DispatchQueue.main.async {
                        // Update the label text using extracted placemark information
                        self.locationDataLbl = " \(state), \(city) "
                    }
                }
            }
        }
    
}
extension BinaryFloatingPoint {
    var dms: (degrees: Int, minutes: Int, seconds: Int) {
        var seconds = Int(self * 3600)
        let degrees = seconds / 3600
        seconds = abs(seconds % 3600)
        return (degrees, seconds / 60, seconds % 60)
    }
}
extension CLLocation {
    var dms: String { latitude + " " + longitude }
    var latitude: String {
        let (degrees, minutes, seconds) = coordinate.latitude.dms
        return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? "N" : "S")
    }
    var longitude: String {
        let (degrees, minutes, seconds) = coordinate.longitude.dms
        return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? "E" : "W")
    }
}


#Preview {
    ContentView()
}
