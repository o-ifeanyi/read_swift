//
//  SearchView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

struct LibraryView: View {
    
    var body: some View {
        NavigationLink("Library View Two", value: Routes.librarytwo)
            .buttonStyle(.bordered)
    }
}

#Preview {
    LibraryView()
}
