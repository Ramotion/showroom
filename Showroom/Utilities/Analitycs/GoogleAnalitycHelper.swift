import Foundation

enum GoogleAnalitycActions: String {
  case button = "Buttons"
}


func trackScreen(control: Showroom.Control) {
  
  let tracker = GAI.sharedInstance().defaultTracker
  tracker?.set(kGAIScreenName, value: control.title)
  if let builder = GAIDictionaryBuilder.createScreenView() {
    tracker?.send(builder.build() as [NSObject : AnyObject])
  }
}

func trackScreen(string: String) {
  
  let tracker = GAI.sharedInstance().defaultTracker
  tracker?.set(kGAIScreenName, value: string)
  if let builder = GAIDictionaryBuilder.createScreenView() {
    tracker?.send(builder.build() as [NSObject : AnyObject])
  }
}

func sendAction(_ c: GoogleAnalitycActions, a: String, l: String?, v: NSNumber) {
  if let builder = GAIDictionaryBuilder.createEvent(withCategory: c.rawValue, action: a, label: l, value: v) {
    let tracker = GAI.sharedInstance().defaultTracker
    tracker?.send(builder.build() as [NSObject : AnyObject])
  }
}
