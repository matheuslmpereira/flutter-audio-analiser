import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var eventSink: FlutterEventSink?
  var counter: Int = 0
  var timer: Timer?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let counterChannel = FlutterEventChannel(name: "com.matheusdev.adjustable_tuner/native_counter", binaryMessenger: controller.binaryMessenger)

    counterChannel.setStreamHandler(
      FlutterStreamHandlerImpl(
        onStartHandler: { (args, eventSink) -> FlutterError? in
          self.eventSink = eventSink
          self.startCounter()
          return nil
        },
        onCancelHandler: { (args) -> FlutterError? in
          self.stopCounter()
          return nil
        }
      )
    )

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  let methodChannel = FlutterMethodChannel(name: "com.matheusdev.adjustable_tuner/native_methods", binaryMessenger: controller.binaryMessenger)
  methodChannel.setMethodCallHandler({
    (call: FlutterMethodCall, result: FlutterResult) -> Void in
    switch call.method {
      case "startCounter":
        self.startCounter()
        result(nil)
      case "pauseCounter":
        self.stopCounter()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
    }
  })

  func startCounter() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      self.counter += 1
      self.eventSink?(self.counter)
    }
  }

  func stopCounter() {
    timer?.invalidate()
    timer = nil
  }
}

class FlutterStreamHandlerImpl: NSObject, FlutterStreamHandler {
  private var onStart: ((Any?, FlutterEventSink) -> FlutterError?)?
  private var onCancel: ((Any?) -> FlutterError?)?

  init(
    onStartHandler: @escaping (Any?, FlutterEventSink) -> FlutterError?,
    onCancelHandler: @escaping (Any?) -> FlutterError?
  ) {
    self.onStart = onStartHandler
    self.onCancel = onCancelHandler
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    return onStart?(arguments, events)
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    return onCancel?(arguments)
  }
}
