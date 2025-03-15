//
//  ModelView.swift
//  LinkML
//
//  Created by Enryl Einhard on 14/3/2025.
//

import SwiftUI

struct ModelView: View {
    var body: some View {
        HStack {
            Image(systemName: "function")
            VStack (alignment: .leading) {
                Text("SleepCalculator")
                Text("Sleep")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Group {
                if true {
                    Button("Load") {
                        //
                    }
                } else {
                    Button("Unload") {
                        //
                    }
                }
            }
            .font(.callout)
        }
        .padding(4)
    }
}

#Preview {
    ModelView()
}
