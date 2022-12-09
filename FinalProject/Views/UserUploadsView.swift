//
//  UserUploadsView.swift
//  FinalProject
//
//  Created by Griffin Coates on 12/9/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct UserUploadsView: View {
    @EnvironmentObject var listVM: ListViewModel
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    @FirestoreQuery(collectionPath: "uploads") var uploads: [Upload]
    let currentUserEmail = Auth.auth().currentUser!.email ?? ""
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(uploads) { upload in
                    if currentUserEmail == upload.userID {
                        NavigationLink {
                            UploadView(upload: upload)
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
                .onDelete { indexSet in
                    guard let index = indexSet.first else {return}
                    Task {
                        await listVM.deleteUpload(upload: uploads[index])
                    }
                }
            }
            
            .navigationTitle("My Listings")
            .toolbarBackground(Color("maroon"), for: .navigationBar)
            .toolbarBackground(Color("maroon"), for: .bottomBar)
            .toolbarBackground(.visible, for: .bottomBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .listStyle(.grouped)
            .toolbar {
                ToolbarItem (placement: .bottomBar) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color("gold"))
                    }
                    .buttonStyle(BorderedButtonStyle())
                    
                }
                ToolbarItem (placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward")
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .tint(Color("gold"))
                    
                }
            }
            .padding()
        }
        
        
        .sheet(isPresented: $sheetIsPresented) {
            NavigationStack {
                UploadView(upload: Upload())
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            UserUploadsView()
                .environmentObject(ListViewModel())
        }
    }
}

