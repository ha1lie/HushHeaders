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
    
    @Environment(\.colorScheme) var colorScheme
    
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
    
    private func getInsides() -> some View {
        return VStack {
            #if os(macOS)
            Text("iOS 14 Frameworks")
                .font(.largeTitle)
            #endif
            TextField("Search", text: self.$frameworkSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Picker("", selection: self.$typeToShow) {
                ForEach(0..<types.count) { index in
                    Text("\(self.types[index])(\(index == 0 ? self.publicFrameworks.filter { self.frameworkSearch.isEmpty ? true : $0.range(of: self.frameworkSearch, options: .caseInsensitive) != nil }.filter { self.favoritesOnly ? self.appTools.retrieveFavorites().contains($0) : true}.count : self.privateFrameworks.filter { self.frameworkSearch.isEmpty ? true : $0.range(of: self.frameworkSearch, options: .caseInsensitive) != nil }.filter { self.favoritesOnly ? self.appTools.retrieveFavorites().contains($0) : true}.count))").tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle())
            Toggle("Favorites only", isOn: self.$favoritesOnly)
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    if self.typeToShow == 0 {
                        ForEach(self.publicFrameworks.filter { self.frameworkSearch.isEmpty ? true : $0.range(of: self.frameworkSearch, options: .caseInsensitive) != nil }.filter { self.favoritesOnly ? self.appTools.retrieveFavorites().contains($0) : true}, id: \.self) { name in
                            HHNavLink(name) {
                                FrameworkView(name, isPrivate: self.typeToShow == 1)
                            }
                        }
                    } else {
                        //Show Private
                        ForEach(self.privateFrameworks.filter { self.frameworkSearch.isEmpty ? true : $0.range(of: self.frameworkSearch, options: .caseInsensitive) != nil }.filter { self.favoritesOnly ? self.appTools.retrieveFavorites().contains($0) : true}, id: \.self) { name in
                            HHNavLink(name) {
                                FrameworkView(name, isPrivate: self.typeToShow == 1)
                            }
                        }
                    }
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(12)
    }
    
    var body: some View {
        NavigationView(content: {
            #if os(macOS)
            self.getInsides()
            #else
            self.getInsides()
                .navigationBarTitle("Something")
            #endif
        }).frame(minWidth: 600, minHeight: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
