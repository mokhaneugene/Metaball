//
//  LumaThresholdFilter.swift
//  Metaball
//
//  Created by Eugene Mokhan on 14/09/2022.
//

import CoreImage

class LumaThresholdFilter: CIFilter {

    private struct Constants {
        static let threshold: CGFloat = 0.5
    }

    private var kernel: CIColorKernel?

    // MARK: - Initializator
    override init() {
        super.init()
        setupKernel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc dynamic var inputImage: CIImage?

    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { return nil }

        let arguments: [Any] = [inputImage, Float(Constants.threshold)]
        return kernel?.apply(extent: inputImage.extent, arguments: arguments)
    }
}

private extension LumaThresholdFilter {
    // MARK: - Private methods
    func setupKernel() {
        guard let url = Bundle.main.url(forResource: "LumaThreshold", withExtension: "ci.metallib"),
              let data = try? Data(contentsOf: url),
              let kernel = try? CIColorKernel(functionName: "lumaThreshold", fromMetalLibraryData: data) else {
            return
        }
        self.kernel = kernel
    }
}
