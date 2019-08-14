//
//  BackendlessDataCollection.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2019 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

@objc public protocol Identifiable {
    var objectId: String? { get set }
}


@objc public enum EventType: Int {
    case dataLoaded
    case created
    case updated
    case deleted
    case bulkDeleted
}


@objcMembers public class BackendlessDataCollection: Collection {
    
    public typealias BackendlessDataCollectionType = [Identifiable]
    public typealias Index = BackendlessDataCollectionType.Index
    public typealias Element = BackendlessDataCollectionType.Element    
    public typealias RequestStartedHandler = () -> Void
    public typealias RequestCompletedHandler = () -> Void
    public typealias BackendlessDataChangedHandler = (EventType) -> Void
    public typealias BackendlessFaultHandler = (Fault) -> Void
    
    public var startIndex: Index { return backendlessCollection.startIndex }
    public var endIndex: Index { return backendlessCollection.endIndex }
    public var requestStartedHandler: RequestStartedHandler?
    public var requestCompletedHandler: RequestCompletedHandler?
    public var dataChangedHandler: BackendlessDataChangedHandler?
    public var errorHandler: BackendlessFaultHandler?
    
    public private(set) var whereClause = ""
    public private(set) var count = 0
    public private(set) var isEmpty: Bool {
        get { return backendlessCollection.isEmpty }
        set { }
    }
    
    private var backendlessCollection = BackendlessDataCollectionType()
    private var entityType: AnyClass!
    private var dataStore: DataStoreFactory!
    private var queryBuilder: DataQueryBuilder!
    private var computedIndex = 0
    
    private enum CollectionErrors {
        static let invalidType = " is not a type of objects contained in this collection."
        static let nullObjectId = "objectId is null."
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public subscript (position: Int) -> Identifiable {
        if position >= count {
            fatalError("Index out of range")
        }
        if queryBuilder.getOffset() == count {
            return backendlessCollection[position]
        }
        else if position < queryBuilder.getOffset() - 2 * queryBuilder.getPageSize() {
            return backendlessCollection[position]
        }
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.loadNextPage()
            semaphore.signal()
        }
        semaphore.wait()
        return backendlessCollection[position]
    }
    
    private init() { }
    
    public convenience init(entityType: AnyClass) {
        self.init(entityType: entityType, whereClause: "")
    }
    
