//
//  ExistingUploadView.swift
//  FinalProject
//
//  Created by Griffin Coates on 12/8/22.
//

import SwiftUI
import FirebaseStorage

struct ExistingUploadView: View {
    @Environment(\.dismiss) private var dismiss
    @State var upload: Upload
    @EnvironmentObject var listVM: ListViewModel
    @State var imageURL: URL?
    var body: some View {
        VStack() {
            Text(upload.name.capitalized)
                .font(Font.custom("Avenir Next Condensed", size: 50))
                .foregroundColor(Color("maroon"))
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(2)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("maroon"))
                .padding(.bottom)
            VStack (alignment: .leading) {
                if imageURL != nil {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .background(.white)
                            .frame(maxHeight: 300)
                            .cornerRadius(16)
                            .shadow(radius: 8,x: 5,y: 5)
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                            }
//                            .padding(.trailing)
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .background(.white)
                            .frame(maxHeight: 300)
                            .cornerRadius(16)
                            .shadow(radius: 8,x: 5,y: 5)
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                            }
                            .padding(.trailing)
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .background(.white)
                        .frame(maxHeight: 300)
                        .cornerRadius(16)
                        .shadow(radius: 8,x: 5,y: 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                        }
                        .padding(.trailing)
                }
                Section(header: Text("")) {
                    VStack (alignment: .leading) {
                        Text("Course Name:")
                            .font(.largeTitle)
                            .bold()
                            .lineLimit(1)
                        Text("\(upload.courseName)")
                            .font(.title)
                            .lineLimit(2)
                    }
                    .minimumScaleFactor(0.5)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                                         
                    HStack {
                        Text("Price:")
                            .font(.largeTitle)
                            .bold()
                        Text("$\(upload.price)")
                            .font(.title)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                                        
                    HStack {
                        Text("ISBN:")
                            .font(.largeTitle)
                            .bold()
                        Text("\(upload.isbn)")
                            .font(.title)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                                        
                    HStack {
                        Text("Condition:")
                            .font(.largeTitle)
                            .bold()
                        Text("\(upload.condition.capitalized)")
                            .font(.title)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                                        
                    VStack (alignment: .leading) {
                        Text("Contact Email:")
                            .font(.largeTitle)
                            .bold()
                        Text("\(upload.email)")
                            .font(.title)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                    
                }
                .padding(2.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .foregroundColor(Color("maroon"))
                        }
                        .buttonStyle(BorderedButtonStyle())
                    }
                }
                .navigationBarBackButtonHidden()
                .navigationBarTitleDisplayMode(.inline)
                
                Spacer()
            }
            }
            .padding()
            .background(Color("gold"))
            .task {
                if let id = upload.id {
                    if let url = await listVM.getImageURL(id: id) {
                        imageURL = url
                    }
                }
            }
        }
}

struct ExistingUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ExistingUploadView(upload: Upload(name: "Marketing, Vol.1",isbn: "9897827", courseName: "Principles of Marketing" , price: "100", email: "coatesg@bc.edu"))
            .environmentObject(ListViewModel())
    }
}
