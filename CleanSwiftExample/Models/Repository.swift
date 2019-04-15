import Foundation
import Codextended

struct Repository: Codable {
    
    var id: Int = -1
    var user: User?
    var repositoryName: String?
    var desc: String?
    var isPrivate: Bool = false
    var isForked: Bool = false
    var isPinned: Bool = false
    
    init(from decoder: Decoder) throws {
        id = try! decoder.decode("id")
        user = try? decoder.decode("owner")
        repositoryName = try? decoder.decode("full_name")
        desc = try? decoder.decode("description")
        isPrivate = (try? decoder.decode("private")) ?? false
        isForked = (try? decoder.decode("fork")) ?? false
        // NOTE: undefined key from github API
        isPinned = (try? decoder.decode("pin")) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        try encoder.encode(id, for: "id")
        try encoder.encode(user, for: "owner")
        try encoder.encode(repositoryName, for: "full_name")
        try encoder.encode(desc, for: "description")
        try encoder.encode(isPrivate, for: "private")
        try encoder.encode(isForked, for: "fork")
        try encoder.encode(isPinned, for: "pin")
    }
}
