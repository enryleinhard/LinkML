//
//  ModelView.swift
//  LinkML
//
//  Created by Enryl Einhard on 14/3/2025.
//

import SwiftUI

struct ModelStatusView: View {
    let linkModel: LinkModel
    
    var body: some View {
        if (linkModel.isDownloading) {
            ProgressView(value: linkModel.downloadProgress, total: 1.0)
                .progressViewStyle(.circular)
        } else {
            if (linkModel.isLoaded) {
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(Color(red: 0, green: 0.6, blue: 0.3))
            } else {
                Image(systemName: "x.circle")
                    .foregroundStyle(.red)
            }
        }
    }
}

struct ModelView: View {
    @EnvironmentObject var linkModelManager: LinkModelManager

    let linkModel: LinkModel
    
    var body: some View {
        HStack {
            Image(systemName: "function")
            VStack (alignment: .leading) {
                Text(linkModel.name)
                Text(linkModel.id.uuidString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            ModelStatusView(linkModel: linkModel)
        }
        .padding(4)
    }
}
