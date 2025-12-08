import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var urlSchemeChannel: FlutterMethodChannel?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Flutter MethodChannel 설정 (FlutterViewController가 준비된 후)
    DispatchQueue.main.async { [weak self] in
      self?.setupMethodChannel()
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func setupMethodChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      // FlutterViewController가 아직 준비되지 않았으면 잠시 후 다시 시도
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
        self?.setupMethodChannel()
      }
      return
    }
    
    urlSchemeChannel = FlutterMethodChannel(
      name: "com.smileDragon.onetoday/url_scheme",
      binaryMessenger: controller.binaryMessenger
    )
    
    urlSchemeChannel?.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getInitialUrl" {
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  private func sendUrlToFlutter(_ url: String) {
    if let channel = urlSchemeChannel {
      channel.invokeMethod("onUrlScheme", arguments: url)
    } else {
      // Channel이 아직 준비되지 않았으면 잠시 후 다시 시도
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
        self?.sendUrlToFlutter(url)
      }
    }
  }
  
  // URL 스킴으로 앱이 실행될 때 (앱이 종료된 상태 또는 백그라운드 상태)
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    if url.scheme == "onetoday" {
      sendUrlToFlutter(url.absoluteString)
      return true
    }
    return false
  }
}
