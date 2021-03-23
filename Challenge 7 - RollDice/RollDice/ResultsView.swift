//
//  ResultsView.swift
//  RollDice
//
//  Created by Tiberiu on 12.03.2021.
//

import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var results: Results
    
    var body: some View {
        List {
            ForEach(results.results, id: \.self) { result in
                HStack {
                    Spacer()
                    Text(result)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
            .onDelete(perform: removeResults)
        }
    }
    
    func removeResults(at offSets: IndexSet) {
        results.results.remove(atOffsets: offSets)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
