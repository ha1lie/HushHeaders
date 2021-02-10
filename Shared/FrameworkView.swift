//
//  FrameworkView.swift
//  HushHeaders
//
//  Created by Hallie on 2/8/21.
//

import SwiftUI

struct FrameworkView: View {
    
    private let headerTools: HeaderTools = HeaderTools()
    @State private var appTools: AppTools = AppTools()
    
    private let framework: String
    private let isPrivate: Bool
    
    @State private var headerSearch: String = ""
    
    init(_ name: String, isPrivate: Bool) {
        self.framework = name
        self.isPrivate = isPrivate
    }
    var body: some View {
        
        let tempHeaderOptions: [String] = self.headerTools.retrieveHeaders(for: self.framework, isPrivate: self.isPrivate)
        
        return VStack(alignment: .leading) {
            Text("Headers")
                .font(.title2)
                .padding(.leading, 8)
                .padding(.vertical, 4)
            TextField("Search", text: self.$headerSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 8)
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    ForEach(tempHeaderOptions.filter { self.headerSearch.isEmpty ? true : $0.contains(self.headerSearch) }, id: \.self) { header in
                        HHNavLink(header) {
                            HeaderView(self.framework, header, self.headerTools.retrieveHeaderContents(header, for: self.framework, isPrivate: self.isPrivate))
                        }
                    }
                }
            }
        }.navigationTitle(self.framework)
        .navigationBarItems(trailing: Button(action: {
            if self.appTools.retrieveFavorites().contains(self.framework) {
                self.appTools.removeFavorite(self.framework)
            } else {
                self.appTools.addFavorite(self.framework)
            }
        }) {
            Image(systemName: self.appTools.retrieveFavorites().contains(self.framework) ? "star.fill" : "star")
                .foregroundColor(self.appTools.retrieveFavorites().contains(self.framework) ? .yellow : .blue)
                .font(.title)
        }) //Comment out to run on MacOS
    }
    
    
}
