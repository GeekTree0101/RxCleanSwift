import Foundation
import Codextended

struct Repository: Codable {
    
    var id: Int = -1
    var user: User?
    var repositoryName: String?
    var desc: String?
    var isPrivate: Bool = false
    var isForked: Bool = false
    
    init(from decoder: Decoder) throws {
        id = try! decoder.decode("id")
        user = try? decoder.decode("owner")
        repositoryName = try? decoder.decode("full_name")
        desc = try? decoder.decode("description")
        isPrivate = (try? decoder.decode("private")) ?? false
        isForked = (try? decoder.decode("fork")) ?? false
    }
}
