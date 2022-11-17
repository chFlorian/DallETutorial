// Created by Florian Schweizer on 09.11.22

import SwiftUI

class DallEImageGenerator {
    static let shared = DallEImageGenerator()
    let sessionID = UUID().uuidString
    
    private init() { }
    
    func makeSurePromptIsValid(_ prompt: String, apiKey: String) async throws -> Bool {
        guard let url = URL(string: "https://api.openai.com/v1/moderations") else {
            throw ImageError.badURL
        }
        
        let parameters: [String: Any] = [
            "input" : prompt
        ]
        let data: Data = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let (response, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(ModerationResponse.self, from: response)
        
        return result.hasIssues == false
    }
    
    func generateImage(withPrompt prompt: String, apiKey: String) async throws -> ImageGenerationResponse {
        guard try await makeSurePromptIsValid(prompt, apiKey: apiKey) else {
            throw ImageError.inValidPrompt
        }
        
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
            throw ImageError.badURL
        }
        
        let parameters: [String: Any] = [
            "prompt" : prompt,
            "n" : 1,
            "size" : "1024x1024",
            "user" : sessionID
        ]
        let data: Data = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let (response, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(ImageGenerationResponse.self, from: response)
        
        return result
    }
}

enum ImageError: Error {
    case inValidPrompt, badURL
}
