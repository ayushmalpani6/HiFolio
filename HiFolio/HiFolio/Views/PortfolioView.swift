//
//  PortfolioView.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/23/23.
//

import SwiftUI

// Color scheme
let primaryColor = Color(red: 90/255, green: 161/255, blue: 209/255)
let secondaryColor = Color(red: 213/255, green: 229/255, blue: 240/255)

struct SectionTitle: Identifiable {
    var title: String
    var checked: Bool
    var id: String { title }
}

struct PortfolioView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showSetupSheet: Bool = false
    @State var sections: [SectionTitle] = [
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
    
    @State var showAddEducationEntryView: Bool = false
    @State var showAddAwardsEntryView: Bool = false
    @State var showAddAthleticsEntryView: Bool = false
    @State var showAddArtsEntryView: Bool = false
    @State var showAddClubsEntryView: Bool = false
    @State var showAddCoursesEntryView: Bool = false
    @State var showAddProjectsEntryView: Bool = false
    @State var showAddServiceEntryView: Bool = false
    @State var showAddWorkEntryView: Bool = false
    
    
    var body: some View {
        ZStack {
            VStack {
                header
                mainBody
            }
            
            if showAddEducationEntryView {
                AddEducationEntryView(showSheet: $showAddEducationEntryView)
            } else if showAddAwardsEntryView {
                AddAwardsEntryView(showSheet: $showAddAwardsEntryView)
            } else if showAddAthleticsEntryView {
                AddAthleticsEntryView(showSheet: $showAddAthleticsEntryView)
            } else if showAddArtsEntryView {
                AddArtsEntryView(showSheet: $showAddArtsEntryView)
            } else if showAddClubsEntryView {
                AddClubsEntryView(showSheet: $showAddClubsEntryView)
            } else if showAddCoursesEntryView {
                AddCoursesEntryView(showSheet: $showAddCoursesEntryView)
            } else if showAddProjectsEntryView {
                AddProjectsEntryView(showSheet: $showAddProjectsEntryView)
            } else if showAddServiceEntryView {
                AddCommunityServiceEntryView(showSheet: $showAddServiceEntryView)
            } else if showAddWorkEntryView {
                AddWorkEntryView(showSheet: $showAddWorkEntryView)
            }
        }
    }
    
    var header: some View {
        VStack {
            HStack {
                Text("My Folio")
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .foregroundStyle(.black)
                    .frame(width: 150, height: 50)
                    .background(primaryColor)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 20,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 20
                        )
                    )
                    .padding(.horizontal, 10)
                
                Spacer()
                
                Button {
                    showSetupSheet.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                        .foregroundStyle(Color(.black))
                        .padding(.horizontal, 10)
                }
            }
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                VStack (alignment: .leading) {
                    Text("Hi I'm \(viewModel.currentUser?.fullName ?? "")")
                        .font(.system(size: 14))
                        .padding(.bottom, 10)
                    Text(viewModel.currentUser?.emailAddress ?? "")
                        .font(.system(size: 14))
                }
                .padding(.trailing, 20)
                Spacer()
            }
            .background(primaryColor)
            .clipShape(
                .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 20,
                    bottomTrailingRadius: 20,
                    topTrailingRadius: 20
                )
            )
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding(.horizontal, 10)
        }
    }
    
    
    var mainBody: some View {
        ScrollView {
            VStack(alignment: .leading) {
                GroupBox {
                    ForEach(sections) { section in
                        if section.checked {
                            DisclosureGroup {
                                VStack() {
                                    if viewModel.currentUserPortfolio != nil{
                                        ForEach(viewModel.currentUserPortfolio!.getSectionEntries(sectionTitle: section.title), id: \.id) { entry in
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(entry.title)
                                                        .font(.system(size: 18))
                                                    Text(entry.date)
                                                        .font(.system(size: 12))
                                                        .fontWeight(.thin)
                                                        .padding(.bottom, 1)
                                                    Text(entry.description)
                                                        .font(.system(size: 14))
                                                        .fontWeight(.light)
                                                }
                                                Spacer()
                                            }
                                            .padding(10)
                                            .background(secondaryColor)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            
                                        }
                                    }
                                    
                                    Button {
                                        if section.title == "Education" {
                                            showAddEducationEntryView.toggle()
                                        } else if section.title == "Awards" {
                                            showAddAwardsEntryView.toggle()
                                        } else if section.title == "Athletics" {
                                            showAddAthleticsEntryView.toggle()
                                        } else if section.title == "Arts" {
                                            showAddArtsEntryView.toggle()
                                        } else if section.title == "Clubs & Organizations" {
                                            showAddClubsEntryView.toggle()
                                        } else if section.title == "Courses" {
                                            showAddCoursesEntryView.toggle()
                                        } else if section.title == "Projects" {
                                            showAddProjectsEntryView.toggle()
                                        } else if section.title == "Community Service" {
                                            showAddServiceEntryView.toggle()
                                        } else if section.title == "Work Experience" {
                                            showAddWorkEntryView.toggle()
                                        }
                                    } label : {
                                        Text("+ Add Entry")
                                            .fontWeight(.medium)
                                    }
                                }
                                .padding(.top, 5)
                            } label: {
                                Text(section.title)
                                    .font(.title3)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                            .tint(primaryColor)
                        }
                    }
                }
                .backgroundStyle(.white)

                Spacer()
            }
        }
        .sheet(isPresented: $showSetupSheet, content: {
            SetupSheet(sections: $sections)
        })
    }
}

