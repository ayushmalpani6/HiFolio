//
//  Portfolio.swift
//  HiFolio
//
//  Created by Jugal Malpani on 12/27/23.
//

import Foundation

struct Portfolio: Identifiable, Codable {
    let id = UUID()
    var education: EducationSection
    var awards: AwardsSection
//    var athletics: AthleticsSection
//    var arts: ArtsSection
//    var clubs: ClubsSection
//    var courses: CoursesSection
//    var projects: ProjectsSection
//    var communityService: CommunityServiceSection
//    var workExperience: WorkExperienceSections
}

protocol PortfolioSections {
    var title: String { get }
}

struct EducationSection : PortfolioSections, Codable {
    var title: String = "Education"
    var entries: [EducationEntry] = []
}

struct AwardsSection : PortfolioSections, Codable {
    var title: String = "Awards"
    var entries: [AwardsEntry] = []
}

struct EducationEntry: Codable {
    var school: String
    var startingDate: Date
    var endingDate: Date?
    var gpa: Double
}

struct AwardsEntry: Codable {
    var awardName: String
    var awardDate: Date
    var description: String
}
//struct AthleticsSection : PortfolioSections {
//    var title: String = "Athletics"
//    var entries: [AthleticsEntry] = []
//}
//
//struct ArtsSection : PortfolioSections {
//    var title: String = "Arts"
//    var entries: [ArtsEntry] = []
//}
//
//struct ClubsSection : PortfolioSections {
//    var title: String = "Clubs & Organizations"
//    var entries: [ClubsEntry] = []
//}
//
//struct CoursesSection : PortfolioSections {
//    var title: String = "Courses"
//    var entries: [CoursesEntry] = []
//}
//
//struct ProjectsSection : PortfolioSections {
//    var title: String = "Projects"
//    var entries: [ProjectsEntry] = []
//}
//
//struct CommunityServiceSection : PortfolioSections {
//    var title: String = "Community Service"
//    var entries: [CommunityServiceEntry] = []
//}
//
//struct WorkExperienceSections : PortfolioSections {
//    var title: String = "Work Experience"
//    var entries: [WorkExperienceEntry] = []
//}

