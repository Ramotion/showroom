import UIKit
import WebKit

class VRViewController: UIViewController {
  
  @IBOutlet weak var webView: WKWebView!
  let urlString = Showroom.Control.vr.sharedURL
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MenuPopUpViewController.showPopup(on: self, url: urlString, isRotate: true) { [weak self] in
      UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
      self?.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    ThingersTapViewController.showPopup(on: self)

    if let url = URL(string: urlString) {
      let request = URLRequest(url: url)
        webView.load(request)
      
//      [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//      webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitUserSelect='none';")
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
    }
  }
  
  override open var shouldAutorotate: Bool {
    return true
  }
}
