//
//  PortfolioView.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/23/23.
//

import SwiftUI
import FirebaseStorage

// Color scheme
let primaryColor = Color(red: 90/255, green: 161/255, blue: 209/255)
let secondaryColor = Color(red: 213/255, green: 229/255, blue: 240/255)
let destructiveColor = Color(red: 255/255, green: 77/255, blue: 77/255)

struct PortfolioView: View {
    @Environment (\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showSetupSheet: Bool = false
    //    @State var sections: [SectionTitle] = [
    //        SectionTitle(title: "Education", checked: false),
    //        SectionTitle(title: "Awards", checked: false),
    //        SectionTitle(title: "Athletics", checked: false),
    //        SectionTitle(title: "Arts", checked: false),
    //        SectionTitle(title: "Clubs & Organizations", checked: false),
    //        SectionTitle(title: "Courses", checked: false),
    //        SectionTitle(title: "Projects", checked: false),
    //        SectionTitle(title: "Community Service", checked: false),
    //        SectionTitle(title: "Work Experience", checked: false)
    //    ]
    
    @State var showAddEntryView: Bool = false
    @State var editMode: Bool = true
    @State var section: SectionTitle?
    @State var sectionEntry: (any PortfolioSectionEntry)?
    @State var addEdit: Bool = false
    @State var avatarImage: UIImage?
    
    var body: some View {
        ZStack {
            VStack {
                header
                mainBody
            }
            
            if showAddEntryView {
                VStack {
                    if section != nil {
                        if section!.title == "Education" {
                            AddEducationEntryView(entry: (sectionEntry as! EducationEntry), showSheet: $showAddEntryView, addOrEdit: $addEdit)
                        } else if section!.title == "Awards" {
                            AddAwardsEntryView(entry: (sectionEntry as! AwardsEntry), showSheet: $showAddEntryView, addOrEdit: $addEdit)
                        } else if section!.title == "Athletics" {
                            AddAthleticsEntryView(entry: (sectionEntry as! AthleticsEntry), showSheet: $showAddEntryView, addOrEdit: $addEdit)
                        } else if section!.title == "Arts" {
                            AddArtsEntryView(entry: (sectionEntry as! ArtsEntry), showSheet: $showAddEntryView, addOrEdit: $addEdit)
                        } else if section!.title == "Clubs & Organizations" {
                            AddClubsEntryView(entry: (sectionEntry as! ClubsEntry), showSheet: $showAddEntryView, addOrEdit: $addEdit)
                        } else if section!.title == "Courses" {
                            AddCoursesEntryView(entry: (sectionEntry as! CoursesEntry), showSheet: $showAddEntryView, addOrEdit: $addEdit)
                        } else if section!.title == "Projects" {
                            AddProjectsEntryView(entry: (sectionEntry as! ProjectsEntry), showSheet: $showAddEntryView, addOrEdit: $addEdit)
                        } else if section!.title == "Community Service" {
                            AddCommunityServiceEntryView(entry: (sectionEntry as! CommunityServiceEntry), showSheet: $showAddEntryView, addOrEdit: $addEdit)
                        } else if section!.title == "Work Experience" {
                            AddWorkEntryView(entry: (sectionEntry as! WorkExperienceEntry), showSheet: $showAddEntryView, addOrEdit: $addEdit)
                        }
                    }
                }
                .background(colorScheme == .light ? .white : .black)
                .scaleEffect(showAddEntryView ? 1 : 0.5)
                .opacity(showAddEntryView ? 1 : 0)
                
                
            }
        }
    }
    
    var header: some View {
        HStack {
            Text("My Folio")
                .fontWeight(.bold)
                .font(.system(size: 25))
                .foregroundStyle(secondaryColor)
                .frame(width: 150, height: 50)
                .background(primaryColor)
                .clipShape(
                    .rect(
                        topLeadingRadius: 10,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 10,
                        topTrailingRadius: 10
                    )
                )
                .padding(.horizontal, 10)
            
            Spacer()
            
            Button {
                showSetupSheet.toggle()
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .foregroundStyle(primaryColor)
                    .padding(.horizontal, 10)
            }
        }
    }
    
    
    var mainBody: some View {
        ScrollView {
            HStack {
                if viewModel.avatarImage != nil {
                    Image(uiImage: viewModel.avatarImage!)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(15)
                        .padding(20)
                } else {
                    Image(uiImage: viewModel.defaultImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(15)
                        .padding(20)
                }
                VStack (alignment: .leading) {
                    Text(viewModel.currentUser?.fullName ?? "")
                        .font(.system(size: 14))
                        .padding(.bottom, 6)
                        .foregroundStyle(.white)
                    Text(viewModel.currentUser?.emailAddress ?? "")
                        .font(.system(size: 14))
                        .padding(.bottom, 6)
                        .foregroundStyle(.white)
                    if viewModel.currentUser?.linkedIn != nil && viewModel.currentUser?.linkedIn != "" {
                        Link("LinkedIn", destination: URL(string: viewModel.currentUser?.linkedIn ?? "")!)
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.trailing, 20)
                .foregroundColor(secondaryColor)
                Spacer()
            }
            .background(primaryColor)
            .clipShape(
                .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 10,
                    bottomTrailingRadius: 10,
                    topTrailingRadius: 10
                )
            )
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding(.horizontal, 10)
            
            VStack(alignment: .leading) {
                if viewModel.currentUserPortfolio?.sectionSelection.sections != nil {
                    GroupBox {
                        
                        ForEach((viewModel.currentUserPortfolio?.sectionSelection.sections)!) { section in
                            if section.checked {
                                DisclosureGroup {
                                    VStack {
                                        if viewModel.currentUserPortfolio != nil {
                                            ForEach(viewModel.currentUserPortfolio!.getSectionEntries(sectionTitle: section.title), id: \.id) { entry in
                                                Button {
                                                    if editMode {
                                                        self.section = section
                                                        self.sectionEntry = entry
                                                        addEdit = false
                                                        self.showAddEntryView.toggle()
                                                    }
                                                } label: {
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
                                                    .foregroundStyle(.black)
                                                    .background(secondaryColor)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                }
                                            }
                                        }
                                        
                                        if editMode {
                                            Button {
                                                self.section = section
                                                if section.title == "Education" {
                                                    self.sectionEntry = EducationEntry(schoolName: "", startingDate: Date(), gpa: "")
                                                } else if section.title == "Awards" {
                                                    self.sectionEntry = AwardsEntry(awardName: "", awardDate: Date(), awardDescription: "")
                                                } else if section.title == "Athletics" {
                                                    self.sectionEntry = AthleticsEntry(sportName: "", startingDate: Date(), sportDescription: "")
                                                } else if section.title == "Arts" {
                                                    self.sectionEntry = ArtsEntry(artName: "", startingDate: Date(), artDescription: "")
                                                } else if section.title == "Clubs & Organizations" {
                                                    self.sectionEntry = ClubsEntry(clubName: "", startingDate: Date(), clubDescription: "")
                                                } else if section.title == "Courses" {
                                                    self.sectionEntry = CoursesEntry(courseName: "", courseTerm: "", courseDescription: "")
                                                } else if section.title == "Projects" {
                                                    self.sectionEntry = ProjectsEntry(projectName: "", startingDate: Date(), projectDescription: "")
                                                } else if section.title == "Community Service" {
                                                    self.sectionEntry = CommunityServiceEntry(serviceName: "", startingDate: Date(), serviceDescription: "")
                                                } else if section.title == "Work Experience" {
                                                    self.sectionEntry = WorkExperienceEntry(workplaceName: "", startingDate: Date(), workDescription: "")
                                                }
                                                addEdit = true
                                                showAddEntryView.toggle()
                                            } label : {
                                                Text("+ Add Entry")
                                                    .fontWeight(.medium)
                                            }
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
                    .backgroundStyle(colorScheme == .light ? .white : .black)
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showSetupSheet, content: {
            SetupSheet(editMode: $editMode)
        })
    }
}

struct SetupSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var editMode: Bool
    
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
            HStack {
                Spacer()
                Toggle("Edit Mode", isOn: $editMode)
                    .padding(15)
                    .foregroundColor(primaryColor)
                    .fontWeight(.medium)
                    .frame(width: 200)
                    .font(.system(size: 18))
                Spacer()
            }
            
            if editMode {
                ForEach(viewModel.currentUserPortfolio!.sectionSelection.sections.indices) { index in
                    Button {
                        viewModel.currentUserPortfolio?.sectionSelection.sections[index].checked.toggle()
                        
                        Task{
                            await viewModel.updatePortfolio()
                        }
                    } label: {
                        HStack {
                            Text(viewModel.currentUserPortfolio?.sectionSelection.sections[index].title ?? "")
                                .fontWeight(.regular)
                                .font(.system(size: 16))
                                .foregroundStyle(primaryColor)
                                .padding(.horizontal, 20)
                            Spacer()
                            Image(systemName: viewModel.currentUserPortfolio?.sectionSelection.sections[index].checked ?? false ? "checkmark.square.fill" : "square")
                                .foregroundStyle(primaryColor)
                        }
                    }
                    .padding(15)
                    Divider()
                    
                }
            } else {
                Text("You are currently in Showcase Mode - use this mode if your are showing off your portfolio! If you would like to make any changes, switch to edit mode.")
                    .padding(20)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(primaryColor)
                    .background(secondaryColor)
                    .padding(20)
            }
            Spacer()
        }
    }
}


// MARK: - ADD ENTRY VIEWS

struct AddEducationEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var entry: EducationEntry
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    @Binding var addOrEdit: Bool
    @State private var isPresentingConfirm: Bool = false
    
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
            
            InputView(label: "Name of School", placeholder: "Enter your School Name", inputText: $entry.schoolName)
            
            Toggle("Currently attending this school?", isOn: $attending)
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            
            DatePicker(
                "Start Date",
                selection: $entry.startingDate,
                displayedComponents: [.date]
            )
            .padding(.horizontal, 30)
            .foregroundStyle(primaryColor)
            
            if !attending {
                DatePicker(
                    "End Date",
                    selection: Binding(get: {entry.endingDate ?? Date()}, set: {entry.endingDate = $0}),
                    displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            }
            
            InputView(label: "GPA", placeholder: "Enter your GPA", inputText: $entry.gpa)
            
            Button {
                if addOrEdit{
                    viewModel.currentUserPortfolio?.education.entries.append(entry)
                } else {
                    if let identifier = viewModel.currentUserPortfolio?.education.entries.firstIndex(where: {$0.id == entry.id}) {
                        viewModel.currentUserPortfolio?.education.entries[identifier] = entry
                    }
                }
                Task {
                    await viewModel.updatePortfolio()
                }
                showSheet.toggle()
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
            }
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.horizontal, 20)
            .padding(.top, 20)
            if !addOrEdit {
                Button{
                    isPresentingConfirm = true
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(destructiveColor)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .confirmationDialog("Are you sure you want to delete this entry?", isPresented: $isPresentingConfirm) {
                    Button("Confirm Delete", role: .destructive) {
                        if let identifier = viewModel.currentUserPortfolio?.education.entries.firstIndex(where: {$0.id == entry.id}) {
                            viewModel.currentUserPortfolio?.education.entries.remove(at: identifier)
                        }
                        Task {
                            await viewModel.updatePortfolio()
                        }
                        showSheet.toggle()
                    }
                }
            }
            Spacer()
        }
    }
}

struct AddAwardsEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var entry: AwardsEntry
    @Binding var showSheet: Bool
    @Binding var addOrEdit: Bool
    @State private var isPresentingConfirm: Bool = false
    
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
            
            InputView(label: "Name of Award", placeholder: "Enter your Award Name", inputText: $entry.awardName)
            
            DatePicker(
                "Date",
                selection: $entry.awardDate,
                displayedComponents: [.date]
            )
            .padding(.horizontal, 30)
            .foregroundStyle(primaryColor)
            
            InputView(label: "Description", placeholder: "Enter a description of your Award", inputText: $entry.awardDescription)
            
            Button {
                if addOrEdit{
                    viewModel.currentUserPortfolio?.awards.entries.append(entry)
                } else {
                    if let identifier = viewModel.currentUserPortfolio?.awards.entries.firstIndex(where: {$0.id == entry.id}) {
                        viewModel.currentUserPortfolio?.awards.entries[identifier] = entry
                    }
                }
                Task {
                    await viewModel.updatePortfolio()
                }
                showSheet.toggle()
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
            }
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.horizontal, 20)
            .padding(.top, 20)
            if !addOrEdit {
                Button{
                    isPresentingConfirm = true
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(destructiveColor)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                    Button("Delete your Entry?", role: .destructive) {
                        if let identifier = viewModel.currentUserPortfolio?.awards.entries.firstIndex(where: {$0.id == entry.id}) {
                            viewModel.currentUserPortfolio?.awards.entries.remove(at: identifier)
                        }
                        Task {
                            await viewModel.updatePortfolio()
                        }
                        showSheet.toggle()
                    }
                }
            }
            Spacer()
        }
    }
}

struct AddAthleticsEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var entry: AthleticsEntry
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    @Binding var addOrEdit: Bool
    @State private var isPresentingConfirm: Bool = false
    
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
                .frame(width: 150, height: 100)
                .padding(.vertical, 30)
            
