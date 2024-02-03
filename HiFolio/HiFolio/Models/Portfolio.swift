//
//  Portfolio.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/27/23.
//

import Foundation

// MARK: - Portfolio Model

class Portfolio: Identifiable, ObservableObject, Codable {
    let id: String
    @Published var education = EducationSection()
    @Published var awards =  AwardsSection()
    @Published var athletics = AthleticsSection()
    @Published var arts = ArtsSection()
    @Published var clubs = ClubsSection()
    @Published var courses = CoursesSection()
    @Published var projects = ProjectsSection()
    @Published var communityService = CommunityServiceSection()
    @Published var workExperience = WorkExperienceSection()
    @Published var sectionSelection = SectionSelection()
    
    init(uid: String) {
        self.id = uid
    }
    
    func getSectionEntries(sectionTitle: String) -> [any PortfolioSectionEntry] {
            switch sectionTitle {
            case "Education":
                return education.entries
            case "Awards":
                return awards.entries
            case "Athletics":
                return athletics.entries
            case "Arts":
                return arts.entries
            case "Clubs & Organizations":
                return clubs.entries
            case "Courses":
                return courses.entries
            case "Projects":
                return projects.entries
            case "Community Service":
                return communityService.entries
            case "Work Experience":
                return workExperience.entries
            default:
                return []
            }
        }
    
    enum CodingKeys: String, CodingKey {
        case id
        case education
        case awards
        case athletics
        case arts
        case clubs
        case courses
        case projects
        case communityService
        case workExperience
        case sectionSelection
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        education = try container.decode(EducationSection.self, forKey: .education)
        awards = try container.decode(AwardsSection.self, forKey: .awards)
        athletics = try container.decode(AthleticsSection.self, forKey: .athletics)
        arts = try container.decode(ArtsSection.self, forKey: .arts)
        clubs = try container.decode(ClubsSection.self, forKey: .clubs)
        courses = try container.decode(CoursesSection.self, forKey: .courses)
        projects = try container.decode(ProjectsSection.self, forKey: .projects)
        communityService = try container.decode(CommunityServiceSection.self, forKey: .communityService)
        workExperience = try container.decode(WorkExperienceSection.self, forKey: .workExperience)
        sectionSelection = try container.decode(SectionSelection.self, forKey: .sectionSelection)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(education, forKey: .education)
        try container.encode(awards, forKey: .awards)
        try container.encode(athletics, forKey: .athletics)
        try container.encode(arts, forKey: .arts)
        try container.encode(clubs, forKey: .clubs)
        try container.encode(courses, forKey: .courses)
        try container.encode(projects, forKey: .projects)
        try container.encode(communityService, forKey: .communityService)
        try container.encode(workExperience, forKey: .workExperience)
        try container.encode(sectionSelection, forKey: .sectionSelection)
    }
}

class SectionTitle: Identifiable, Codable, ObservableObject {
    var title: String
    @Published var checked: Bool
    var id: String { title }
    
    init(title: String, checked: Bool) {
            self.title = title
            self.checked = checked
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case checked
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        checked = try container.decode(Bool.self, forKey: .checked)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(checked, forKey: .checked)
    }
}

struct SectionSelection: Codable {
    var sections: [SectionTitle] = [
        SectionTitle(title: "Education", checked: false),
        SectionTitle(title: "Awards", checked: false),
        SectionTitle(title: "Athletics", checked: false),
        SectionTitle(title: "Arts", checked: false),
        SectionTitle(title: "Clubs & Organizations", checked: false),
        SectionTitle(title: "Courses", checked: false),
        SectionTitle(title: "Projects", checked: false),
        SectionTitle(title: "Community Service", checked: false),
        SectionTitle(title: "Work Experience", checked: false)
    ]
}



// MARK: - Portfolio Sections

protocol PortfolioSections {
    associatedtype sectionEntryType
    var title: String { get }
    var entries: [sectionEntryType] { get }
}

struct EducationSection : PortfolioSections, Codable {
    typealias sectionEntryType = EducationEntry
    var title: String = "Education"
    var entries: [EducationEntry] = []
}

struct AwardsSection : PortfolioSections, Codable {
    typealias sectionEntryType = AwardsEntry
    var title: String = "Awards"
    var entries: [AwardsEntry] = []
}

struct AthleticsSection : PortfolioSections, Codable {
    typealias sectionEntryType = AthleticsEntry
    var title: String = "Athletics"
    var entries: [AthleticsEntry] = []
}

struct ArtsSection : PortfolioSections, Codable {
    typealias sectionEntryType = ArtsEntry
    var title: String = "Arts"
    var entries: [ArtsEntry] = []
}

