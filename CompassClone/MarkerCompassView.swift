//
//  MarkerCompassView.swift
//  CompassClone
//
//  Created by Suyeon Cho on 15/11/23.
//

import SwiftUI
struct Marker: Hashable {
    let degrees: Double
    let label: String

    init(degrees: Double, label: String = "") {
        self.degrees = degrees
        self.label = label
    }

    func degreeText() -> String {
        return String(format: "%.0f", self.degrees)
    }

    static func markers() -> [Marker] {
        return [
            Marker(degrees: 0, label: "S"),
            Marker(degrees: 30),
            Marker(degrees: 60),
            Marker(degrees: 90, label: "W"),
            Marker(degrees: 120),
            Marker(degrees: 150),
            Marker(degrees: 180, label: "N"),
            Marker(degrees: 210),
            Marker(degrees: 240),
            Marker(degrees: 270, label: "E"),
            Marker(degrees: 300),
            Marker(degrees: 330)
        ]
    }
}
struct MarkerCompassView: View {
    let marker: Marker
        let compassDegress: Double

        var body: some View {
            VStack {
                // 1
                Text(marker.degreeText())
                        .fontWeight(.light)
                        .rotationEffect(self.textAngle())

                // 2
                Capsule()
                    .frame(width: self.capsuleWidth(),
                           height: self.capsuleHeight())
                    .foregroundColor(self.capsuleColor())
                
                  
                // 3
                Text(marker.label)
                    .fontWeight(.bold)
                    .rotationEffect(self.textAngle())
                    .padding(.bottom, 180)
                //4
                
            }
            .rotationEffect(Angle(degrees: marker.degrees)) // 4
            
     
        }
    // 1
    private func capsuleWidth() -> CGFloat {
        return self.marker.degrees == 0 ? 7 : 3
    }

    // 2
    private func capsuleHeight() -> CGFloat {
        return self.marker.degrees == 0 ? 45 : 30
    }

    // 3
    private func capsuleColor() -> Color {
        return self.marker.degrees == 0 ? .red : .gray
    }

    // 4
    private func textAngle() -> Angle {
        return Angle(degrees: -self.compassDegress - self.marker.degrees)
    }
}
//
//#Preview {
//    MarkerCompassView(marker: <#Marker#>, compassDegress: <#Double#>)
//}