            InputView(label: "Name of Sport", placeholder: "Enter your Sport Name", inputText: $entry.sportName)
            
            Toggle("Currently participating?", isOn: $attending)
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            
            DatePicker(
                "Start Date",
                selection: $entry.startingDate,
                displayedComponents: [.date]
            )
            .padding(.horizontal, 30)
            .foregroundStyle(primaryColor)
            
            if !attending {
                DatePicker(
                    "End Date",
                    selection: Binding(get: {entry.endingDate ?? Date()}, set: {entry.endingDate = $0}),
                    displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            }
            
            InputView(label: "Description", placeholder: "Enter a Description", inputText: $entry.sportDescription)
            
            Button {
                if addOrEdit{
                    viewModel.currentUserPortfolio?.athletics.entries.append(entry)
                } else {
                    if let identifier = viewModel.currentUserPortfolio?.athletics.entries.firstIndex(where: {$0.id == entry.id}) {
                        viewModel.currentUserPortfolio?.athletics.entries[identifier] = entry
                    }
                }
                Task {
                    await viewModel.updatePortfolio()
                }
                showSheet.toggle()
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
            }
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.horizontal, 20)
            .padding(.top, 20)
            if !addOrEdit {
                Button{
                    isPresentingConfirm = true
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(destructiveColor)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                    Button("Delete your Entry?", role: .destructive) {
                        if let identifier = viewModel.currentUserPortfolio?.athletics.entries.firstIndex(where: {$0.id == entry.id}) {
                            viewModel.currentUserPortfolio?.athletics.entries.remove(at: identifier)
                        }
                        Task {
                            await viewModel.updatePortfolio()
                        }
                        showSheet.toggle()
                    }
                }
            }
            Spacer()
        }
    }
}

