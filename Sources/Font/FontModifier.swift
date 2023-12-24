import TextFontDescriptor
import SwiftUI
import Combine

public extension View {
  @ViewBuilder
  func fontDescriptor(_ descriptor: TextFontDescriptor) -> some View {
    ModifiedContent(content: self, modifier: FontModifier(descriptor: descriptor))
  }
}

struct FontModifier: ViewModifier {
  let descriptor: TextFontDescriptor
  @State private var font: Font

  init(descriptor: TextFontDescriptor) {
    self.descriptor = descriptor
    self.font = .init(descriptor.nativeFont)
  }

  func body(content: Content) -> some View {
    content
      .font(font)
      .onReceive(
        AppFont.updatedFontPublisher {
          descriptor
        },
        perform: { value in
          font = .init(value)
        }
      )
  }
}
