import Foundation
import Capacitor
import ElcardSDK

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ElcartSDKPlugin)
public class ElcartSDKPlugin: CAPPlugin, BindCardDelegate {
    private lazy var call: CAPPluginCall = CAPPluginCall();
    public func ecOnBindSuccess(_ cardData: String) {
        call.resolve(["data": cardData])
        call.resolve(["code": "0"])
        releaseCall(call)
    }

    public func ecOnBindCancelled() {
        call.reject("Cancelled", "100")
        releaseCall(call)
    }
    
    public func ecOnBindFailed(_ error: Error?) {
        call.reject(String(describing: error), "ERROR")
        releaseCall(call)
    }
    
    func saveCall(_ call: CAPPluginCall){
        call.keepAlive = true
        bridge?.saveCall(call)
        self.call = call
    }
    
    func releaseCall(_ call: CAPPluginCall){
        self.call.keepAlive = false
        bridge?.releaseCall(call)
    }
    
    @objc func bindCard(_ call: CAPPluginCall) {
        guard self.bridge != nil else { return }
        self.saveCall(call)
        
        // Theme configs
        let themeConfigs = call.getObject("theme") ?? [:]
        var theme = ThemeParameters.defalut()
        
        if !themeConfigs.isEmpty {
            if (themeConfigs["backgroundColor"] != nil){
                theme.backgroundColor = UIColor(hex: themeConfigs["backgroundColor"] as! String) ?? theme.backgroundColor
            }
            if (themeConfigs["foregroundColor"] != nil){
                theme.foregroundColor = UIColor(hex: themeConfigs["foregroundColor"] as! String) ?? theme.foregroundColor
            }
            if (themeConfigs["accentColor"] != nil){
                theme.accentColor = UIColor(hex: themeConfigs["accentColor"] as! String) ?? theme.accentColor
            }
            if (themeConfigs["borderColor"] != nil){
                theme.borderColor = UIColor(hex: themeConfigs["borderColor"] as! String) ?? theme.borderColor
            }
            if (themeConfigs["textColor"] != nil){
                theme.textColor = UIColor(hex: themeConfigs["textColor"] as! String) ?? theme.textColor
            }
            if (themeConfigs["inputViewBackgroundColor"] != nil){
                theme.inputViewBackgroundColor = UIColor(hex: themeConfigs["inputViewBackgroundColor"] as! String) ?? theme.inputViewBackgroundColor
            }
        }
        
        // Language configs
        let lang = call.getString("language") ?? "ru"
        var language = Language.ru
        
        switch(lang){
        case "ky":
            language = Language.ky
        default:
            language = Language.ru
        }
        
        DispatchQueue.main.async {
            ElcardCore.bindCard(parent: (self.bridge?.viewController)!, delegate: self, theme: theme, language: language)
        }
    }
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff) >> 8) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            } else if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