struct AddArtsEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var entry: ArtsEntry
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    @Binding var addOrEdit: Bool
    @State private var isPresentingConfirm: Bool = false
    
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
            
            InputView(label: "Name of Arts", placeholder: "Enter your Arts Name", inputText: $entry.artName)
            
            Toggle("Currently performing?", isOn: $attending)
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            
            DatePicker(
                "Start Date",
                selection: $entry.startingDate,
                displayedComponents: [.date]
            )
            .padding(.horizontal, 30)
            .foregroundStyle(primaryColor)
            
            if !attending {
                DatePicker(
                    "End Date",
                    selection: Binding(get: {entry.endingDate ?? Date()}, set: {entry.endingDate = $0}),
                    displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            }
            
            InputView(label: "Description", placeholder: "Enter a Description", inputText: $entry.artDescription)
            
            Button {
                if addOrEdit{
                    viewModel.currentUserPortfolio?.arts.entries.append(entry)
                } else {
                    if let identifier = viewModel.currentUserPortfolio?.arts.entries.firstIndex(where: {$0.id == entry.id}) {
                        viewModel.currentUserPortfolio?.arts.entries[identifier] = entry
                    }
                }
                Task {
                    await viewModel.updatePortfolio()
                }
                showSheet.toggle()
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
            }
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.horizontal, 20)
            .padding(.top, 20)
            if !addOrEdit {
                Button{
                    isPresentingConfirm = true
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(destructiveColor)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                    Button("Delete your Entry?", role: .destructive) {
                        if let identifier = viewModel.currentUserPortfolio?.arts.entries.firstIndex(where: {$0.id == entry.id}) {
                            viewModel.currentUserPortfolio?.arts.entries.remove(at: identifier)
                        }
                        Task {
                            await viewModel.updatePortfolio()
                        }
                        showSheet.toggle()
                    }
                }
            }
            Spacer()
        }
    }
}


