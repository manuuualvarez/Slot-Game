//
//  FormRowView.swift
//  Slot Game
//
//  Created by Manny Alvarez on 25/06/2022.
//

import SwiftUI

struct FormRowView: View {
    //    MARK: - Properties
    var title: String
    var value: String
    
    //    MARK: - Body
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
        }
    }
}

// MARK: - Preview
struct FormRowView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowView(title: "Application", value: "Slot Machine")
    }
}
