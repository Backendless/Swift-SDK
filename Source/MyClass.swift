
import UIKit

open class MyClass: NSObject {

    public static let shared = MyClass()
    
    open func stringMethod(_ str: String?) -> String? {
        return str
    }
}
