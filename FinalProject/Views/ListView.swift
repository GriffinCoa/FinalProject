//
//  ContentView.swift
//  FinalProject
//
//  Created by Griffin Coates on 12/6/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListView: View {
//    enum Filters: String, CaseIterable {
//        case name, isbn, courseName, condition
//    }
    
    
    @EnvironmentObject var listVM: ListViewModel
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    @FirestoreQuery(collectionPath: "uploads") var uploads: [Upload]
    @State private var presentSheet = false
    @State private var searchText = ""
//    @State private var selectedFilter: Filters = .courseName
    let currentUserEmail = Auth.auth().currentUser!.email ?? ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(self.uploads.filter{(self.searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.searchText))}, id: \.id) { upload in
                    if currentUserEmail != upload.userID {
                        NavigationLink {
                            ExistingUploadView(upload: upload)
                        } label: {
                            VStack (alignment: .leading) {
                                Text(upload.name)
                                    .font(.title2)
                                Text(upload.courseName)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Available Listings")
            .toolbarBackground(Color("gold"), for: .navigationBar)
            .toolbarBackground(Color("maroon"), for: .bottomBar)
            .toolbarBackground(.visible, for: .bottomBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .listStyle(.grouped)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentSheet = true
                    } label: {
                        Text("My Listings")
                            .foregroundColor(Color("maroon"))
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        do {
                            try Auth.auth().signOut()
                            print("Log Out Succesfull!")
                            dismiss()
                        } catch {
                            print("ERROR: Could not sign out!")
                        }
                    } label: {
                        Text("Sign Out")
                            .foregroundColor(Color("maroon"))
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
            }
            .searchable(text: $searchText)
            .padding()
//            Text("Filtered Search")
//                .font(.title2)
//            Picker("", selection: $selectedFilter) {
//                ForEach(Filters.allCases, id: \.self) { filter in
//                    Text(filter.rawValue)
//                }
//            }
//            .pickerStyle(.segmented)
//            .padding()
        }
        .fullScreenCover(isPresented: $presentSheet) {
            UserUploadsView()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(ListViewModel())
    }
}
