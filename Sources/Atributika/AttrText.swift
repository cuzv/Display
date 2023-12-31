import Atributika
import SwiftUI

struct AttrLabel: UIViewRepresentable {
  let builder: AttributedStringBuilder
  let preferredMaxLayoutWidth: CGFloat
  let onClick: ((Any) -> Void)?

  init(
    builder: AttributedStringBuilder,
    preferredMaxLayoutWidth: CGFloat = .greatestFiniteMagnitude,
    onClick: ((Any) -> Void)? = nil
  ) {
    self.builder = builder
    self.preferredMaxLayoutWidth = preferredMaxLayoutWidth
    self.onClick = onClick
  }

  func makeUIView(context: Context) -> AttributedLabel {
    let label = AttributedLabel()
    label.numberOfLines = 0
    label.setContentHuggingPriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
    label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    label.linkHighlightViewFactory = RoundedRectLinkHighlightViewFactory()
    label.onLinkTouchUpInside = { _, value in
      onClick?(value)
    }

    updateUIView(label, context: context)
    return label
  }

  func updateUIView(_ label: AttributedLabel, context _: Context) {
    label.attributedTextBuilder(builder)
    label.preferredMaxLayoutWidth = preferredMaxLayoutWidth
  }
}

@available(iOS 13.0, *)
struct HorizontalGeometryReader<Content: View>: View {
  public var content: (CGFloat) -> Content
  @State private var width: CGFloat = 0

  init(@ViewBuilder content: @escaping (CGFloat) -> Content) {
    self.content = content
  }

  var body: some View {
    content(width)
      .frame(minWidth: 0, maxWidth: .infinity)
      .background(
        GeometryReader { geometry in
          Color.clear
            .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
      )
      .onPreferenceChange(WidthPreferenceKey.self) { width in
        self.width = width
      }
  }
}

@available(iOS 13.0, *)
struct WidthPreferenceKey: PreferenceKey, Equatable {
  static var defaultValue: CGFloat = 0

  /// An empty reduce implementation takes the first value
  static func reduce(value _: inout CGFloat, nextValue _: () -> CGFloat) {}
}

extension AttributedLabel: AttributedStringConsumer {
  public func setAttributedText(_ text: NSAttributedString?) {
    attributedText = text
  }
}

public struct AttrText: View {
  let builder: AttributedStringBuilder
  let onClick: ((Any) -> Void)?

  public init(builder: AttributedStringBuilder, onClick: ( (Any) -> Void)?) {
    self.builder = builder
    self.onClick = onClick
  }

  public var body: some View {
    HorizontalGeometryReader { width in
      AttrLabel(
        builder: builder,
        preferredMaxLayoutWidth: width
      )
    }
  }
}
