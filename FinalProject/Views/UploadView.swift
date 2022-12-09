//
//  UploadView.swift
//  FinalProject
//
//  Created by Griffin Coates on 12/6/22.
//

import SwiftUI
import PhotosUI
import Firebase
import UIKit
import FirebaseAuth
import FirebaseAuthInterop


struct UploadView: View {
    enum Field {
        case email, name, isbn, courseName, price
    }
    @Environment(\.dismiss) private var dismiss
    @State var upload: Upload
    @EnvironmentObject var listVM: ListViewModel
    @State private var selectedImage: Image = Image(systemName: "photo")
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageURL: URL?
    @FocusState private var focusField: Field?
    
    var body: some View {
        VStack {
            Spacer()
            Section(header: Text("New Upload:").font(.title).bold()) {
                TextField("Enter Contact Email for Purchase", text: $upload.email)
                    .fontWeight(.medium)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email) // this field is bound to the .email case
                    .onSubmit {
                        focusField = .name
                    }
                TextField("Enter Textbook Title", text: $upload.name)
                    .fontWeight(.medium)
                    .submitLabel(.next)
                    .focused($focusField, equals: .name) // this field is bound to the .email case
                    .onSubmit {
                        focusField = .isbn
                    }
                TextField("Enter ISBN", text: $upload.isbn)
                    .fontWeight(.medium)
                    .submitLabel(.next)
                    .focused($focusField, equals: .isbn) // this field is bound to the .email case
                    .onSubmit {
                        focusField = .courseName
                    }
                TextField("Enter Course Name", text: $upload.courseName)
                    .fontWeight(.medium)
                    .submitLabel(.next)
                    .focused($focusField, equals: .courseName) // this field is bound to the .email case
                    .onSubmit {
                        focusField = .price
                    }
                TextField("Listing Price", text: $upload.price)
                    .fontWeight(.medium)
                    .keyboardType(.numbersAndPunctuation)
                    .submitLabel(.done)
                    .focused($focusField, equals: .price) // this field is bound to the .email case
                    .onSubmit {
                        focusField = nil
                    }
                Picker("", selection: $upload.condition) {
                    ForEach(Condition.allCases, id: \.self) { condition in
                        Text(condition.rawValue.capitalized)
                            .tag(condition.rawValue)
                    }
                }
                .tint(Color("gold"))
                .fontWeight(.medium)
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                HStack {
                    Text("Upload Image of Product Cover")
                        .bold()
                    Spacer()
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Label("", systemImage: "photo.fill.on.rectangle.fill")
                    }
                    .onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        selectedImage = Image(uiImage: uiImage)
                                        imageURL = nil
                                    }
                                }
                            } catch {
                                print("ERROR: loading failed \(error.localizedDescription)")
                            }
                        }
                    }
                }
                if imageURL != nil {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    }
                } else {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                }
                
                Spacer()
            }
            
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading)
            .padding(.trailing)
        }
        .task {
            if let id = upload.id {
                if let url = await listVM.getImageURL(id: id) {
                    imageURL = url
                }
            }
        }
        .background(Color("gold"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(Color("maroon"))
                }
                .buttonStyle(BorderedButtonStyle())
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    upload.userID = Auth.auth().currentUser!.email ?? ""
                    Task {
                        let success = await listVM.saveUpload(upload: upload)
                        if success {
                            if let id = upload.id {
                                let uiImage = ImageRenderer(content: selectedImage).uiImage ?? UIImage()
                                
                                await listVM.saveImage(id: id, image: uiImage)
                            }
                            dismiss()
                        } else {
                            print("😡 DANG! Could not save the student!")
                        }
                    }
                    
                }label: {
                    Text("Upload Data")
                        .foregroundColor(Color("maroon"))
                }
                .buttonStyle(BorderedButtonStyle())
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    struct UploadView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                UploadView(upload: Upload())
                    .environmentObject(ListViewModel())
            }
        }
    }
}