    public convenience init(entityType: AnyClass, whereClause: String) {
        self.init()
        
        queryBuilder = DataQueryBuilder()
        queryBuilder.setPageSize(pageSize: 50)
        queryBuilder.setOffset(offset: 0)
        
        dataStore = Backendless.shared.data.of(entityType.self)
        self.entityType = entityType
        self.whereClause = whereClause
        self.count = getRealCount()
        addRtListeners()
        
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            for _ in 0 ..< 3 {
                self.loadNextPage()
            }
            semaphore.signal()
        }
        semaphore.wait()
        return
    }
    
    deinit {
        dataStore.rt.removeAllListeners()
    }
    
    /// Returns true, if the current collection ihas been fully loaded from Backendless
    public func isLoaded() -> Bool {
        return backendlessCollection.count == count
    }
    
    
    /// Fills up this collection with the values from the Backendless table
    public func populate() {
        guard backendlessCollection.count < count else { return }
        requestStartedHandler?()
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while self.queryBuilder.getOffset() < self.count {
                self.loadNextPage()
            }
            semaphore.signal()
        }
        semaphore.wait()
        dataChangedHandler?(.dataLoaded)
        requestCompletedHandler?()
        return
    }
    
    /// Adds a new element to the Backendless collection
    public func add(newObject: Any) {
        checkObjectType(object: newObject)
        requestStartedHandler?()
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.dataStore.save(entity: newObject, responseHandler: { [weak self] savedObject in
                guard let self = self else {
                    semaphore.signal()
                    return
                }
                guard let savedObject = savedObject as? Identifiable, let objectId = savedObject.objectId else {
                    semaphore.signal()
                    self.errorHandler?(Fault(message: CollectionErrors.nullObjectId, faultCode: 0))
                    return
                }
                if self.whereClause.isEmpty {
                    self.backendlessCollection.append(savedObject)
                    self.count += 1
                    self.queryBuilder.setOffset(offset: self.queryBuilder.getOffset() + 1)
                    semaphore.signal()
                }
                else {
                    self.queryBuilder.setWhereClause(whereClause: self.getQuery(objectId: objectId))
                    if self.getCount(queryBuilder: self.queryBuilder) == 0 {
                        self.dataStore.removeById(objectId: objectId, responseHandler: { removed in
                            semaphore.signal()
                        }, errorHandler: { fault in
                            self.errorHandler?(fault)
                            semaphore.signal()
                        })
                    }
                    else {
                        self.backendlessCollection.append(savedObject)
                        self.count += 1
                        self.queryBuilder.setOffset(offset: self.queryBuilder.getOffset() + 1)
                        semaphore.signal()
                    }
                }
                }, errorHandler: { [weak self] fault in
                    self?.errorHandler?(fault)
                    semaphore.signal()
            })
        }
        semaphore.wait()
        return
    }
    
    /// Adds the elements of a sequence to the Backendless collection
    public func add(contentsOf: [Any]) {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            for newObject in contentsOf {
                self.add(newObject: newObject)
            }
            semaphore.signal()
        }
        semaphore.wait()
        return
    }
    
    /// Inserts a new element into the Backendless collection at the specified position
    public func insert(newObject: Any, at: Int) {
        checkObjectType(object: newObject)
        requestStartedHandler?()
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.dataStore.save(entity: newObject, responseHandler: { [weak self] savedObject in
                guard let self = self else {
                    semaphore.signal()
                    return
                }
                guard let savedObject = savedObject as? Identifiable, let objectId = savedObject.objectId else {
                    semaphore.signal()
                    return
                }
                if self.whereClause.isEmpty {
                    self.backendlessCollection.insert(savedObject, at: at)
                    self.count += 1
                    self.queryBuilder.setOffset(offset: self.queryBuilder.getOffset() + 1)
                    semaphore.signal()
                }
                else {
                    self.queryBuilder.setWhereClause(whereClause: self.getQuery(objectId: objectId))
                    if self.getCount(queryBuilder: self.queryBuilder) == 0 {
                        self.dataStore.removeById(objectId: objectId, responseHandler: { removed in
                            semaphore.signal()
                        }, errorHandler: { fault in
                            self.errorHandler?(fault)
                            semaphore.signal()
                        })
                    }
                    else {
                        self.backendlessCollection.insert(savedObject, at: at)
                        self.count += 1
                        self.queryBuilder.setOffset(offset: self.queryBuilder.getOffset() + 1)
                        semaphore.signal()
                    }
                }
                }, errorHandler: { [weak self] fault in
                    self?.errorHandler?(fault)
                    semaphore.signal()
            })
        }
        semaphore.wait()
        return
    }
    
    /// Inserts the elements of a sequence into the Backendless collection at the specified position
    public func insert(contentsOf: [Any], at: Int) {
        var index = at
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            for newObject in contentsOf {
                self.insert(newObject: newObject, at: index)
                index += 1
            }
            semaphore.signal()
        }
        semaphore.wait()
        return
    }
    
    /// Removes object from the Backendless collection
    public func remove(object: Any) {
        checkObjectTypeAndId(object: object)
        requestStartedHandler?()
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.queryBuilder.setWhereClause(whereClause: self.getQuery(object: object))
            if self.getCount(queryBuilder: self.queryBuilder) > 0 {
                self.dataStore.remove(entity: object, responseHandler: { [weak self] removed in
                    guard let self = self else {
                        semaphore.signal()
                        return
                    }
                    let objectId = (object as! Identifiable).objectId
                    self.backendlessCollection.removeAll(where: { $0.objectId == objectId })
                    self.count -= 1
                    semaphore.signal()
                    }, errorHandler: { [weak self] fault in
                        self?.errorHandler?(fault)
                        semaphore.signal()
                })
            }
        }
        semaphore.wait()
        return
    }
    
    /// Removes and returns the element at the specified position
    public func remove(at: Int) -> Identifiable {
        let object = backendlessCollection[at]
        remove(object: object)
        return object
    }
    
    /// Removes all the elements from the Backendless collection that satisfy the given slice
    public func removeAll() {
        requestStartedHandler?()
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            var whereClause = self.whereClause
            if whereClause.isEmpty {
                whereClause = "objectId!=null"
            }
            self.dataStore.removeBulk(whereClause: whereClause, responseHandler: { [weak self] removed in
                guard let self = self else {
                    semaphore.signal()
                    return
                }
                self.backendlessCollection.removeAll()
                self.count = 0
                semaphore.signal()
                }, errorHandler: { [weak self] fault in
                    self?.errorHandler?(fault)
                    semaphore.signal()
            })
        }
        semaphore.wait()
        return
    }
    
    public func makeIterator() -> AnyIterator<Identifiable> {
        return AnyIterator {
            if self.computedIndex == self.backendlessCollection.endIndex {
                self.loadNextIteratorPage()
            }
            return self.getIteratorElement()
        }
    }
    
    // private functions
    
    private func addRtListeners() {
        let eventHandler = dataStore.rt
        if whereClause.isEmpty {
            let _ = eventHandler?.addCreateListener(responseHandler: { [weak self] createdObject in
                self?.dataChangedHandler?(.created)
                self?.requestCompletedHandler?()
                }, errorHandler: { [weak self] fault in
                    self?.errorHandler?(fault)
            })
            let _ = eventHandler?.addUpdateListener(responseHandler: { [weak self] updatedObject in
                self?.dataChangedHandler?(.updated)
                self?.requestCompletedHandler?()
                }, errorHandler: { [weak self] fault in
                    self?.errorHandler?(fault)
                    self?.requestCompletedHandler?()
            })
            let _ = eventHandler?.addDeleteListener(responseHandler: { [weak self] deletedObject in
                self?.dataChangedHandler?(.deleted)
                self?.requestCompletedHandler?()
                }, errorHandler: { [weak self] fault in
                    self?.errorHandler?(fault)
                    self?.requestCompletedHandler?()
            })
            let _ = eventHandler?.addBulkDeleteListener(responseHandler: { [weak self] bulkEvent in
                self?.dataChangedHandler?(.bulkDeleted)
                self?.requestCompletedHandler?()
                }, errorHandler: { [weak self] fault in
                    self?.errorHandler?(fault)
            })
        }
        else {
            let _ = eventHandler?.addCreateListener(whereClause: whereClause, responseHandler: { [weak self] createdObject in
                self?.dataChangedHandler?(.created)
                self?.requestCompletedHandler?()
                }, errorHandler: { [weak self] fault in
                    self?.errorHandler?(fault)
            })
            let _ = eventHandler?.addUpdateListener(whereClause: whereClause, responseHandler: { [weak self] updatedObject in
                self?.dataChangedHandler?(.updated)
                self?.requestCompletedHandler?()
                }, errorHandler: { [weak self] fault in
                    self?.errorHandler?(fault)
            })
            let _ = eventHandler?.addDeleteListener(whereClause: whereClause, responseHandler: { [weak self] deletedObject in
                self?.dataChangedHandler?(.deleted)
                self?.requestCompletedHandler?()
                }, errorHandler: { [weak self] fault in
                    self?.errorHandler?(fault)
            })
            let _ = eventHandler?.addBulkDeleteListener(whereClause: whereClause, responseHandler: { [weak self] bulkEvent in
                self?.dataChangedHandler?(.bulkDeleted)
                self?.requestCompletedHandler?()
                }, errorHandler: { [weak self] fault in
                    self?.errorHandler?(fault)
            })
        }
    }
    
    private func getRealCount() -> Int {
        var realCount = 0
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.queryBuilder.setWhereClause(whereClause: self.whereClause)
            self.dataStore.getObjectCount(queryBuilder: self.queryBuilder, responseHandler: { totalObjects in
                realCount = totalObjects
                semaphore.signal()
            }, errorHandler: { fault in
                semaphore.signal()
                self.errorHandler?(fault)
            })
        }
        semaphore.wait()
        return realCount
    }
    
    private func getCount(queryBuilder: DataQueryBuilder) -> Int {
        var queryCount = 0
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.dataStore.getObjectCount(queryBuilder: queryBuilder, responseHandler: { totalObjects in
                queryCount = totalObjects
                semaphore.signal()
            }, errorHandler: { fault in
                semaphore.signal()
                self.errorHandler?(fault)
            })
        }
        semaphore.wait()
        return queryCount
    }
    
    private func checkObjectType(object: Any) {
        if entityType != type(of: object) {
            fatalError("\(type(of: object))" + CollectionErrors.invalidType)
        }
    }
    
    private func checkObjectTypeAndId(object: Any) {
        checkObjectType(object: object)
        if (object as! Identifiable).objectId == nil {
            fatalError(CollectionErrors.nullObjectId)
        }
    }
    
    private func getQuery(objectId: String) -> String {
        var query = "objectId='\(objectId)'"
        if !whereClause.isEmpty {
            query += " and \(whereClause)"
        }
        return query
    }
    
    private func getQuery(object: Any) -> String {
        var query = ""
        if object is Identifiable, let objectId = (object as! Identifiable).objectId {
            query = "objectId='\(objectId)'"
            if !whereClause.isEmpty {
                query += " and \(whereClause)"
            }       }
        return query
    }
    
    private func loadNextPage() {
        let semaphore = DispatchSemaphore(value: 0)
        var offset = queryBuilder.getOffset()
        if !whereClause.isEmpty {
            self.queryBuilder.setWhereClause(whereClause: whereClause)
        }
        dataStore.find(queryBuilder: queryBuilder, responseHandler: { [weak self] foundObjects in
            guard let self = self else {
                semaphore.signal()
                return
            }
            guard let foundObjects = foundObjects as? [Identifiable] else {
                semaphore.signal()
                return
            }
            self.backendlessCollection += foundObjects
            offset += foundObjects.count
            
            if self.queryBuilder.getOffset() < self.count {
                self.queryBuilder.setOffset(offset: offset)
            }
            semaphore.signal()
            }, errorHandler: { [weak self] fault in
                semaphore.signal()
                self?.errorHandler?(fault)
        })
        semaphore.wait()
    }
    
    private func loadNextIteratorPage() {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.loadNextPage()
            semaphore.signal()
        }
        semaphore.wait()
        return
    }
    
    private func getIteratorElement() -> Identifiable? {
        if computedIndex < self.backendlessCollection.endIndex {
            let element = self.backendlessCollection[computedIndex]
            computedIndex = self.backendlessCollection.index(after: computedIndex)
            return element
        }
        return nil
    }
}
