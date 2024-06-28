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
    
    @State private var image: Image?
    @State private var imagesCuts:[ImageInfo] = []
    
    var body: some View {
        VStack {
            Text("Hello, Cats!")
                .font(.title)
            
            image?
                .resizable()
                .scaledToFit()
            
            HStack(spacing: 8) {
                ForEach(imagesCuts) { imageData in
                    imageData.image
                        .resizable()
                        .scaledToFit()
                }
            }
            
            Button {
                imagesCuts.shuffle()
            } label: {
                Text("Shuffle")
            }
            
            Spacer()
        }
        .padding()
        .onAppear(perform: loadImage)
    }
}

#Preview {
    ContentView()
}

private extension ContentView {
    @MainActor
    func loadImage() {
        image = Image(.fourCats)
        
        guard let image,
              let cgImg = ImageRenderer(content: image).cgImage
        else { return }
        
        let numberOfImages: Int = 4
        let sizeCGImage = cgImg.width/numberOfImages
        
        for index in 0..<numberOfImages {
            let sizeCrop = CGSize(width: sizeCGImage, height: cgImg.height)
            let cgRect = CGRect(origin: CGPoint(x: index*sizeCGImage, y: 0), size: sizeCrop)
            
            guard let cropImage =  cgImg.cropping(to: cgRect)
            else { return }
            
            let newImage = convertToImage(cgImg: cropImage, width: CGFloat(cropImage.width), height: CGFloat(cropImage.height))
            
            imagesCuts.append(ImageInfo(id: index, image: newImage))
        }
    }
    
    func convertToImage(cgImg: CGImage, width: CGFloat, height: CGFloat) -> Image {
#if (os(macOS))
        Image(nsImage: NSImage(cgImage: cgImg, size: NSSize(width: width, height: height)))
#else
        Image(uiImage: UIImage(cgImage: cgImg))
#endif
    }
}
