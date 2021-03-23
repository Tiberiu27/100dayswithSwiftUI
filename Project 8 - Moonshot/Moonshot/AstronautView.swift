//
//  AstronautView.swift
//  Moonshot
//
//  Created by Tiberiu on 08.02.2021.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    //challenge 2
    let missions: [Mission]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                    
                    
                    Text("Flown in: ")
                    
                    ForEach(missions) { mission in
                        Text("\(mission.displayName)")
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    //challenge 2
    init(astronaut: Astronaut, missions: [Mission]) {
        self.astronaut = astronaut
        
        var matches = [Mission]()
       
        for mission in missions {
            if mission.crew.contains(where: { $0.name == astronaut.id}) {
                matches.append(mission)
            }
        }
        self.missions = matches
    }

}

struct AstronautView_Previews: PreviewProvider {
    
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[0], missions: missions)
    }
}
