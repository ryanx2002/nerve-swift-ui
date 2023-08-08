//
//  Movie.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/6/23.
//

import Foundation
import AVKit
import PhotosUI
import SwiftUI
import AVFoundation

struct Movie: Identifiable, Transferable {
    
    static let defaultPlayViewVideoURL = Bundle.main.url(forResource: "STREAK-VIDEO", withExtension: ".mp4")!
    
    let id: UUID
    let dateAdded: Date
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            
            let id = UUID()
            let tempURL = URL.documentsDirectory.appending(path: "movie.mp4")

            // overrides any file already saved at url
            if FileManager.default.fileExists(atPath: tempURL.path()) {
                try FileManager.default.removeItem(at: tempURL)
            }
            
            // saving video to "documents" directory
            try FileManager.default.copyItem(at: received.file, to: tempURL)
            
            return Self.init(id: id, url: tempURL)
        }
    }
    
    init(id: UUID = UUID(), dateAdded: Date = Date(), url: URL) {
        self.id = id
        self.dateAdded = dateAdded
        self.url = url
    }
}
