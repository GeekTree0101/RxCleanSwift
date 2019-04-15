import Foundation
import Codextended

struct User: Codable {
    
    var username: String = ""
    var profileURL: URL?
    
    init(from decoder: Decoder) throws {
        username = try! decoder.decode("login")
        profileURL = try? decoder.decode("avatar_url")
    }
    
    func encode(to encoder: Encoder) throws {
        try encoder.encode(username, for: "login")
        try encoder.encode(profileURL, for: "avatar_url")
    }
}
