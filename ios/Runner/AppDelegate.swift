import Flutter
import UIKit

private final class NativeContextMenuButtonFactory: NSObject,
  FlutterPlatformViewFactory
{
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func createArgsCodec() -> any FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    NativeContextMenuButtonView(
      frame: frame,
      arguments: args as? [String: Any] ?? [:],
      messenger: messenger
    )
  }
}

private final class NativeContextMenuButtonView: NSObject, FlutterPlatformView {
  private let container: UIView

  init(
    frame: CGRect,
    arguments: [String: Any],
    messenger: FlutterBinaryMessenger
  ) {
    container = UIView(frame: frame)
    super.init()

    let requestId = arguments["requestId"] as? String ?? ""
    let title = arguments["title"] as? String ?? "Community"
    let actionTitle = arguments["action"] as? String ?? "Follow"
    let destructive = arguments["destructive"] as? Bool ?? false
    let channel = FlutterMethodChannel(
      name: "amptive/native_context_menu",
      binaryMessenger: messenger
    )

    container.backgroundColor = .clear
    container.isOpaque = false
    container.clipsToBounds = false
    container.isAccessibilityElement = true
    container.accessibilityTraits = .button
    container.accessibilityLabel = "Options for \(title)"

    let imageName = destructive ? "person.crop.circle.badge.minus" :
      "person.crop.circle.badge.plus"
    let attributes: UIMenuElement.Attributes = destructive ? .destructive : []
    let followAction = UIAction(
      title: actionTitle,
      image: UIImage(systemName: imageName),
      attributes: attributes
    ) { _ in
      channel.invokeMethod(
        "selected",
        arguments: ["requestId": requestId, "action": actionTitle]
      )
    }
    let viewCommunityTitle = "View Community"
    let viewCommunityAction = UIAction(
      title: viewCommunityTitle,
      image: UIImage(systemName: "person.3.fill")
    ) { _ in
      channel.invokeMethod(
        "selected",
        arguments: ["requestId": requestId, "action": viewCommunityTitle]
      )
    }
    let button = UIButton(type: .system)
    button.frame = container.bounds
    button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    button.backgroundColor = .clear
    button.tintColor = .clear
    button.menu = UIMenu(children: [followAction, viewCommunityAction])
    if #available(iOS 16.0, *) {
      button.preferredMenuElementOrder = .fixed
    }
    button.showsMenuAsPrimaryAction = true
    container.addSubview(button)
  }

  func view() -> UIView { container }
}

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: "NativeContextMenuBridge"
    ) else { return }
    registrar.register(
      NativeContextMenuButtonFactory(messenger: registrar.messenger()),
      withId: "amptive/native_context_menu_button"
    )
  }
}
