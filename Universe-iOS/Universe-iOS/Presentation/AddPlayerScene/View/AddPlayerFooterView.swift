//
//  AddPlayerFooterView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import UIKit
import UniverseKit

class AddPlayerFooterView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    private var teamType: TeamType?
    weak var buttonDelegate: AddPlayerDelegate?
    
    // MARK: - UI Components
    
    private let addButton = CustomButton(title: I18N.Play.addPlayer, type: .normal, size: .large)
    
    // MARK: - Initialize
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
    }
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        self.addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(5)
        }
    }
    
    // MARK: - Method
    
    private func setAddTarget() {
        self.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    func setTeamType(teamType: TeamType) {
        self.teamType = teamType
    }
    
    // MARK: - @objc
    
    @objc
    private func addButtonTapped() {
        self.buttonDelegate?.addButtonTapped(teamType: self.teamType ?? .away)
    }
}