struct SetupSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var sections: [SectionTitle]
    
    let primaryColor = Color(red: 90/255, green: 161/255, blue: 209/255)
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
                    .padding(.vertical, 15)
                    .padding(.trailing, 15)
                    .foregroundColor(primaryColor)
            }
            
            ForEach(sections.indices) { index in
                   Button {
                       sections[index].checked.toggle()
                   } label: {
                       HStack {
                           Text(sections[index].title)
                               .fontWeight(.bold)
                               .font(.system(size: 15))
                               .foregroundStyle(primaryColor)
                               .padding(.horizontal, 20)
                           Spacer()
                           if sections[index].checked == false {
                               Image(systemName: "square")
                                   .foregroundStyle(primaryColor)
                           } else {
                               Image(systemName: "checkmark.square.fill")
                                   .foregroundStyle(primaryColor)
                           }
                       }
                   }
                   .padding(15)
                Divider()
            }
            Spacer()
        }
    }
}


// MARK: - ADD ENTRY VIEWS
struct AddEducationEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var schoolInput: String = ""
    @State var gpaInput: String = ""
    @State var startingDateInput: Date = Date()
    @State var endingDateInput: Date = Date()
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    
    var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        showSheet.toggle()
                    } label : {
                        Label("Cancel", systemImage: "x.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    Spacer()
                }
                Image(systemName: "graduationcap.circle.fill")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.vertical, 30)
                
                InputView(label: "Name of School", placeholder: "Enter your School Name", inputText: $schoolInput)
                    .textInputAutocapitalization(.never)
                
                Toggle("Currently attending this school?", isOn: $attending)
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                
                DatePicker(
                        "Start Date",
                        selection: $startingDateInput,
                        displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
                
                if !attending {
                    DatePicker(
                            "End Date",
                            selection: $endingDateInput,
                            displayedComponents: [.date]
                    )
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                }
                
                InputView(label: "GPA", placeholder: "Enter your GPA", inputText: $gpaInput)
                
                Button {
                    let newEntry: EducationEntry
                    if attending {
                        newEntry = EducationEntry(schoolName: schoolInput, startingDate: startingDateInput, gpa: gpaInput)
                    } else {
                        newEntry = EducationEntry(schoolName: schoolInput, startingDate: startingDateInput, endingDate: endingDateInput, gpa: gpaInput)
                    }
                    
                    viewModel.currentUserPortfolio?.education.entries.append(newEntry)
                    
                    Task {
                        await viewModel.updatePortfolio()
                    }
                    
                    showSheet.toggle()
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                }
                .background(primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
            .background(.white)
        }
}

