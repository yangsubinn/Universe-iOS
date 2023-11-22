//
//  QRCodeView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/10.
//

import UIKit

class QRCodeView: UIView {
    
    // MARK: - Properties
    
    private var filter = CIFilter(name: "CIQRCodeGenerator")
    
    // MARK: - UI Components
    
    private var imageView = UIImageView()
    
    // MARK: - Initilaize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        generateCode("https://www.pxscope.com/")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func generateCode(_ string: String, foregroundColor: UIColor = .black, backgroundColor: UIColor = .white) {
        
        guard let filter = filter, let data = string.data(using: .isoLatin1, allowLossyConversion: false) else { return }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        
        guard let ciImage = filter.outputImage else { return }
        
        let transformed = ciImage.transformed(by: CGAffineTransform.init(scaleX: 10, y: 10))
        
        let invertFilter = CIFilter(name: "CIColorInvert")
        invertFilter?.setValue(transformed, forKey: kCIInputImageKey)
        
        let alphaFilter = CIFilter(name: "CIMaskToAlpha")
        alphaFilter?.setValue(invertFilter?.outputImage, forKey: kCIInputImageKey)
        
        if let outputImage = alphaFilter?.outputImage {
            imageView.tintColor = foregroundColor
            imageView.backgroundColor = backgroundColor
            imageView.image = UIImage(ciImage: outputImage, scale: 2.0, orientation: .up).withRenderingMode(.alwaysTemplate)
        } else { return }
    }
}
