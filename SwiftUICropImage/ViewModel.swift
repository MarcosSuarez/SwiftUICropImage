//
//  ViewModel.swift
//  SwiftUICropImage
//
//  Created by Marcos Suarez Ayala on 29/6/24.
//

import Foundation
import SwiftUI

final class ViewModel: ObservableObject {
    @Published var imagesCuts:[ImageInfo] = []
    
    private var cgImage: CGImage?
    
    @MainActor 
    func getCGImage(from image: Image) {
        guard let cgImg = ImageRenderer(content: image).cgImage
        else { return }
        cgImage = cgImg
    }
    
    func getImages(number: CGFloat) {
        imagesCuts = createImages(Int(number))
    }
}

private extension ViewModel {
    
    func createImages(_ numberOfImages: Int) -> [ImageInfo] {
        guard let cgImage, numberOfImages > 0 else { return [] }
        let sizeCGImage = cgImage.width/numberOfImages
        var images: [ImageInfo] = []
        for index in 0..<numberOfImages {
            let sizeCrop = CGSize(width: sizeCGImage, height: cgImage.height)
            let cgRect = CGRect(origin: CGPoint(x: index*sizeCGImage, y: 0), size: sizeCrop)
            
            guard let cropImage =  cgImage.cropping(to: cgRect)
            else { return images }
            
            let newImage = convertToImage(cgImg: cropImage, width: CGFloat(cropImage.width), height: CGFloat(cropImage.height))
            
            images.append(ImageInfo(id: index, image: newImage))
        }
        return images
    }
    
    func convertToImage(cgImg: CGImage, width: CGFloat, height: CGFloat) -> Image {
#if (os(macOS))
        Image(nsImage: NSImage(cgImage: cgImg, size: NSSize(width: width, height: height)))
#else
        Image(uiImage: UIImage(cgImage: cgImg))
#endif
    }
}
