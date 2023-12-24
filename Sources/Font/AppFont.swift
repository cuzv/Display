import UIKit
import Combine
import CombineExtension
import TextFontDescriptor

// MARK: - AppFont

public struct AppFont {
  public static var settings: Settings = loadSettings() {
    didSet {
      if let data = try? JSONEncoder().encode(settings) {
        UserDefaults.standard.appFontSettings = data
        NotificationCenter.default.post(name: .didUpdateAppFontSettings, object: settings)
      }
    }
  }

  private static func loadSettings() -> Settings {
    if
      let data = UserDefaults.standard.appFontSettings,
      let settings = try? JSONDecoder().decode(Settings.self, from: data)
    {
      return settings
    }
    return Settings(design: .default, scale: 1)
  }

  public static func updatedSettingsPublisher() -> AnyPublisher<Settings, Never> {
    NotificationCenter.default.publisher(for: .didUpdateAppFontSettings)
      .compactMap(\.object)
      .compactMap {
        $0 as? Settings
      }
      .share(replay: 1)
      .eraseToAnyPublisher()
  }

  public static func updatedFontPublisher(for descriptor: @escaping () -> TextFontDescriptor?) -> AnyPublisher<UIFont, Never> {
    updatedSettingsPublisher()
      .compactMap { settings -> (TextFontDescriptor, AppFont.Settings)? in
        if let descriptor = descriptor() {
          return (descriptor, settings)
        }
        return nil
      }
      .map(uiFont(from:with:))
      .share(replay: 1)
      .eraseToAnyPublisher()
  }

  public static func uiFont(from descriptor: TextFontDescriptor) -> UIFont {
    uiFont(from: descriptor, with: settings)
  }

  private static func uiFont(from descriptor: TextFontDescriptor, with settings: AppFont.Settings) -> UIFont {
    let family = settings.family
    let scale = settings.scale

    let font = descriptor.with(
      family: descriptor.isSystemFont ? family : nil,
      design: settings.design,
      scale: scale
    ).nativeFont

    if nil == family {
      return font.withSize(font.fontDescriptor.pointSize * scale)
    } else {
      return font
    }
  }
}

// MARK: - AppFont.Settings

extension AppFont {
  public struct Settings {
    public var family: String?
    public var design: UIFontDescriptor.SystemDesign
    public var scale: CGFloat

    public init(family: String? = nil, design: UIFontDescriptor.SystemDesign, scale: CGFloat) {
      self.family = family
      self.design = design
      self.scale = scale
    }
  }
}

extension AppFont.Settings: Codable {}
extension UIFontDescriptor.SystemDesign: Codable {}

extension UserDefaults {
  var appFontSettings: Data? {
    get { data(forKey: #function) }
    set { set(newValue, forKey: #function) }
  }
}

extension Notification.Name {
  static let didUpdateAppFontSettings = Notification.Name(rawValue: "com.redrainlab.didUpdateAppFontSettings")
}
