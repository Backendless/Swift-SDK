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
 *  Copyright 2020 BACKENDLESS.COM. All Rights Reserved.
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

@objcMembers public class BackendlessDataCollection: Collection {
    
    public typealias BackendlessDataCollectionType = [Identifiable]
    public typealias Index = BackendlessDataCollectionType.Index
    public typealias Element = BackendlessDataCollectionType.Element
    
    public var startIndex: Index { return backendlessCollection.startIndex }
    public var endIndex: Index { return backendlessCollection.endIndex }
    
    public private(set) var whereClause = ""
    public private(set) var count: Int {
        get {
            if backendlessCollection.count > 0 {
                return backendlessCollection.count
            }
            return self.totalCount
        }
        set { }
    }
    public private(set) var isEmpty: Bool {
        get { return backendlessCollection.isEmpty }
        set { }
    }
    
    private var backendlessCollection = BackendlessDataCollectionType()
    private var entityType: AnyClass!
    private var dataStore: DataStoreFactory!
    private var queryBuilder: DataQueryBuilder!
    private var totalCount: Int = 0
    
    private enum CollectionErrors {
        static let invalidType = " is not a type of objects contained in this collection."
        static let nullObjectId = "objectId is null."
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public subscript (position: Int) -> Identifiable {
        if position >= backendlessCollection.count {
            fatalError("Index out of range")
        }
        if queryBuilder.offset == backendlessCollection.count {
            return backendlessCollection[position]
        }
        else if position < queryBuilder.offset - 2 * queryBuilder.pageSize {
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
        let queryBuilder = DataQueryBuilder()
        queryBuilder.pageSize = 50
        queryBuilder.offset = 0
        self.init(entityType: entityType, queryBuilder: queryBuilder)
    }
    
    public convenience init(entityType: AnyClass, queryBuilder: DataQueryBuilder) {
        self.init()
        self.queryBuilder = queryBuilder
        self.dataStore = Backendless.shared.data.of(entityType.self)
        self.entityType = entityType
        self.whereClause = self.queryBuilder.whereClause ?? ""
        getRealCount()
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            var pagesCount = (self.totalCount / queryBuilder.pageSize)
            if (self.totalCount % queryBuilder.pageSize) > 0 {
                pagesCount += 1
            }
            for _ in 0 ..< pagesCount {
                self.loadNextPage()
            }
            semaphore.signal()
        }
        semaphore.wait()
        return
    }
    
    // Adds a new element to the Backendless collection
    public func add(newObject: Any) {
        checkObjectType(object: newObject)
        backendlessCollection.append(newObject as! Identifiable)
        queryBuilder.offset = queryBuilder.offset + 1
    }
    
    // Adds the elements of a sequence to the Backendless collection
    public func add(contentsOf: [Any]) {
        for object in contentsOf {
            add(newObject: object)
        }
    }
    
    // Inserts a new element into the Backendless collection at the specified position
    public func insert(newObject: Any, at: Int) {
        checkObjectType(object: newObject)
        backendlessCollection.insert(newObject as! Identifiable, at: at)
        queryBuilder.offset = queryBuilder.offset + 1
    }
    
    // Inserts the elements of a sequence into the Backendless collection at the specified position
    public func insert(contentsOf: [Any], at: Int) {
        var index = at
        for newObject in contentsOf {
            insert(newObject: newObject, at: index)
            index += 1
        }
    }
    
    // Removes object from the Backendless collection
    public func remove(object: Any) {
        checkObjectTypeAndId(object: object)
        let objectId = (object as! Identifiable).objectId
        backendlessCollection.removeAll(where: { $0.objectId == objectId })
        queryBuilder.offset = queryBuilder.offset - 1
    }
    
    // Removes and returns the element at the specified position
    public func remove(at: Int) -> Identifiable {
        let object = backendlessCollection[at]
        remove(object: object)
        return object
    }
    
    // Removes all the elements from the Backendless collection that satisfy the given slice
    
    public func removeAll(where shouldBeRemoved: (Identifiable) throws -> Bool) rethrows {
        try backendlessCollection.removeAll(where: shouldBeRemoved)
    }
    
    public func removeAll() {
        self.backendlessCollection.removeAll()
    }
    
    public func makeIterator() -> IndexingIterator<BackendlessDataCollectionType> {
        return backendlessCollection.makeIterator()
    }
    
    public func sort(by: (Identifiable, Identifiable) throws -> Bool) {
        do {
            backendlessCollection = try backendlessCollection.sorted(by: by)
        }
        catch {
            return
        }
    }
    
    // private functions
    
    private func getRealCount() {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.queryBuilder.whereClause = self.whereClause
            self.dataStore.getObjectCount(queryBuilder: self.queryBuilder, responseHandler: { totalObjects in
                self.totalCount = totalObjects
                semaphore.signal()
            }, errorHandler: { fault in
                semaphore.signal()
            })
        }
        semaphore.wait()
        return
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
    
    private func loadNextPage() {
        let semaphore = DispatchSemaphore(value: 0)
        var offset = queryBuilder.offset
        if !whereClause.isEmpty {
            queryBuilder.whereClause = whereClause
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
            
            if self.queryBuilder.offset < self.count {
                self.queryBuilder.offset = offset
            }
            semaphore.signal()
            }, errorHandler: { fault in
                semaphore.signal()
        })
        semaphore.wait()
    }
}
