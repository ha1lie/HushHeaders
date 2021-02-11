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
    
    @State var isShowingHeader: Bool = false
    
    @State private var headerSearch: String = ""
    
    @State private var selectedHeader: String = ""
    
    init(_ name: String, isPrivate: Bool) {
        self.framework = name
        self.isPrivate = isPrivate
    }
    
    var body: some View {
        
        let tempHeaderOptions: [String] = self.headerTools.retrieveHeaders(for: self.framework, isPrivate: self.isPrivate)

        #if os(macOS)
        return VStack(alignment: .leading) {
            if self.isShowingHeader {
                Group {
                    Button(action: {
                        self.selectedHeader = ""
                        self.isShowingHeader = false
                    }) {
                        Text("< \(self.framework)")
                    }.padding(8)
                    HeaderView(self.framework, self.selectedHeader, self.headerTools.retrieveHeaderContents(self.selectedHeader, for: self.framework, isPrivate: self.isPrivate))
                }.transition(AnyTransition.move(edge: .trailing))
            } else {
                Group {
                    Text("\(self.framework) Headers")
                        .font(.title2)
                        .padding(.leading, 8)
                        .padding(.vertical, 4)
                    TextField("Search", text: self.$headerSearch)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 8)
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ForEach(tempHeaderOptions.filter { self.headerSearch.isEmpty ? true : $0.range(of: self.headerSearch, options: .caseInsensitive) != nil }, id: \.self) { header in
                                Button(action: {
                                    self.selectedHeader = header
                                    self.isShowingHeader = true
                                }) {
                                    Text(header)
                                }
                            }
                        }
                    }
                }.transition(AnyTransition.move(edge: .leading))
            }
        }.padding(8)
        #else
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
                    ForEach(tempHeaderOptions.filter { self.headerSearch.isEmpty ? true : $0.range(of: self.headerSearch, options: .caseInsensitive) != nil }, id: \.self) { header in
                        HHNavLink(header) {
                            HeaderView(self.framework, header, self.headerTools.retrieveHeaderContents(header, for: self.framework, isPrivate: self.isPrivate))
                        }
                    }
                }.padding(.leading, 8)
            }
        }
        .navigationTitle(self.framework)
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
        })
        #endif
    }
}
