import Foundation

struct ReadJSONFile {
    
    static let shared: ReadJSONFile = .init()
    
    func load<T: Decodable>(_ name: String, type: T.Type, from: AnyClass) -> T? {
        do {
            guard let data = self.testBundleData(name, from: from) else { return nil }
            return try JSONDecoder().decode(type, from: data)
        } catch {
            return nil
        }
    }
    
    func testBundleData(_ jsonFileName: String, from type: AnyClass) -> Data? {
        let bundle = Bundle(for: type)
        let path = bundle.path(forResource: jsonFileName, ofType: nil)!
        return (try? Data(contentsOf: URL(fileURLWithPath: path)))
    }
}