struct AddClubsEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var entry: ClubsEntry
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    @Binding var addOrEdit: Bool
    @State private var isPresentingConfirm: Bool = false
    
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
            
            InputView(label: "Name of Club", placeholder: "Enter your Club Name", inputText: $entry.clubName)
            
            Toggle("Currently a member?", isOn: $attending)
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            
            DatePicker(
                "Start Date",
                selection: $entry.startingDate,
                displayedComponents: [.date]
            )
            .padding(.horizontal, 30)
            .foregroundStyle(primaryColor)
            
            if !attending {
                DatePicker(
                    "End Date",
                    selection: Binding(get: {entry.endingDate ?? Date()}, set: {entry.endingDate = $0}),
                    displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            }
            
            InputView(label: "Description", placeholder: "Enter a Description", inputText: $entry.clubDescription)
            
            Button {
                if addOrEdit{
                    viewModel.currentUserPortfolio?.clubs.entries.append(entry)
                } else {
                    if let identifier = viewModel.currentUserPortfolio?.clubs.entries.firstIndex(where: {$0.id == entry.id}) {
                        viewModel.currentUserPortfolio?.clubs.entries[identifier] = entry
                    }
                }
                Task {
                    await viewModel.updatePortfolio()
                }
                showSheet.toggle()
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
            }
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.horizontal, 20)
            .padding(.top, 20)
            if !addOrEdit {
                Button{
                    isPresentingConfirm = true
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(destructiveColor)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                    Button("Delete your Entry?", role: .destructive) {
                        if let identifier = viewModel.currentUserPortfolio?.clubs.entries.firstIndex(where: {$0.id == entry.id}) {
                            viewModel.currentUserPortfolio?.clubs.entries.remove(at: identifier)
                        }
                        Task {
                            await viewModel.updatePortfolio()
                        }
                        showSheet.toggle()
                    }
                }
            }
            Spacer()
        }
    }
}

