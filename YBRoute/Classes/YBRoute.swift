//
//  YBRoute.swift
//  FBSnapshotTestCase
//
//  Created by 曹雁彬 on 2020/7/5.
//

import UIKit

public class YBRoute: NSObject {
    
    public static let `default` = YBRoute()
    private(set) public var urlMap = [String : RouterProtocol.Type]()
    
    open func map(_ urlPattern: RouterURLConvertible, _ routerProtocol: RouterProtocol.Type) {
        let key = urlPattern.urlString
        self.urlMap[key] = routerProtocol
    }
    
    open func viewController(for url: RouterURLConvertible,
                            userInfo: [AnyHashable: Any]? = nil) -> UIViewController? {
        let urlMatcherComponents = URLMathcerComponents(pattern: url.urlString, values: ["":""])

        if let routerProtocol = self.urlMap[url.urlString] {
            return routerProtocol.init(url, values: urlMatcherComponents.values, userInfo: userInfo) as? UIViewController
         }
        return nil
    }
       
    
    @discardableResult
    open func push(
        _ url: RouterURLConvertible,
        userInfo: [AnyHashable: Any]? = nil,
        from: UINavigationController? = nil,
        animated: Bool = true
        ) -> UIViewController? {
        
        guard let viewController = self.viewController(for: url,
                                                  userInfo:["dfa":"f"]) else {
            return nil
        }
        return self.push(viewController, from: from,
                                     animated: animated)
    }
    
    @discardableResult
    open func push(
        _ viewController: UIViewController,
        from: UINavigationController? = nil,
        animated: Bool = true) -> UIViewController? {
        guard let navigationController = from ?? UIViewController.top?.navigationController else{ return nil }
        navigationController.pushViewController(viewController, animated: animated)

        return viewController
    }
    
    @discardableResult
    open func present(
        _ url: RouterURLConvertible,
        userInfo: [AnyHashable: Any]? = nil,
        isWrapNavi: Bool = false,
        from: UIViewController? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
        ) -> UIViewController? {
                
        guard let viewController = self.viewController(for: url, userInfo: ["":""]) else { return nil }
        
        return self.present(viewController, isWrapNavi: isWrapNavi, from: from, animated: animated, completion: completion)
    }

    @discardableResult
    open func present(
        _ viewController: UIViewController,
        isWrapNavi: Bool = false,
        from: UIViewController? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil ) -> UIViewController? {

        guard let fromViewController = from ?? UIViewController.top else { return nil }
        if isWrapNavi {
            let navigationController = UINavigationController(rootViewController: viewController)
            fromViewController.present(navigationController, animated: animated, completion: completion)
        } else {
            fromViewController.present(viewController, animated: animated, completion: completion)
        }

        return viewController
    }
}

extension UIViewController {
    /// Returns the current application's top view controller.
    open class var top : UIViewController? {
        let windows = UIApplication.shared.windows
        var rootViewController : UIViewController?

        for window in windows {
            if let windowRootViewController = window.rootViewController {
                rootViewController = windowRootViewController
                break
            }
        }
        return self.top(of: rootViewController)
    }

    /// Returns the top most view controller from given view controller's stack.
    class func top(of viewController: UIViewController? ) -> UIViewController? {
        /// UITabBarController
        if let tabBarViewController = viewController as? UITabBarController, let selectedViewController = tabBarViewController.selectedViewController {
            return self.top(of: selectedViewController)
        }

        /// UINavigationController
        if let navigationCotroller = viewController as? UINavigationController, let visibleController = navigationCotroller.visibleViewController {
            return self.top(of: visibleController)
        }

        /// presentedViewController
        if let presentViewController = viewController?.presentedViewController {
            return self.top(of: presentViewController)
        }

        /// child viewController
        for subView in viewController?.view?.subviews ?? [] {
            if let childViewController = subView.next as? UIViewController {
                return self.top(of: childViewController)
            }
        }

        return viewController
    }
}

//eg.01
//let mapDic : [String: String] = [
//        "account.login.forget_password"            :"https://m.igeidao.com/login/forget_password",
//        "account.login.fulfill_user_info"          :"https://m.igeidao.com/login/fulfill_user_info",
//        "account.login.succeed"                    :"https://m.igeidao.com/home/index",
//]
//eg.02
//        YBRoute.map("home", homeViewController.self)

