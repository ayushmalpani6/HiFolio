//
//  AuthViewModel.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/19/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var currentUserPortfolio: Portfolio?
    var defaultImage: UIImage = UIImage(systemName: "person")!
    @Published var avatarImage: UIImage?
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
            if userSession != nil {
                retrievePhoto()
            }
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            retrievePhoto()
        } catch {
            print("DEBUG: FAILED TO SIGN IN \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String, linkedIn: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, emailAddress: email, linkedIn: linkedIn, profilePicture: "Images/\(result.user.uid).jpeg")
            let storageRef = Storage.storage().reference()
            let imageData = defaultImage.jpegData(compressionQuality: 0.8)
            guard imageData != nil else {
                return
            }
            let fileRef = storageRef.child("Images/\(result.user.uid).jpeg")
            let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
                if error != nil && metadata != nil{
                    
                }
            }
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            let portfolio = Portfolio(uid: result.user.uid)
            let encodedPortfolio = try Firestore.Encoder().encode(portfolio)
            try await Firestore.firestore().collection("portfolios").document(user.id).setData(encodedPortfolio)
            await fetchUser()
            retrievePhoto()
        } catch {
            print("DEBUG: FAILED TO CREATE USER \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: FAILED TO SIGN OUT \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        print("DELETING")
        let user = Auth.auth().currentUser
        user?.delete() { error in
            if let error = error {
                print("DEBUG: FAILED TO DELETE \(error.localizedDescription)")
            } else {
                print("DELETED")
                self.userSession = nil
                self.currentUser = nil
            }
        }
    }
    
    func deleteData() {
        if let user = currentUser {
            let userDocument = Firestore
                .firestore()
                .collection("users")
                .document(user.id)
            let portfolioDocument = Firestore
                .firestore()
                .collection("portfolios")
                .document(user.id)
            userDocument.delete { error in
                if let error = error {
                    print("DEBUG: FAILED TO DELETE USER DATA \(error.localizedDescription)")
                } else {
                    print("User Data Deleted")
                }
            }
            portfolioDocument.delete { error in
                if let error = error {
                    print("DEBUG: FAILED TO DELETE PORTFOLIO DATA \(error.localizedDescription)")
                } else {
                    print("Portfolio Data Deleted")
                }
            }
        }
        
    }
    
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        guard let portfolioSnapshot = try? await Firestore.firestore().collection("portfolios").document(uid).getDocument() else { return }
        self.currentUserPortfolio = try? portfolioSnapshot.data(as: Portfolio.self)
    }
    
    func updatePortfolio() async {
        if let user = currentUser {
            let portfolioDocument = Firestore
                .firestore()
                .collection("portfolios")
                .document(user.id)
            do {
                try portfolioDocument.setData(from: currentUserPortfolio)
                await fetchUser()
            } catch {
                print("DEBUG: Failed to save Portfolio \(error.localizedDescription)")
            }
        }
    }
    
    func retrievePhoto() {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(currentUser!.profilePicture)
        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error == nil && data != nil{
                self.avatarImage = UIImage(data: data!)!
            }
        }
    }
    
}
