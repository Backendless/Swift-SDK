
import Foundation
import Alamofire

open class MyClass: NSObject {

    public static let shared = MyClass()
    
    open func stringMethod(_ str: String?) -> String? {
        return str
    }
    
    open func alamofireMethod() {
        let url = "http://api.backendless.com/A9C02398-D4D5-AED3-FF4A-635C13AB5F00/A2FDA7CA-A94C-F233-FFB9-554304C06400/data/Person/first"
        Alamofire.request(url).responseJSON(completionHandler: { response in
            print(response)
        })
    }
}
