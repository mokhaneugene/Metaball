//
//  MetaballEffectFilter.swift
//  Metaball
//
//  Created by Eugene Mokhan on 14/09/2022.
//

import CoreImage

class MetaballEffectFilter: CIFilter {

    private struct Constants {
        static let blurRadius: Float = 30.0
    }

    private let thresholdFilter = LumaThresholdFilter()

    var blurFilter: (CIFilter & CIGaussianBlur)?

    override init() {
        super.init()
        setupBlurFilter()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // - CIFilter Subclass Properties
    @objc dynamic var inputImage : CIImage?

    override var outputImage: CIImage! {
        guard let inputImage = self.inputImage else { return nil }

        blurFilter?.inputImage = inputImage
        let blurredOutput = blurFilter?.outputImage

        thresholdFilter.inputImage = blurredOutput
        return thresholdFilter.outputImage
    }
}

private extension MetaballEffectFilter {
    // MARK: - Private methods
    func setupBlurFilter() {
        let filter = CIFilter.gaussianBlur()
        filter.radius = Constants.blurRadius
        blurFilter = filter
    }
}