struct AddCoursesEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var entry: CoursesEntry
    @Binding var showSheet: Bool
    @Binding var addOrEdit: Bool
    @State private var isPresentingConfirm: Bool = false
    
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
            
            InputView(label: "Name of Course", placeholder: "Enter your Course Name", inputText: $entry.courseName)
            
            InputView(label: "Term", placeholder: "Enter the term of course", inputText: $entry.courseTerm)
            
            InputView(label: "Description", placeholder: "Enter a Description", inputText: $entry.courseDescription)
            
            Button {
                if addOrEdit{
                    viewModel.currentUserPortfolio?.courses.entries.append(entry)
                } else {
                    if let identifier = viewModel.currentUserPortfolio?.courses.entries.firstIndex(where: {$0.id == entry.id}) {
                        viewModel.currentUserPortfolio?.courses.entries[identifier] = entry
                    }
                }
                Task {
                    await viewModel.updatePortfolio()
                }
                showSheet.toggle()
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
            }
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.horizontal, 20)
            .padding(.top, 20)
            if !addOrEdit {
                Button{
                    isPresentingConfirm = true
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(destructiveColor)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                    Button("Delete your Entry?", role: .destructive) {
                        if let identifier = viewModel.currentUserPortfolio?.courses.entries.firstIndex(where: {$0.id == entry.id}) {
                            viewModel.currentUserPortfolio?.courses.entries.remove(at: identifier)
                        }
                        Task {
                            await viewModel.updatePortfolio()
                        }
                        showSheet.toggle()
                    }
                }
            }
            Spacer()
        }
    }
}


struct AddProjectsEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var entry: ProjectsEntry
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    @Binding var addOrEdit: Bool
    @State private var isPresentingConfirm: Bool = false
    
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
            
            InputView(label: "Name of Project", placeholder: "Enter your Project Name", inputText: $entry.projectName)
            
            Toggle("Current Project?", isOn: $attending)
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            
            DatePicker(
                "Start Date",
                selection: $entry.startingDate,
                displayedComponents: [.date]
            )
            .padding(.horizontal, 30)
            .foregroundStyle(primaryColor)
            
            if !attending {
                DatePicker(
                    "End Date",
                    selection: Binding(get: {entry.endingDate ?? Date()}, set: {entry.endingDate = $0}),
                    displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            }
            
            InputView(label: "Description", placeholder: "Enter a Description", inputText: $entry.projectDescription)
            
            Button {
                if addOrEdit{
                    viewModel.currentUserPortfolio?.projects.entries.append(entry)
                } else {
                    if let identifier = viewModel.currentUserPortfolio?.projects.entries.firstIndex(where: {$0.id == entry.id}) {
                        viewModel.currentUserPortfolio?.projects.entries[identifier] = entry
                    }
                }
                Task {
                    await viewModel.updatePortfolio()
                }
                showSheet.toggle()
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
            }
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.horizontal, 20)
            .padding(.top, 20)
            if !addOrEdit {
                Button{
                    isPresentingConfirm = true
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(destructiveColor)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                    Button("Delete your Entry?", role: .destructive) {
                        if let identifier = viewModel.currentUserPortfolio?.projects.entries.firstIndex(where: {$0.id == entry.id}) {
                            viewModel.currentUserPortfolio?.projects.entries.remove(at: identifier)
                        }
                        Task {
                            await viewModel.updatePortfolio()
                        }
                        showSheet.toggle()
                    }
                }
            }
            Spacer()
        }
    }
}


