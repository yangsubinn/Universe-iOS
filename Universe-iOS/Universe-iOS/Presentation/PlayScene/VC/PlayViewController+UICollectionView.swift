//
//  PlayViewController+UICollectionView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/02/20.
//

import UIKit

// MARK: - UICollectionViewDelegate

extension PlayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width
        var height = 42.0
        
        if !isDefaultTap {
            if section != 0 {
                height = 39
            }
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if isDefaultTap {
            return UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0)
        }
        
        if section != 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        } else {
            return UIEdgeInsets()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width
        var height = 50.0
        
        if isDefaultTap {
            if indexPath.section == 0 {
                height = 40
                if indexPath.row > 3 { width -= 32}
            } else {
                height = 80
            }
        }
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectioinViewDataSource

extension PlayViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isDefaultTap {
            return gameCount == 0 ? 1 : 2
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if isDefaultTap {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.className, for: indexPath) as? TitleHeaderView else { return UICollectionReusableView() }
            header.setTitle(title: viewModel.titleHeaderList[indexPath.section])
            return header
        } else {
            if indexPath.section == 0 {
                guard let titleHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.className, for: indexPath) as? TitleHeaderView else { return UICollectionReusableView() }
                titleHeader.setTitle(title: I18N.Analysis.scoreInfo)
                return titleHeader
            } else {
                guard let subHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SubtitleHeaderView.className, for: indexPath) as? SubtitleHeaderView else { return UICollectionReusableView() }
                subHeader.setTitle(title: viewModel.subTitleHeaderList[indexPath.section - 1])
                return subHeader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isDefaultTap {
            switch section {
            case 0:
                return 6
            default:
                return 4
            }
        } else {
            switch section {
            case 1:
                return 2
            case 2:
                return 7
            case 3:
                return 1
            default:
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isDefaultTap {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0...1:
                    guard let graphCell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: GraphCVC.className, for: indexPath) as? GraphCVC else { return UICollectionViewCell() }
                    if !playBasicGraphInfo.isEmpty {
                        graphCell.setData(data: playBasicGraphInfo[indexPath.row],
                                          dataType: "점", type: .play, min: 0, max: 60)
                    } else {
                        graphCell.setData(data: GraphModel(title: viewModel.defaultGraphList[indexPath.row], leftScore: 0, rightScore: 0),
                                          dataType: "점", type: .play, min: 0, max: 60)
                    }
                    return graphCell
                case 2...3:
                    guard let graphCell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: GraphCVC.className, for: indexPath) as? GraphCVC else { return UICollectionViewCell() }
                    if !playBasicGraphInfo.isEmpty {
                        graphCell.setData(data: playBasicGraphInfo[indexPath.row],
                                          dataType: "km/h", type: .play, min: 200, max: 300)
                    } else {
                        graphCell.setData(data: GraphModel(title: viewModel.defaultGraphList[indexPath.row], leftScore: 0, rightScore: 0),
                                          dataType: "km/h", type: .play, min: 200, max: 300)
                    }
                    return graphCell
                case 4:
                    guard let defaultCell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: DefaultCVC.className, for: indexPath) as? DefaultCVC else { return UICollectionViewCell() }
                    if playBasicInfo != nil {
                        defaultCell.setData(content: viewModel.defaultList[0], score: playBasicInfo?.longestRallyTime ?? "00:00:00", unit: "")
                    } else {
                        defaultCell.setData(content: viewModel.defaultList[0], score: "00:00:00", unit: "")
                    }
                    
                    return defaultCell
                case 5:
                    guard let defaultCell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: DefaultCVC.className, for: indexPath) as? DefaultCVC else { return UICollectionViewCell() }
                    if playBasicInfo != nil {
                        defaultCell.setData(content: viewModel.defaultList[1], score: playBasicInfo?.averageRallyTime ?? "00:00:00", unit: "")
                    } else {
                        defaultCell.setData(content: viewModel.defaultList[1], score: "00:00:00", unit: "")
                    }
                    return defaultCell
                default:
                    return UICollectionViewCell()
                }
            } else {
                guard let diagnosisCell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: DiagnosisCVC.className, for: indexPath) as? DiagnosisCVC else { return UICollectionViewCell() }
                diagnosisCell.setData(icon: viewModel.diagnosisList[indexPath.row].icon,
                                      title: viewModel.diagnosisList[indexPath.row].title,
                                      description: viewModel.diagnosisList[indexPath.row].description)
                return diagnosisCell
            }
        } else {
            guard let graphCell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: GraphCVC.className, for: indexPath) as? GraphCVC else { return UICollectionViewCell() }
            if !(playScoreInfo[0].isEmpty) {
                graphCell.setData(data: playScoreInfo[indexPath.section-1][indexPath.row],
                                  dataType: "%", type: .play)
            } else {
                graphCell.setData(data: GraphModel(title: viewModel.scoreAnalysisList[indexPath.section-1][indexPath.row], leftScore: 0, rightScore: 0),
                                  dataType: "%", type: .play)
            }
            return graphCell
        }
    }
}
