//
//  HeaderView.swift
//  HushHeaders
//
//  Created by Hallie on 2/5/21.
//

import SwiftUI
struct HeaderView: View {
    
    var frameworkName: String
    var headerName: String
    var props: [String]
    
    init(_ frame: String, _ header: String, _ pieces: [String]) {
        self.frameworkName = frame
        self.headerName = header
        self.props = pieces
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            HStack {
                VStack(alignment: .leading) {
                    ForEach(props, id: \.self) { line in
                        Text(line)
                            .font(.custom("Courier-Bold", size: 12))
                            .padding(.vertical, 2)
                            .padding(.leading, 6)
                    }
                }
                Spacer()
            }
        }.navigationTitle("\(self.frameworkName): \(self.headerName)")
    }
}
