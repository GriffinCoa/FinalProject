//
//  FinalProjectApp.swift
//  FinalProject
//
//  Created by Griffin Coates on 12/6/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ListOfStudentsApp: App {
    @StateObject var listVM = ListViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(listVM)
        }
    }
}
