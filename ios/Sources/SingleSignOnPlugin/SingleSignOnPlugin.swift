import Foundation
import Capacitor
import SafariServices
import AuthenticationServices

typealias JSObject = [String: Any]
@objc(SingleSignOnPlugin)
public class SingleSignOnPlugin: CAPPlugin, ASWebAuthenticationPresentationContextProviding, CAPBridgedPlugin {
    public let identifier = "SingleSignOnPlugin" 
    public let jsName = "SingleSignOn" 
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "authenticate", returnType: CAPPluginReturnPromise),
    ] 

    @available(iOS 12.0, *)
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return DispatchQueue.main.sync {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                return UIWindow()
            }
            return window
        }
    }

    private var session: Any?

    @objc func authenticate(_ call: CAPPluginCall) {
        let url = call.getString("url") ?? ""
        let scheme = call.getString("customScheme") ?? ""

        if #available(iOS 12.0, *) {
            self.session = ASWebAuthenticationSession.init(url: URL(string: url)!, callbackURLScheme: scheme, completionHandler: { url, error in
                if let error = error {
                    call.reject("Error", error.localizedDescription)
                } else {
                    var response = JSObject()
                    response["url"] = url?.absoluteString
                    call.resolve(response)
                }
            })
            if #available(iOS 13.0, *) {
                (self.session as! ASWebAuthenticationSession).presentationContextProvider = self
            }
            (self.session as! ASWebAuthenticationSession).start()
        } else {
            call.reject("Not supported", "iOS version not supported")
        }
    }

}
