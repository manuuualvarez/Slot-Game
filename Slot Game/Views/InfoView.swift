//
//  InfoView.swift
//  Slot Game
//
//  Created by Manny Alvarez on 25/06/2022.
//

import SwiftUI

struct InfoView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            Spacer()
            
            Form {
                Section(header: Text("About the App")) {
                    FormRowView(title: "Application", value: "Slot Machine Game")
                    FormRowView(title: "Platform", value: "iPhone, iPad, Mac")
                    FormRowView(title: "Developer", value: "Manu Alvarez")
                    FormRowView(title: "Music", value: "Music for Developers")
                    FormRowView(title: "WebSite", value: "manuelalvarez.io")
                    FormRowView(title: "CopyRights", value: "© 2022 All right reserved.")
                    FormRowView(title: "Version", value: "1.0.0")
                }//Section
            }//Form
            .font(.system(.body, design: .rounded))
        }//VStack
        .padding(.top, 40)
        .overlay(
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            })
            .padding(.top, 30)
            .padding(.trailing, 10)
            .accentColor(.secondary)
            , alignment: .topTrailing
            //:Button
        
        )
        .onAppear {
            playSound(sound: "background-music", type: "mp3")
        }
        .onDisappear {
            audioPlayer?.stop()
        }
        
    }
}

// MARK: - Preview
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}


