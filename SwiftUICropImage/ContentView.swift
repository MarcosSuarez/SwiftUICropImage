//
//  ContentView.swift
//  SwiftUICropImage
//
//  Created by Marcos Suarez Ayala on 28/6/24.
//

import SwiftUI

struct ImageInfo: Identifiable {
    let id: Int
    let image: Image
}

struct ContentView: View {

    @StateObject private var viewModel = ViewModel()
    @State private var numberOfImages: CGFloat = 1
    
    private let image = Image(.fourCats)
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Hello, Cats!")
                .font(.title)
            
            image
                .resizable()
                .scaledToFit()
            
            Slider(value: $numberOfImages, in: 1...10, step: 1) {
                
            } minimumValueLabel: {
                Text("1")
            } maximumValueLabel: {
                Text("10")
            }
            
            Text("Number of images: \(Int(numberOfImages))")
            
            HStack(spacing: 8) {
                ForEach(viewModel.imagesCuts) { imageData in
                    imageData.image
                        .resizable()
                        .scaledToFit()
                }
            }
            
            Button {
                viewModel.imagesCuts.shuffle()
            } label: {
                Text("Shuffle")
            }
            
            Spacer()
        }
        .padding()
        .onChange(of: numberOfImages) { number in
            viewModel.getImages(number: number, from: image)
        }
    }
}

#Preview {
    ContentView()
}
