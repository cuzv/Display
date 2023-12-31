//  Created by Shaw on 12/31/23.

import AsyncDisplayKit
import Kingfisher

public final class NetworkImageNode: ASNetworkImageNode {
  public init() {
    super.init(cache: KFImageManager.shared, downloader: KFImageManager.shared)
  }
}

class KFImageManager: NSObject {
  static let shared = KFImageManager()
  let downloader = ImageDownloader(name: "KFImageManager")
  let cache = ImageCache(name: "KFImageManager")
  override private init() {}
}

// MARK: - ASImageDownloaderProtocol

extension KFImageManager: ASImageDownloaderProtocol {
  func downloadImage(
    with url: URL,
    shouldRetry _: Bool,
    callbackQueue: DispatchQueue,
    downloadProgress: ASImageDownloaderProgress?,
    completion: @escaping ASImageDownloaderCompletion
  ) -> Any? {
    downloader.downloadImage(
      with: url,
      options: [.callbackQueue(.untouch), .backgroundDecode],
      progressBlock: { received, expected in
        if let downloadProgress {
          callbackQueue.async {
            let progress = expected == 0 ? 0 : received / expected
            downloadProgress(CGFloat(progress))
          }
        }
      },
      completionHandler: { (result: Result<ImageLoadingResult, KingfisherError>) in
        if let loadingResult = result.success {
          callbackQueue.async {
            completion(
              loadingResult.image,
              result.failure,
              nil,
              loadingResult.url
            )
            self.cache.store(
              loadingResult.image,
              original: loadingResult.originalData,
              forKey: url.cacheKey,
              toDisk: true
            )
          }
        }
      }
    )
  }

  func cancelImageDownload(forIdentifier downloadIdentifier: Any) {
    if let task = downloadIdentifier as? DownloadTask {
      task.cancel()
    }
  }
}

// MARK: - ASImageCacheProtocol

extension KFImageManager: ASImageCacheProtocol {
  func cachedImage(
    with url: URL,
    callbackQueue: DispatchQueue,
    completion: @escaping ASImageCacherCompletion
  ) {
    cache.retrieveImage(forKey: url.cacheKey) { (result: Result<ImageCacheResult, KingfisherError>) in
      callbackQueue.async {
        completion(result.success?.image, .asynchronous)
      }
    }
  }

  func synchronouslyFetchedCachedImage(with url: URL) -> ASImageContainerProtocol? {
    KingfisherContainer(url: url)
  }

  func clearFetchedImageFromCache(with url: URL) {
    cache.removeImage(forKey: url.cacheKey, fromMemory: true, fromDisk: false)
  }
}

// MARK: - ASImageContainerProtocol

final class KingfisherContainer: NSObject, ASImageContainerProtocol {
  var image: UIImage?

  init(url: URL) {
    super.init()
    image = KFImageManager.shared.cache.retrieveImageInMemoryCache(forKey: url.cacheKey)
  }

  func asdk_image() -> UIImage? {
    image
  }

  func asdk_animatedImageData() -> Data? {
    nil
  }
}
