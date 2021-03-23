//
//  ContentView.swift
//  Bookworm
//
//  Created by Tiberiu on 15.02.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext)  var moc
    
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ])
    var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                        
                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown Title")
                                //challenge 2
                                .foregroundColor(book.rating == 1 ? .red : .black)
                                .font(.headline)
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            
                .navigationBarTitle("Bookworm")
                .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView().environment(\.managedObjectContext, moc)
                }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            //find this book in our fetch request
            let book = books[offset]
            
            //delete from context
            moc.delete(book)
        }
        
        //save the context
        try? moc.save()
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


