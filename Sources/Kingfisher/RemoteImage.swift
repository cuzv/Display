//  Created by Shaw on 12/28/23.

import SwiftUI
import Kingfisher

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, macCatalyst 14.0, *)
public struct RemoteImage<Placeholder>: View where Placeholder: View {
  let source: Source?
  let size: CGSize
  let cornerRadius: CGFloat
  let placeholder: () -> Placeholder

  @State private var currentImage: UIImage?

  public init(
    url: URL?,
    size: CGSize,
    cornerRadius: CGFloat? = nil,
    placeholder: @escaping () -> Placeholder
  ) {
    self.init(
      source: url.flatMap(Source.network),
      size: size,
      cornerRadius: cornerRadius,
      placeholder: placeholder
    )
  }

  public init(
    url: URL?,
    size: CGSize,
    cornerRadius: CGFloat? = nil
  ) where Placeholder == EmptyView {
    self.init(url: url, size: size, cornerRadius: cornerRadius) {
      EmptyView()
    }
  }

  public init(
    source: Source?,
    size: CGSize,
    cornerRadius: CGFloat? = nil,
    placeholder: @escaping () -> Placeholder
  ) {
    self.source = source
    self.size = size
    self.cornerRadius = cornerRadius ?? 0
    self.placeholder = placeholder
  }

  public var body: some View {
    KFImage(source: source)
      .onSuccess { result in
        currentImage = result.image
      }
      .placeholder {
        if let currentImage {
          Image(uiImage: currentImage)
            .resizable()
        } else {
          placeholder()
        }
      }
      .loadDiskFileSynchronously()
      .callbackQueue(.untouch)
      .backgroundDecode()
      .fade(duration: 0.25)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: size.width, height: size.height)
      .cornerRadius(cornerRadius)
  }
}
