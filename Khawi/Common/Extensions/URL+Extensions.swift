//
//  URL+Extensions.swift
//  Khawi
//
//  Created by Karim Amsha on 23.10.2023.
//

import SwiftUI
import AVFoundation

extension URL {
    func getThumbnailFrom() -> UIImage? {
        do {
            let asset = AVURLAsset(url: self , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)

            return thumbnail

        } catch let error {

            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil

        }

    }
}
