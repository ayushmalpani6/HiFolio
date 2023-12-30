//
//  Portfolio.swift
//  HiFolio
//
//  Created by Jugal Malpani on 12/27/23.
//

import Foundation

class Portfolio: Identifiable, ObservableObject, Codable {
    let id: String
    @Published var education = EducationSection()
    @Published var awards =  AwardsSection()
    
    init(uid: String) {
        self.id = uid
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case education
        case awards
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        education = try container.decode(EducationSection.self, forKey: .education)
        awards = try container.decode(AwardsSection.self, forKey: .awards)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(education, forKey: .education)
        try container.encode(awards, forKey: .awards)
    }
    
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

protocol PortfolioSectionEntry: Identifiable {
    var id: UUID { get }
    var title: String { get }
    var date: String { get }
}

struct EducationEntry: PortfolioSectionEntry, Codable {
    var id = UUID()
    var schoolName: String
    var startingDate: Date
    var endingDate: Date?
    var gpa: String
    
    var title: String { schoolName }
    var date: String { 
        "\(dateMonthYear(date: startingDate)) - \(dateMonthYear(date: endingDate ?? nil))"
    }
}

struct AwardsEntry: PortfolioSectionEntry, Codable {
    var id = UUID()
    var awardName: String
    var awardDate: Date
    var description: String
    
    var title: String { awardName }
    var date: String {
        "\(dateMonthYear(date: awardDate))"
    }
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

func dateMonthYear(date: Date?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM yyyy"
    
    if let date = date {
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    } else {
        return "Present"
    }
}
