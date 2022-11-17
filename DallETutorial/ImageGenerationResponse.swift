// Created by Florian Schweizer on 09.11.22

import Foundation

struct ImageGenerationResponse: Codable {
    struct ImageResponse: Codable {
        let url: URL
    }
    
    let created: Int
    let data: [ImageResponse]
}
