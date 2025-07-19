import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let fixedSize = NSSize(width: 390, height: 844)
    self.setContentSize(fixedSize)
    self.styleMask.remove(.resizable)
    self.minSize = fixedSize
    self.maxSize = fixedSize

    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
