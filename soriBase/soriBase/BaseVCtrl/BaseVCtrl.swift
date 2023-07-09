//
//  BaseVCtrl.swift
//  soriBase
//
//  Created by soriBao on 09/07/2023.
//

import Foundation
import UIKit
import RxSwift

class BaseVCtrl:UIViewController, UIGestureRecognizerDelegate {
    //MARK: - Propertwis
    var tapGestureRecognizer = UITapGestureRecognizer()
    var viewModel: BaseViewModel?
    let disposeBag = DisposeBag()
    
    var topSafeArea: CGFloat = 0
    var bottomSafeArea: CGFloat = 0

    init(viewModel: BaseViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint( "deinit \(self.self)")
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerCells()
        initViewModel()
        setupView()
        initReactive()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        notification()
        
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
    }
    
    open func setupView() { }
    
    open func initViewModel() { }
    
    open func initReactive() { }
    
    open func registerCells() { }
    
    open func notification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) -> Void {
        tapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) -> Void {
        
        if let gestureRecognizers = view.gestureRecognizers {
            for gr in gestureRecognizers {
                if ((gr as? UITapGestureRecognizer) != nil) {
                    self.view.removeGestureRecognizer(gr)
                }
            }
        }
    }
    

    open func showAlert(title:String, message:String, done:UIAlertAction?, cancel:UIAlertAction?, cancelTitle:String = "Cancel"){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancel = cancel {
            alertController.addAction(cancel)
        }else {
            let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertAction.Style.cancel) {
                UIAlertAction in }
            // Add the actions
            alertController.addAction(cancelAction)
        }
        if let done = done {
            alertController.addAction(done)
        }
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func popNavigaTo(type: AnyClass) {
        guard let navigation = self.navigationController else { return }
        for controller in navigation.viewControllers as Array {
            if controller.isKind(of: type) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func showLoading() { }
    
}

extension BaseVCtrl {
    func createToolBar() -> UIToolbar {
        let toobar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toobar.barStyle = .default
        toobar.items = [
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneToolBar))]
        toobar.sizeToFit()
        return toobar
    }
    
    @objc func doneToolBar() {
        view.endEditing(true)
    }
}



extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}


extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