struct AddAwardsEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var Input: String = ""
    @State var descriptionInput: String = ""
    @State var DateInput: Date = Date()
    @Binding var showSheet: Bool
    
    var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        showSheet.toggle()
                    } label : {
                        Label("Cancel", systemImage: "x.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    Spacer()
                }
                Image(systemName: "trophy.fill")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.vertical, 30)
                
                InputView(label: "Name of Award", placeholder: "Enter your Award's Name", inputText: $Input)
                    .textInputAutocapitalization(.never)
                
                
                DatePicker(
                        "Date of Award",
                        selection: $DateInput,
                        displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
                
                InputView(label: "Description", placeholder: "Enter a description of your award", inputText: $descriptionInput)
                
                Button {
                    let newEntry: AwardsEntry
                    newEntry = AwardsEntry(awardName: Input, awardDate: DateInput, awardDescription: descriptionInput)
                    
                    viewModel.currentUserPortfolio?.awards.entries.append(newEntry)
                    
                    Task {
                        await viewModel.updatePortfolio()
                    }
                    
                    showSheet.toggle()
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                }
                .background(primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
            .background(.white)
        }
}

struct AddAthleticsEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var Input: String = ""
    @State var descriptionInput: String = ""
    @State var startingDateInput: Date = Date()
    @State var endingDateInput: Date = Date()
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    
    var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        showSheet.toggle()
                    } label : {
                        Label("Cancel", systemImage: "x.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    Spacer()
                }
                Image(systemName: "sportscourt.fill")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.vertical, 30)
                
                InputView(label: "Name of Team/Sport", placeholder: "Enter your Team/Sport Name", inputText: $Input)
                    .textInputAutocapitalization(.never)
                
                
                Toggle("Currently a member?", isOn: $attending)
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                
                DatePicker(
                        "Start Date",
                        selection: $startingDateInput,
                        displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
                
                if !attending {
                    DatePicker(
                            "End Date",
                            selection: $endingDateInput,
                            displayedComponents: [.date]
                    )
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                }
                
                InputView(label: "Description", placeholder: "Enter a description of your sport", inputText: $descriptionInput)
                
                Button {
                    let newEntry: AthleticsEntry
                    if attending {
                        newEntry = AthleticsEntry(sportName: Input, startingDate: startingDateInput, sportDescription: descriptionInput)
                    } else {
                        newEntry = AthleticsEntry(sportName: Input, startingDate: startingDateInput, endingDate: endingDateInput, sportDescription: descriptionInput)
                    }
                    
                    viewModel.currentUserPortfolio?.athletics.entries.append(newEntry)
                    
                    Task {
                        await viewModel.updatePortfolio()
                    }
                    
                    showSheet.toggle()
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                }
                .background(primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
            .background(.white)
        }
}

struct AddArtsEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var Input: String = ""
    @State var descriptionInput: String = ""
    @State var startingDateInput: Date = Date()
    @State var endingDateInput: Date = Date()
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    
    var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        showSheet.toggle()
                    } label : {
                        Label("Cancel", systemImage: "x.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    Spacer()
                }
                Image(systemName: "theatermask.and.paintbrush.fill")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.vertical, 30)
                
                InputView(label: "Name of Performing Arts/Art", placeholder: "Enter the Performing Arts/Art name", inputText: $Input)
                    .textInputAutocapitalization(.never)
                
                
                Toggle("Currently a member?", isOn: $attending)
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                
                DatePicker(
                        "Start Date",
                        selection: $startingDateInput,
                        displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
                
                if !attending {
                    DatePicker(
                            "End Date",
                            selection: $endingDateInput,
                            displayedComponents: [.date]
                    )
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                }
                
                InputView(label: "Description", placeholder: "Enter a description of your arts", inputText: $descriptionInput)
                
                Button {
                    let newEntry: ArtsEntry
                    if attending {
                        newEntry = ArtsEntry(artName: Input, startingDate: startingDateInput, artDescription: descriptionInput)
                    } else {
                        newEntry = ArtsEntry(artName: Input, startingDate: startingDateInput, endingDate: endingDateInput, artDescription: descriptionInput)
                    }
                    
                    viewModel.currentUserPortfolio?.arts.entries.append(newEntry)
                    
                    Task {
                        await viewModel.updatePortfolio()
                    }
                    
                    showSheet.toggle()
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                }
                .background(primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
            .background(.white)
        }
}

