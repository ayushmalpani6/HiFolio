//
//  User.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/19/23.
//
    
import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let emailAddress: String
    let linkedIn: String
    
    var intitials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
