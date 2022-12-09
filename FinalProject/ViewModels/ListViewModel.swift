//
//  ListViewModel.swift
//  FinalProject
//
//  Created by Griffin Coates on 12/6/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import UIKit

class ListViewModel: ObservableObject {
    @Published var upload = Upload()
    @Published private var showingAlert = false
    
    func saveUpload(upload: Upload) async -> Bool {
        
        let db = Firestore.firestore()
        
        if let id = upload.id { // we have a current student, so update existing doc
            do {
                let _ = try await db.collection("uploads").document(id).setData(upload.dictionary)
                showingAlert = true
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in students \(error.localizedDescription)")
                return false
            }
        } else { // we must have a new student, so add the doc, Firestore will create the id
            do {
                let _ = try await db.collection("uploads").addDocument(data: upload.dictionary)
                showingAlert = true
                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in students \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func saveImage(id: String, image: UIImage) async {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpeg")
        
        let resizedImage = image.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        if let resizedImage = resizedImage {
            do {
                let result = try await storageRef.putDataAsync(resizedImage)
                
                print("Metadata = \(result)")
                print("📸 Image Saved!")
            } catch {
                print("😡 ERROR: uploading image to FirebaseStorage \(error.localizedDescription)")
            }
        }
    }
    
    func getImageURL(id: String) async -> URL? {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpeg")
        
        do {
            let url = try await storageRef.downloadURL()
            return url
        } catch {
            print("😡 ERROR: Could not get a downloadURL")
            return nil
        }
    }
    
    func deleteUpload(upload: Upload) async {
        let db = Firestore.firestore()
        guard let id = upload.id else {
            print("😡 ERROR: Could not delete document \(upload.id ?? "No ID!")")
            return
        }
        do {
            let _ = try await db.collection("uploads").document(id).delete()
            print("🗑 Document successfully removed!")
        } catch {
            print("😡 ERROR: removing document \(error.localizedDescription)")
        }
    }
}
