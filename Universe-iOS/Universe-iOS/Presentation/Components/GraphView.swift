//
//  GraphView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/12.
//

import UIKit
import UniverseKit

class GraphView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let leftScoreLabel = UILabel()
    private let rightScoreLabel = UILabel()
    private let leftScoreView = UIView()
    private let rightScoreView = UIView()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        titleLabel.font = .mediumFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.setLineHeight(lineHeightMultiple: 1.37)
        
        leftScoreLabel.font = .regularFont(ofSize: 12)
        leftScoreLabel.textAlignment = .left
        leftScoreLabel.textColor = .black
        leftScoreLabel.setLineHeight(lineHeightMultiple: 1.37)
        
        rightScoreLabel.font = .regularFont(ofSize: 12)
        rightScoreLabel.textAlignment = .right
        rightScoreLabel.textColor = .black
        rightScoreLabel.setLineHeight(lineHeightMultiple: 1.37)
        
        leftScoreView.backgroundColor = .lightGray200
        leftScoreView.layer.cornerRadius = 4
        leftScoreView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        rightScoreView.backgroundColor = .lightGray200
        rightScoreView.layer.cornerRadius = 4
        rightScoreView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    private func setLayout() {
        self.addSubviews([titleLabel, leftScoreLabel, rightScoreLabel,
                         leftScoreView, rightScoreView])
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(7)
        }
        
        leftScoreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.leading.equalToSuperview().inset(16)
        }
        
        rightScoreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalToSuperview().inset(16)
        }
        
        leftScoreView.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.height.equalTo(8)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        
        rightScoreView.snp.makeConstraints { make in
            make.leading.equalTo(leftScoreView.snp.trailing).offset(1)
            make.top.equalTo(leftScoreView.snp.top)
            make.height.equalTo(8)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
    }
    
    // MARK: - Methods
    
    private func setPercentageView(left: Double, right: Double, type: GraphType,
                                   min: Double = 0, max: Double = 100) {
        if left == 0 && right == 0 {
            return
        } else {
            if left != 0 {
                leftScoreView.backgroundColor = .subOrange
                leftScoreView.snp.remakeConstraints { make in
                    make.trailing.equalTo(self.snp.centerX)
                    make.top.equalTo(titleLabel.snp.bottom).offset(4)
                    make.height.equalTo(8)
                    make.width.equalToSuperview().multipliedBy(0.45/(max-min)*(left-min))
                }
            } else {
                leftScoreView.backgroundColor = .clear
            }
            
            if right != 0 {
                switch type {
                case .play:
                    rightScoreView.backgroundColor = .subGreen
                case .analysis:
                    rightScoreView.backgroundColor = .subBlue
                }
                rightScoreView.snp.remakeConstraints { make in
                    make.leading.equalTo(leftScoreView.snp.trailing).offset(1)
                    make.top.equalTo(leftScoreView.snp.top)
                    make.height.equalTo(8)
                    make.width.equalToSuperview().multipliedBy(0.45/(max-min)*(right-min))
                }
            } else {
                rightScoreView.backgroundColor = .clear
            }
        }
    }
    
    func setData(type: GraphType, data: GraphModel, dataType: String, min: Double = 0, max: Double = 100) {
        titleLabel.text = data.title
        leftScoreLabel.text = "\(data.leftScore)\(dataType)"
        rightScoreLabel.text = "\(data.rightScore)\(dataType)"
        setPercentageView(left: data.leftScore, right: data.rightScore, type: type, min: min, max: max)
    }
    
    func clearGraphData() {
        titleLabel.text = ""
        leftScoreLabel.text = ""
        rightScoreLabel.text = ""
        leftScoreView.backgroundColor = .lightGray200
        leftScoreView.snp.remakeConstraints { make in
            make.trailing.equalTo(self.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.height.equalTo(8)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        
        rightScoreView.backgroundColor = .lightGray200
        rightScoreView.snp.makeConstraints { make in
            make.leading.equalTo(leftScoreView.snp.trailing).offset(1)
            make.top.equalTo(leftScoreView.snp.top)
            make.height.equalTo(8)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
    }
}
