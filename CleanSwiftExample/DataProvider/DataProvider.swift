import Foundation
import UIKit
import CoreData
import RxSwift
import RxCocoa
import RxOptional
import Codextended

class DataProvider {
    
    struct Const {
        
        static let identifierKey: String = "id"
        static let dataKey: String = "data"
    }
    
    enum Scope {
        
        case repository(Int)
        
        var entity: String {
            switch self {
            case .repository: return "DataRepository"
            }
        }
        
        var identifier: String {
            switch self {
            case .repository(let id):
                return "\(id)"
            }
        }
    }
    
    static let shared = DataProvider()
    
    private var persistentContainer: NSPersistentContainer?
    private let updateDataRelay = PublishRelay<String>()
    
    
    private var viewContext: NSManagedObjectContext? {
        return persistentContainer?.viewContext
    }
    
    public func configure() {
        self.persistentContainer = NSPersistentContainer.init(name: "CleanSwiftExample")
        self.persistentContainer?.loadPersistentStores(completionHandler: { [weak self] _, error in
            guard error != nil else { return }
            self?.persistentContainer = nil
        })
    }
    
    @discardableResult
    public func save<T: Codable>(_ scope: Scope, model: T) -> Bool {
        guard let viewContext = self.viewContext,
            let data = try? model.encoded(),
            let entity = NSEntityDescription
                .entity(forEntityName: scope.entity, in: viewContext) else { return false }
        
        let object = self.loadObject(scope, type: type(of: model))
            ?? NSManagedObject(entity: entity, insertInto: viewContext)
        
        object.setValue(scope.identifier, forKey: Const.identifierKey)
        object.setValue(data, forKey: Const.dataKey)
        
        do {
            try viewContext.save()
            self.updateDataRelay.accept(scope.identifier)
            return true
        } catch {
            return false
        }
    }
    
    public func loadObservable<T: Codable>(_ scope: Scope, type: T.Type) -> Single<T> {
        return Single<T>.create(subscribe: { operation in
            if let model = self.load(scope, type: type) {
                operation(.success(model))
            } else {
                let error = NSError.init(domain: "Not found", code: 0, userInfo: nil)
                operation(.error(error))
            }
            
            return Disposables.create()
        })
    }
    
    public func load<T: Codable>(_ scope: Scope, type: T.Type) -> T? {
        guard let object = self.loadObject(scope, type: type),
            let data = object.value(forKey: Const.dataKey) as? Data else { return nil }
        
        do {
            return try data.decoded() as T
        } catch {
            return nil
        }
    }
    
    private func loadObject<T: Codable>(_ scope: Scope, type: T.Type) -> NSManagedObject? {
        guard let viewContext = self.viewContext else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: scope.entity)
        
        do {
            let result = try viewContext.fetch(request)
            
            for object in result.map({ $0 as? NSManagedObject }) where
                object?.value(forKey: Const.identifierKey) as? String == scope.identifier {
                    return object
            }
            
            return nil
        } catch {
            return nil
        }
    }
}