struct AddClubsEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var Input: String = ""
    @State var descriptionInput: String = ""
    @State var startingDateInput: Date = Date()
    @State var endingDateInput: Date = Date()
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    
    var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        showSheet.toggle()
                    } label : {
                        Label("Cancel", systemImage: "x.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    Spacer()
                }
                Image(systemName: "person.3.fill")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.vertical, 30)
                
                InputView(label: "Name of Club/Organization", placeholder: "Enter your Club/Organization Name", inputText: $Input)
                    .textInputAutocapitalization(.never)
                
                
                Toggle("Currently a member?", isOn: $attending)
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                
                DatePicker(
                        "Start Date",
                        selection: $startingDateInput,
                        displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
                
                if !attending {
                    DatePicker(
                            "End Date",
                            selection: $endingDateInput,
                            displayedComponents: [.date]
                    )
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                }
                
                InputView(label: "Description", placeholder: "Enter a description of your arts", inputText: $descriptionInput)
                
                Button {
                    let newEntry: ClubsEntry
                    if attending {
                        newEntry = ClubsEntry(clubName: Input, startingDate: startingDateInput, clubDescription: descriptionInput)
                    } else {
                        newEntry = ClubsEntry(clubName: Input, startingDate: startingDateInput, endingDate: endingDateInput, clubDescription: descriptionInput)
                    }
                    
                    viewModel.currentUserPortfolio?.clubs.entries.append(newEntry)
                    
                    Task {
                        await viewModel.updatePortfolio()
                    }
                    
                    showSheet.toggle()
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                }
                .background(primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
            .background(.white)
        }
}


struct AddCoursesEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var Input: String = ""
    @State var descriptionInput: String = ""
    @State var term: String = ""
    @Binding var showSheet: Bool
    
    var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        showSheet.toggle()
                    } label : {
                        Label("Cancel", systemImage: "x.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    Spacer()
                }
                Image(systemName: "book.closed.circle.fill")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.vertical, 30)
                
                InputView(label: "Name of Course", placeholder: "Enter your Course Name", inputText: $Input)
                    .textInputAutocapitalization(.never)
                
                InputView(label: "Term of Course", placeholder: "Ex. Semester 1, Sophmore Year", inputText: $term)
                
                InputView(label: "Description", placeholder: "Enter a description of your arts", inputText: $descriptionInput)
                
                Button {
                    let newEntry: CoursesEntry
                    newEntry = CoursesEntry(courseName: Input, courseTerm: term, courseDescription: descriptionInput)
                    
                    viewModel.currentUserPortfolio?.courses.entries.append(newEntry)
                    
                    Task {
                        await viewModel.updatePortfolio()
                    }
                    
                    showSheet.toggle()
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                }
                .background(primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
            .background(.white)
        }
}

struct AddProjectsEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var Input: String = ""
    @State var descriptionInput: String = ""
    @State var startingDateInput: Date = Date()
    @State var endingDateInput: Date = Date()
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    
    var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        showSheet.toggle()
                    } label : {
                        Label("Cancel", systemImage: "x.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    Spacer()
                }
                Image(systemName: "square.stack.3d.up")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.vertical, 30)
                
                InputView(label: "Name of Project", placeholder: "Enter your Project Name", inputText: $Input)
                    .textInputAutocapitalization(.never)
                
                
                Toggle("Currently a working on the project?", isOn: $attending)
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                
                DatePicker(
                        "Start Date",
                        selection: $startingDateInput,
                        displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
                
                if !attending {
                    DatePicker(
                            "Date of Completion",
                            selection: $endingDateInput,
                            displayedComponents: [.date]
                    )
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                }
                
                InputView(label: "Description", placeholder: "Enter a description of your project", inputText: $descriptionInput)
                
                Button {
                    let newEntry: ProjectsEntry
                    if attending {
                        newEntry = ProjectsEntry(projectName: Input, startingDate: startingDateInput, projectDescription: descriptionInput)
                    } else {
                        newEntry = ProjectsEntry(projectName: Input, startingDate: startingDateInput, endingDate: endingDateInput, projectDescription: descriptionInput)
                    }
                    
                    viewModel.currentUserPortfolio?.projects.entries.append(newEntry)
                    
                    Task {
                        await viewModel.updatePortfolio()
                    }
                    
                    showSheet.toggle()
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                }
                .background(primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
            .background(.white)
        }
}

