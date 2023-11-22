//
//  GraphCVC.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/12.
//

import UIKit
import UniverseKit

class GraphCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let graphView = GraphView()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        graphView.clearGraphData()
    }
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        self.addSubview(graphView)
        
        graphView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func setData(data: GraphModel, dataType: String, type: GraphType, min: Double = 0, max: Double = 100) {
        graphView.setData(type: type, data: data, dataType: dataType, min: min, max: max)
    }
}
