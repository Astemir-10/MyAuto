import CoreData
import Combine
import Foundation

public final class CombineCoreData {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AppData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    public init() {}
    
    // MARK: - CRUD Operations
    
    public func createEntity<T: NSManagedObject>(entity: T.Type, configure: @escaping (T) -> Void) -> AnyPublisher<T, Error> {
        return Future { [weak self] promise in
            self?.backgroundContext.perform {
                let entityName = String(describing: entity)
                guard let newObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self!.backgroundContext) as? T else {
                    print("ERRO ROKOKOK")
                    promise(.failure(NSError(domain: "CoreDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create entity \(entityName)"])))
                    returnцы
                }
                configure(newObject)
                
                do {
                    try self?.backgroundContext.save()
                    promise(.success(newObject))
                } catch {
                    print(error.localizedDescription)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func removeIfFind<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil) {
        self.backgroundContext.perform {
            let request = T.fetchRequest()
            request.predicate = predicate
            let fetched = try? self.backgroundContext.fetch(request) as? [T]
            
            fetched?.forEach({
                self.backgroundContext.delete($0)
            })
            
            do {
                try self.backgroundContext.save()
            } catch {
                
            }
        }
    }
    
    public func fetchEntities<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> AnyPublisher<[T], Error> {
        return Future { [weak self] promise in
            self?.backgroundContext.perform {
                let request = T.fetchRequest()
                request.predicate = predicate
                request.sortDescriptors = sortDescriptors
                
                do {
                    let result = try self?.backgroundContext.fetch(request) as? [T]
                    promise(.success(result ?? []))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    public func updateEntity<T: NSManagedObject>(entity: T, update: @escaping (T) -> Void) -> AnyPublisher<T, Error> {
        return Future { [weak self] promise in
            self?.backgroundContext.perform {
                update(entity)
                
                do {
                    try self?.backgroundContext.save()
                    promise(.success(entity))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func deleteEntity<T: NSManagedObject>(entity: T) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            self?.backgroundContext.perform {
                self?.backgroundContext.delete(entity)
                
                do {
                    try self?.backgroundContext.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func deleteEntities<T: NSManagedObject>(entity: T.Type) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            self?.backgroundContext.perform {
                let request = T.fetchRequest()
                let fetched = try? self?.backgroundContext.fetch(request) as? [T]
                
                fetched?.forEach({
                    self?.backgroundContext.delete($0)
                })
                
                do {
                    try self?.backgroundContext.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
