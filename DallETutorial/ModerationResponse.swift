// Created by Florian Schweizer on 09.11.22

import Foundation

struct ModerationResponse: Codable {
    struct ModerationResult: Codable {
        struct Category: Codable {
            let hate: Bool
            let hateThreatening: Bool
            let selfHarm: Bool
            let sexual: Bool
            let sexualMinors: Bool
            let violence: Bool
            let violenceGraphic: Bool
            
            private enum CodingKeys: String, CodingKey {
                case hate
                case hateThreatening = "hate/threatening"
                case selfHarm = "self-harm"
                case sexual
                case sexualMinors = "sexual/minors"
                case violence
                case violenceGraphic = "violence/graphic"
            }
        }
        
        struct CategoryScore: Codable {
            let hate: Double
            let hateThreatening: Double
            let selfHarm: Double
            let sexual: Double
            let sexualMinors: Double
            let violence: Double
            let violenceGraphic: Double
            
            private enum CodingKeys: String, CodingKey {
                case hate
                case hateThreatening = "hate/threatening"
                case selfHarm = "self-harm"
                case sexual
                case sexualMinors = "sexual/minors"
                case violence
                case violenceGraphic = "violence/graphic"
            }
        }
        
        let categories: Category
        let categoryScores: CategoryScore
        let flagged: Bool
        
        private enum CodingKeys: String, CodingKey {
            case categories
            case categoryScores = "category_scores"
            case flagged
        }
    }
    
    let id: String
    let model: String
    let results: [ModerationResult]
    
    var hasIssues: Bool {
        return results.map(\.flagged).contains(true)
    }
}