struct AddCommunityServiceEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var Input: String = ""
    @State var descriptionInput: String = ""
    @State var startingDateInput: Date = Date()
    @State var endingDateInput: Date = Date()
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    
    var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        showSheet.toggle()
                    } label : {
                        Label("Cancel", systemImage: "x.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    Spacer()
                }
                Image(systemName: "network")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.vertical, 30)
                
                InputView(label: "Name of Community Service", placeholder: "Enter the name of the community service", inputText: $Input)
                    .textInputAutocapitalization(.never)
                
                
                Toggle("Ongoing Event?", isOn: $attending)
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                
                DatePicker(
                        "Start Date",
                        selection: $startingDateInput,
                        displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
                
                if !attending {
                    DatePicker(
                            "End Date",
                            selection: $endingDateInput,
                            displayedComponents: [.date]
                    )
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                }
                
                InputView(label: "Description", placeholder: "Enter a description of your community service", inputText: $descriptionInput)
                
                Button {
                    let newEntry: CommunityServiceEntry
                    if attending {
                        newEntry = CommunityServiceEntry(serviceName: Input, startingDate: startingDateInput, serviceDescription: descriptionInput)
                    } else {
                        newEntry = CommunityServiceEntry(serviceName: Input, startingDate: startingDateInput, endingDate: endingDateInput, serviceDescription: descriptionInput)
                    }
                    
                    viewModel.currentUserPortfolio?.communityService.entries.append(newEntry)
                    
                    Task {
                        await viewModel.updatePortfolio()
                    }
                    
                    showSheet.toggle()
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                }
                .background(primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
            .background(.white)
        }
}

struct AddWorkEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var Input: String = ""
    @State var descriptionInput: String = ""
    @State var startingDateInput: Date = Date()
    @State var endingDateInput: Date = Date()
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    
    var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        showSheet.toggle()
                    } label : {
                        Label("Cancel", systemImage: "x.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    Spacer()
                }
                Image(systemName: "theatermask.and.paintbrush.fill")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.vertical, 30)
                
                InputView(label: "Name of Workplace", placeholder: "Enter the workplace name", inputText: $Input)
                    .textInputAutocapitalization(.never)
                
                
                Toggle("Currently an employee?", isOn: $attending)
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                
                DatePicker(
                        "Start Date",
                        selection: $startingDateInput,
                        displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
                
                if !attending {
                    DatePicker(
                            "End Date",
                            selection: $endingDateInput,
                            displayedComponents: [.date]
                    )
                    .padding(.horizontal, 30)
                    .foregroundStyle(primaryColor)
                }
                
                InputView(label: "Description", placeholder: "Enter a description of your job", inputText: $descriptionInput)
                
                Button {
                    let newEntry: WorkExperienceEntry
                    if attending {
                        newEntry = WorkExperienceEntry(workplaceName: Input, startingDate: startingDateInput, workDescription: descriptionInput)
                    } else {
                        newEntry = WorkExperienceEntry(workplaceName: Input, startingDate: startingDateInput, endingDate: endingDateInput, workDescription: descriptionInput)
                    }
                    
                    viewModel.currentUserPortfolio?.workExperience.entries.append(newEntry)
                    
                    Task {
                        await viewModel.updatePortfolio()
                    }
                    
                    showSheet.toggle()
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                }
                .background(primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
            .background(.white)
        }
}
