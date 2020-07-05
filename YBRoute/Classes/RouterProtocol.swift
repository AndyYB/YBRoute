//
//  RouterProtocol.swift
//  YBRoute
//
//  Created by 曹雁彬 on 2020/7/5.
//

import Foundation

public struct URLMathcerComponents {
    public let pattern : String
    public let values : [String : Any]
}

public protocol RouterProtocol {
    var className : String? { get }
    init?(_ url: RouterURLConvertible, values: [String : Any], userInfo: [AnyHashable : Any]?)
}

public protocol RouterURLConvertible {
    var url: URL? {get}
    var urlString: String {get}

    var queryParams: [String : String] {get}
    @available (iOS 8, *)
    var queryItems: [URLQueryItem]? {get}
}

extension RouterURLConvertible {
    public var queryParams: [String : String] {
        var queryParams = [String : String]()
        self.url?.query?.components(separatedBy: "&").forEach {
            let keysAndValues = $0.components(separatedBy: "=")
            if keysAndValues.count == 2 {
                let key = keysAndValues[0]
                let value = keysAndValues[1].replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? keysAndValues[1]
                queryParams[key] = value
            }
        }
        return queryParams
    }

    @available (iOS 8, *)
    public var queryItems: [URLQueryItem]? {
        return URLComponents(string: self.urlString)?.queryItems
    }
}

extension String: RouterURLConvertible {
    public var url: URL? {
        if let url = URL(string: self) {
            return url
        }
        var set = CharacterSet()
        set.formUnion(.urlHostAllowed)
        set.formUnion(.urlPathAllowed)
        set.formUnion(.urlQueryAllowed)
        set.formUnion(.urlFragmentAllowed)
        return self.addingPercentEncoding(withAllowedCharacters: set).flatMap { URL(string: $0) }
    }

    public var urlString: String {
        return self
    }

    /// PercentEncoding use RFC3986
    public func addingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~"    // -._~/? :=&
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}

extension URL: RouterURLConvertible {
    public var url: URL? {
        return self
    }

    public var urlString: String {
        return self.absoluteString
    }
}


extension NSObject {
    // MARK:返回className
    var ClassName:String{
        get{
            let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }
            
        }
    }
}
