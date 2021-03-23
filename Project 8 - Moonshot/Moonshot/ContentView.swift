//
//  ContentView.swift
//  Moonshot
//
//  Created by Tiberiu on 07.02.2021.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    //challange 3
    @State private var showDates = true
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        //challenge 3
                        Text(showDates ? "\(mission.formattedLaunchDate)" : "\(mission.crewMembers)")
                        
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            //challenge 3
            .navigationBarItems(leading: Button(showDates ? "Show names" : "Show dates") {
                self.showDates.toggle()
            })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
