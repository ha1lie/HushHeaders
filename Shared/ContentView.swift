//
//  ContentView.swift
//  HushHeaders
//
//  Created by Hallie on 2/5/21.
//

import SwiftUI

struct Framework: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let frames: [Framework]?
}
struct ContentView: View {
    
    @State private var appTools = AppTools()
    private let headerTools = HeaderTools()
    
    var privateFrameworks: [String] = []
    var publicFrameworks: [String] = []
    
    @State private var favoritesOnly: Bool = false
    
    @State private var frameworkSearch: String = ""
    @State private var headerSearch: String = ""
    
    @State private var typeToShow = 0
    private let types: [String] = ["Public", "Private"]
    
    init() {
        self.privateFrameworks = self.headerTools.retrieveFrameworks(.priv)
        self.publicFrameworks = self.headerTools.retrieveFrameworks(.pub)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                TextField("Search", text: self.$frameworkSearch)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 8)
                Picker(selection: self.$typeToShow, label: Text("Which Type Of Frameworks?")) {
                    ForEach(0..<types.count) { index in
                        Text("\(self.types[index])(\(index == 0 ? self.publicFrameworks.filter { self.frameworkSearch.isEmpty ? true : $0.contains(self.frameworkSearch) }.filter { self.favoritesOnly ? self.appTools.retrieveFavorites().contains($0) : true}.count : self.privateFrameworks.filter { self.frameworkSearch.isEmpty ? true : $0.contains(self.frameworkSearch) }.filter { self.favoritesOnly ? self.appTools.retrieveFavorites().contains($0) : true}.count))").tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 8)
                HStack {
                    Toggle(isOn: self.$favoritesOnly) {
                        Text("Blah Blah Filling Text")
                    }.labelsHidden()
                    Text("Favorites Only")
                }
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading) {
                        if self.typeToShow == 0 {
                            ForEach(self.publicFrameworks.filter { self.frameworkSearch.isEmpty ? true : $0.contains(self.frameworkSearch) }.filter { self.favoritesOnly ? self.appTools.retrieveFavorites().contains($0) : true}, id: \.self) { name in
                                HHNavLink(name) {
                                    FrameworkView(name, isPrivate: self.typeToShow == 1)
                                }
                            }
                        } else {
                            //Show Private
                            ForEach(self.privateFrameworks.filter { self.frameworkSearch.isEmpty ? true : $0.contains(self.frameworkSearch) }.filter { self.favoritesOnly ? self.appTools.retrieveFavorites().contains($0) : true}, id: \.self) { name in
                                HHNavLink(name) {
                                    FrameworkView(name, isPrivate: self.typeToShow == 1)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("iOS 14 Frameworks") //Comment out to run on MacOS
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
