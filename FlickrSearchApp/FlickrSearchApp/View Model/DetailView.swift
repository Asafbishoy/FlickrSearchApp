//
//  DetailView.swift
//  FlickrSearchApp
//
//  Created by Asaf Ahmed on 7/2/24.
//

import Foundation
import SwiftUI

struct DetailView: View {
    let image: FlickrImage

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: image.media.m)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            .cornerRadius(8)
            .padding()
            .accessibilityIdentifier("DetailImage")

            Text(image.title)
                .font(.title)
                .padding()
                .accessibilityIdentifier("Title")

            Text(image.description)
                .padding()
                .accessibilityIdentifier("Description")

            Text("Author: \(image.author)")
                .padding()
                .accessibilityIdentifier("Author")

            Text("Published: \(image.published)")
                .padding()
                .accessibilityIdentifier("Published")

            Spacer()
        }
        .navigationTitle("Image Detail")
        .accessibilityIdentifier("DetailView")
    }
}