struct AddCommunityServiceEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var entry: CommunityServiceEntry
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    @Binding var addOrEdit: Bool
    @State private var isPresentingConfirm: Bool = false
    
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
            
            InputView(label: "Name of Community Service", placeholder: "Enter your Event Name", inputText: $entry.serviceName)
            
            Toggle("Currently Volunteering?", isOn: $attending)
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            
            DatePicker(
                "Start Date",
                selection: $entry.startingDate,
                displayedComponents: [.date]
            )
            .padding(.horizontal, 30)
            .foregroundStyle(primaryColor)
            
            if !attending {
                DatePicker(
                    "End Date",
                    selection: Binding(get: {entry.endingDate ?? Date()}, set: {entry.endingDate = $0}),
                    displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            }
            
            InputView(label: "Description", placeholder: "Enter a Description", inputText: $entry.serviceDescription)
            
            Button {
                if addOrEdit{
                    viewModel.currentUserPortfolio?.communityService.entries.append(entry)
                } else {
                    if let identifier = viewModel.currentUserPortfolio?.communityService.entries.firstIndex(where: {$0.id == entry.id}) {
                        viewModel.currentUserPortfolio?.communityService.entries[identifier] = entry
                    }
                }
                Task {
                    await viewModel.updatePortfolio()
                }
                showSheet.toggle()
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
            }
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.horizontal, 20)
            .padding(.top, 20)
            if !addOrEdit {
                Button{
                    isPresentingConfirm = true
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(destructiveColor)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                    Button("Delete your Entry?", role: .destructive) {
                        if let identifier = viewModel.currentUserPortfolio?.communityService.entries.firstIndex(where: {$0.id == entry.id}) {
                            viewModel.currentUserPortfolio?.communityService.entries.remove(at: identifier)
                        }
                        Task {
                            await viewModel.updatePortfolio()
                        }
                        showSheet.toggle()
                    }
                }
            }
            Spacer()
        }
    }
}

struct AddWorkEntryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var entry: WorkExperienceEntry
    @State var attending: Bool = false
    @Binding var showSheet: Bool
    @Binding var addOrEdit: Bool
    @State private var isPresentingConfirm: Bool = false
    
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
            Image(systemName: "briefcase.fill")
                .resizable()
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                .padding(.vertical, 30)
            
            InputView(label: "Name of Employer", placeholder: "Enter the name of your Employer", inputText: $entry.workplaceName)
            
            Toggle("Currently an Employee?", isOn: $attending)
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            
            DatePicker(
                "Start Date",
                selection: $entry.startingDate,
                displayedComponents: [.date]
            )
            .padding(.horizontal, 30)
            .foregroundStyle(primaryColor)
            
            if !attending {
                DatePicker(
                    "End Date",
                    selection: Binding(get: {entry.endingDate ?? Date()}, set: {entry.endingDate = $0}),
                    displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(primaryColor)
            }
            
            InputView(label: "Description", placeholder: "Enter a Description", inputText: $entry.workDescription)
            
            Button {
                if addOrEdit{
                    viewModel.currentUserPortfolio?.workExperience.entries.append(entry)
                } else {
                    if let identifier = viewModel.currentUserPortfolio?.workExperience.entries.firstIndex(where: {$0.id == entry.id}) {
                        viewModel.currentUserPortfolio?.workExperience.entries[identifier] = entry
                    }
                }
                Task {
                    await viewModel.updatePortfolio()
                }
                showSheet.toggle()
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
            }
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.horizontal, 20)
            .padding(.top, 20)
            if !addOrEdit {
                Button{
                    isPresentingConfirm = true
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(destructiveColor)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                    Button("Delete your Entry?", role: .destructive) {
                        if let identifier = viewModel.currentUserPortfolio?.workExperience.entries.firstIndex(where: {$0.id == entry.id}) {
                            viewModel.currentUserPortfolio?.workExperience.entries.remove(at: identifier)
                        }
                        Task {
                            await viewModel.updatePortfolio()
                        }
                        showSheet.toggle()
                    }
                }
            }
            Spacer()
        }
    }
}