struct ClubsSection : PortfolioSections, Codable {
    typealias sectionEntryType = ClubsEntry
    var title: String = "Clubs & Organizations"
    var entries: [ClubsEntry] = []
}

struct CoursesSection : PortfolioSections, Codable {
    typealias sectionEntryType = CoursesEntry
    var title: String = "Courses"
    var entries: [CoursesEntry] = []
}

struct ProjectsSection : PortfolioSections, Codable {
    typealias sectionEntryType = ProjectsEntry
    var title: String = "Projects"
    var entries: [ProjectsEntry] = []
}

struct CommunityServiceSection : PortfolioSections, Codable {
    typealias sectionEntryType = CommunityServiceEntry
    var title: String = "Community Service"
    var entries: [CommunityServiceEntry] = []
}

struct WorkExperienceSection  : PortfolioSections, Codable {
    typealias sectionEntryType = WorkExperienceEntry
    var title: String = "Work Experience"
    var entries: [WorkExperienceEntry] = []
}

// MARK: - Portfolio Section Entries

protocol PortfolioSectionEntry: Identifiable {
    var id: UUID { get }
    var title: String { get }
    var date: String { get }
    var description: String { get }
}

struct EducationEntry: PortfolioSectionEntry, Codable {
    var id = UUID()
    var schoolName: String
    var startingDate: Date
    var endingDate: Date? = nil
    var gpa: String
    
    var title: String { schoolName }
    var date: String { "\(dateMonthYear(date: startingDate)) - \(dateMonthYear(date: endingDate))"}
    var description: String {
        "GPA: \(gpa)"
    }
}

struct AwardsEntry: PortfolioSectionEntry, Codable {
    var id = UUID()
    var awardName: String
    var awardDate: Date
    var awardDescription: String
    
    var title: String { awardName }
    var date: String { "\(dateMonthYear(date: awardDate))" }
    var description: String { awardDescription }
}

struct AthleticsEntry: PortfolioSectionEntry, Codable {
    var id = UUID()
    var sportName: String
    var startingDate: Date
    var endingDate: Date? = nil
    var sportDescription: String
    
    var title: String { sportName }
    var date: String { "\(dateMonthYear(date: startingDate)) - \(dateMonthYear(date: endingDate))"}
    var description: String {
        sportDescription
    }
}

struct ArtsEntry: PortfolioSectionEntry, Codable {
    var id = UUID()
    var artName: String
    var startingDate: Date
    var endingDate: Date? = nil
    var artDescription: String
    
    var title: String { artName }
    var date: String { "\(dateMonthYear(date: startingDate)) - \(dateMonthYear(date: endingDate))"}
    var description: String { artDescription }
}

struct ClubsEntry: PortfolioSectionEntry, Codable {
    var id = UUID()
    var clubName: String
    var startingDate: Date
    var endingDate: Date? = nil
    var clubDescription: String
    
    var title: String { clubName }
    var date: String { "\(dateMonthYear(date: startingDate)) - \(dateMonthYear(date: endingDate))"}
    var description: String { clubDescription }
}

struct CoursesEntry: PortfolioSectionEntry, Codable {
    var id = UUID()
    var courseName: String
    var courseTerm: String
    var courseDescription: String
    
    var title: String { courseName }
    var date: String { courseTerm }
    var description: String { courseDescription }
}

struct ProjectsEntry: PortfolioSectionEntry, Codable {
    var id = UUID()
    var projectName: String
    var startingDate: Date
    var endingDate: Date? = nil
    var projectDescription: String
    
    var title: String { projectName }
    var date: String { "\(dateMonthYear(date: startingDate)) - \(dateMonthYear(date: endingDate))"}
    var description: String { projectDescription }
}

struct CommunityServiceEntry: PortfolioSectionEntry, Codable {
    var id = UUID()
    var serviceName: String
    var startingDate: Date
    var endingDate: Date? = nil
    var serviceDescription: String
    
    var title: String { serviceName }
    var date: String { "\(dateMonthYear(date: startingDate)) - \(dateMonthYear(date: endingDate))"}
    var description: String { serviceDescription }
}

struct WorkExperienceEntry: PortfolioSectionEntry, Codable {
    var id = UUID()
    var workplaceName: String
    var startingDate: Date
    var endingDate: Date?
    var workDescription: String
    
    var title: String { workplaceName }
    var date: String { "\(dateMonthYear(date: startingDate)) - \(dateMonthYear(date: endingDate))"}
    var description: String { workDescription }
}

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
