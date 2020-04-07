//
//
//  TestObjectsUtils.swift
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

class TestObjectsUtils {
    
    static let shared = TestObjectsUtils()
    
    private init () { }
    
    func createTestClassDictionary() -> [String: Any] {
        return ["name": "Bob", "age": 25]
    }
    
    func createTestClassDictionaries(numberOfObjects: Int) -> [[String: Any]] {
        if numberOfObjects == 2 {
            return [["name": "Bob", "age": 25], ["name": "Ann", "age": 45]]
        }
        else if numberOfObjects == 3 {
            return [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        }
        else if numberOfObjects == 10 {
            return[["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26], ["name": "Kate", "age": 70], ["name": "John", "age": 55], ["name": "Alex", "age": 33], ["name": "Peter", "age": 14], ["name": "Linda", "age": 34], ["name": "Mary", "age": 30], ["name": "Bruce", "age": 60]]
        }
        return [[String: Any]]()
    }
    
    func createTestClassObject() -> TestClass {
        let object = TestClass()
        object.name = "Bob"
        object.age = 25
        return object
    }
    
    func createTestClassObjects(numberOfObjects: Int) -> [TestClass] {
        var objects = [TestClass]()
        if numberOfObjects == 2 {
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 25
            
            let objectToSave2 = TestClass()
            objectToSave2.name = "Ann"
            objectToSave2.age = 45
            
            objects.append(objectToSave1)
            objects.append(objectToSave2)
        }
        else if numberOfObjects == 3 {
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 25
            
            let objectToSave2 = TestClass()
            objectToSave2.name = "Ann"
            objectToSave2.age = 45
            
            let objectToSave3 = TestClass()
            objectToSave3.name = "Jack"
            objectToSave3.age = 26
            
            objects.append(objectToSave1)
            objects.append(objectToSave2)
            objects.append(objectToSave3)
        }
        else if numberOfObjects == 10 {
            let objectToSave1 = TestClass()
            objectToSave1.name = "Bob"
            objectToSave1.age = 25
            
            let objectToSave2 = TestClass()
            objectToSave2.name = "Ann"
            objectToSave2.age = 45
            
            let objectToSave3 = TestClass()
            objectToSave3.name = "Jack"
            objectToSave3.age = 26
            
            let objectToSave4 = TestClass()
            objectToSave4.name = "Kate"
            objectToSave4.age = 70
            
            let objectToSave5 = TestClass()
            objectToSave5.name = "John"
            objectToSave5.age = 55
            
            let objectToSave6 = TestClass()
            objectToSave6.name = "Alex"
            objectToSave6.age = 33
            
            let objectToSave7 = TestClass()
            objectToSave7.name = "Peter"
            objectToSave7.age = 14
            
            let objectToSave8 = TestClass()
            objectToSave8.name = "Linda"
            objectToSave8.age = 34
            
            let objectToSave9 = TestClass()
            objectToSave9.name = "Mary"
            objectToSave9.age = 30
            
            let objectToSave10 = TestClass()
            objectToSave10.name = "Bruce"
            objectToSave10.age = 60
            
            objects.append(objectToSave1)
            objects.append(objectToSave2)
            objects.append(objectToSave3)
            objects.append(objectToSave4)
            objects.append(objectToSave5)
            objects.append(objectToSave6)
            objects.append(objectToSave7)
            objects.append(objectToSave8)
            objects.append(objectToSave9)
            objects.append(objectToSave10)
        }
        return objects
    }
    
    func createChildTestClassObjects(numberOfObjects: Int) -> [ChildTestClass] {
        var objects = [ChildTestClass]()
        if numberOfObjects == 2 {
            let child1 = ChildTestClass()
            child1.foo = "foo1"
            
            let child2 = ChildTestClass()
            child2.foo = "foo2"
            
            objects.append(child1)
            objects.append(child2)
        }
        else if numberOfObjects == 3 {
            let child1 = ChildTestClass()
            child1.foo = "foo1"
            
            let child2 = ChildTestClass()
            child2.foo = "foo2"
            
            let child3 = ChildTestClass()
            child3.foo = "foo3"
            
            objects.append(child1)
            objects.append(child2)
            objects.append(child3)
        }
        else if numberOfObjects == 10 {
            let child1 = ChildTestClass()
            child1.foo = "foo1"
            
            let child2 = ChildTestClass()
            child2.foo = "foo2"
            
            let child3 = ChildTestClass()
            child3.foo = "foo3"
            
            let child4 = ChildTestClass()
            child4.foo = "foo4"
            
            let child5 = ChildTestClass()
            child5.foo = "foo5"
            
            let child6 = ChildTestClass()
            child6.foo = "foo6"
            
            let child7 = ChildTestClass()
            child7.foo = "foo7"
            
            let child8 = ChildTestClass()
            child8.foo = "foo8"
            
            let child9 = ChildTestClass()
            child9.foo = "foo9"
            
            let child10 = ChildTestClass()
            child10.foo = "foo10"
            
            objects.append(child1)
            objects.append(child2)
            objects.append(child3)
            objects.append(child4)
            objects.append(child5)
            objects.append(child6)
            objects.append(child7)
            objects.append(child8)
            objects.append(child9)
            objects.append(child10)
        }
        return objects
    }
    
    func createTestClassDictionary(responseHandler: (([String : Any]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let testObject = ["name": "Bob", "age": 25] as [String : Any]
        Backendless.shared.data.ofTable("TestClass").save(entity: testObject, responseHandler: { createdObject in
            responseHandler(createdObject)
        }, errorHandler: { fault in
            errorHandler(fault)
        })
    }
    
    func createTestClassObject(responseHandler: ((Any) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let testObject = TestClass()
        testObject.name = "Bob"
        testObject.age = 25
        Backendless.shared.data.of(TestClass.self).save(entity: testObject, responseHandler: { createdObject in
            responseHandler(createdObject)
        }, errorHandler: { fault in
            errorHandler(fault)
        })
    }
    
    func bulkCreateTestClassObjects(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        let testObjects = createTestClassDictionaries(numberOfObjects: 3)
        Backendless.shared.data.ofTable("TestClass").createBulk(entities: testObjects, responseHandler: { objectIds in
            responseHandler(objectIds)
        }, errorHandler: { fault in
            errorHandler(fault)
        })
    }
    
    func bulkCreateChildTestClassObjects(responseHandler: (([String]) -> Void)!, errorHandler: ((Fault) -> Void)!) {
        var childTestObjects = [[String : Any]]()
        for i in 0..<2 {
            childTestObjects.append(["foo": "bar\(i)"])
        }
        Backendless.shared.data.ofTable("ChildTestClass").createBulk(entities: childTestObjects, responseHandler: { objectIds in
            responseHandler(objectIds)
        }, errorHandler: { fault in
            errorHandler(fault)
        })
    }
}
