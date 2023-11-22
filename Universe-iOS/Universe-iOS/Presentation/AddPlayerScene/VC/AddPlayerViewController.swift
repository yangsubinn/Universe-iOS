//
//  AddPlayerViewController.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import UIKit
import UniverseKit
import RxSwift
import RxRelay
import RxCocoa

class AddPlayerViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: AddPlayerViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    private var homePlayerList: [PlayerModel] = []
    private var awayPlayerList: [PlayerModel] = []
    private let refreshPlayerList = PublishSubject<Void>()
    private var isPlaying: Bool = false
    private var matchId: Int = -1
    private var duplicatedUserChecked: Bool = false
    
    // MARK: - UI Components
    
    private let naviBar = CustomNavigationBar()
    private let titleLabel = UILabel()
    private var datasource: UITableViewDiffableDataSource<TeamType, PlayerModel>!
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let startButton = CustomButton(title: I18N.Play.start, type: .disabled, size: .large)
    private let enterButton = CustomButton(title: I18N.Play.enter, type: .normal, size: .large)
    private let qrCodeView = QRCodeView()
    private let stadiumNameLabel = UILabel()
    
    // MARK: - View Life Cycles
    
    override func loadView() {
        super.loadView()
        bindViewModels()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        setRegister()
        setObservers()
        bindButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        naviBar.setNavibar(self, title: I18N.Play.startPlay, type: .withCloseButton)
        
        titleLabel.text = I18N.Play.enterPlayerInfo
        titleLabel.font = .semiBoldFont(ofSize: 18)
        titleLabel.textColor = .black
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 11
        }
        
        stadiumNameLabel.text = viewModel.stadiumName
        stadiumNameLabel.font = .boldFont(ofSize: 18)
        stadiumNameLabel.textColor = .black
    }
    
    private func setDelegate() {
        datasource = UITableViewDiffableDataSource<TeamType, PlayerModel>(tableView: self.tableView, cellProvider: { [weak self] (tableView, indexPath, _) in
            guard let self = self else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddPlayerTVC.className, for: indexPath) as? AddPlayerTVC else { return UITableViewCell() }
            switch indexPath.section {
            case 0:
                let data = self.homePlayerList[indexPath.row]
                let isMe: Bool = data.userId == UserDefaults.standard.integer(forKey: Const.UserDefaultsKey.userId)
                cell.setData(data: data, isMe: isMe)
                if self.duplicatedUserChecked && data.isPlaying {
                    cell.setDuplicatedUI()
                }
            case 1:
                let data = self.awayPlayerList[indexPath.row]
                let isMe: Bool = data.userId == UserDefaults.standard.integer(forKey: Const.UserDefaultsKey.userId)
                cell.setData(data: data, isMe: isMe)
                if self.duplicatedUserChecked && data.isPlaying {
                    cell.setDuplicatedUI()
                }
            default:
                break
            }
            return cell
        })
        
        tableView.delegate = self
        tableView.dataSource = datasource
    }
    
    private func applySnapshot(reload: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<TeamType, PlayerModel>()
        snapshot.appendSections([.home, .away])
        snapshot.appendItems(homePlayerList, toSection: .home)
        snapshot.appendItems(awayPlayerList, toSection: .away)
        
        if #available(iOS 15.0, *) {
            if reload {
                datasource.applySnapshotUsingReloadData(snapshot)
            } else {
                datasource.apply(snapshot)
            }
        } else {
            datasource.apply(snapshot)
        }
    }
    
    private func setRegister() {
        tableView.register(AddPlayerTVC.self, forCellReuseIdentifier: AddPlayerTVC.className)
        tableView.register(AddPlayerHeaderView.self, forHeaderFooterViewReuseIdentifier: AddPlayerHeaderView.className)
        tableView.register(AddPlayerFooterView.self, forHeaderFooterViewReuseIdentifier: AddPlayerFooterView.className)
    }
    
    private func setLayout() {
        self.view.addSubviews([naviBar, titleLabel, tableView])
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(naviBar.snp.bottom).offset(11)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    private func setButtonLayout(isPlaying: Bool) {
        self.view.addSubview(isPlaying ? enterButton : startButton)
        
        (isPlaying ? enterButton : startButton).snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(34)
        }
    }
    
    private func setQRLayout() {
        self.view.addSubviews([qrCodeView, stadiumNameLabel])
        
        qrCodeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.width.height.equalTo(200)
        }
        
        stadiumNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(qrCodeView.snp.bottom).offset(16)
        }
    }
    
    // MARK: - Methods
    
    private func renewPlayerList(reload: Bool = false) {
        self.refreshPlayerList.onNext(())
        self.applySnapshot()
        self.applySnapshot(reload: reload)
        self.startButton.changeState((homePlayerList.count == awayPlayerList.count) ? .abled : .disabled)
    }
    
    private func setObservers() {
        self.addObserverAction(.dismissPlayerList) { [weak self] noti in
            guard let self = self else { return }
            let userInfo = noti.userInfo
            let team = userInfo?["team"]
            let userId = userInfo?["userId"]
            self.viewModel.changeOriginList(id: userId as! Int, isSelected: true, team: team as? TeamType)
            self.renewPlayerList()
        }
    }
    
    private func removeObservers() {
        removeObserverAction(.dismissPlayerList)
        removeObserverAction(.presentPlayVC)
    }
    
    private func bindButton() {
        enterButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.dismiss(animated: true) {
                    let userInfo = ["matchId": owner.matchId,
                                    "matchInfo": owner.viewModel.matchInfoModel as Any,
                                    "matchScore": owner.viewModel.matchScoreModel as Any]
                    owner.postObserverAction(.presentPlayVC,
                                             userInfo: userInfo)
                }
            }.disposed(by: self.disposeBag)
        
        qrCodeView.onTap { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                let userInfo = ["matchId": self.matchId,
                                "matchInfo": self.viewModel.matchInfoModel as Any,
                                "matchScore": self.viewModel.matchScoreModel as Any]
                self.postObserverAction(.presentPlayVC,
                                        userInfo: userInfo)
            }
        }
    }
    
    private func bindViewModels() {
        let input = AddPlayerViewModel.Input(
            viewDidLoadEvent: self.rx.methodInvoked(#selector(UIViewController.viewDidLoad)).map { _ in },
            refreshPlayerList: refreshPlayerList.asObservable(),
            tappedStartButton: startButton.rx.tap
                .withUnretained(self)
                .map({ owner, _ in
                    owner.duplicatedUserChecked = true
                    var playerIdList = [owner.homePlayerList[0].userId, owner.awayPlayerList[0].userId]
                    if owner.homePlayerList.count > 1 {
                        playerIdList.append(owner.homePlayerList[1].userId)
                        playerIdList.append(owner.awayPlayerList[1].userId)
                    }
                    return MatchStartRequestModel(
                        stadiumId: owner.viewModel.stadiumId ?? -1,
                        courtNumber: 1,
                        playerIdList: playerIdList)
                }).asObservable())
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.isPlaying
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, isPlaying in
                owner.isPlaying = isPlaying
                owner.setButtonLayout(isPlaying: isPlaying)
                owner.applySnapshot()
            }.disposed(by: self.disposeBag)
        
        output.playerList
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, players in
                owner.homePlayerList = players[0]
                owner.awayPlayerList = players[1]
                owner.applySnapshot()
            }.disposed(by: self.disposeBag)
        
        output.matchId
            .withUnretained(self)
            .subscribe { owner, id in
                owner.matchId = id
                if !owner.isPlaying {
                    owner.changeToQRView()
                }
            }.disposed(by: self.disposeBag)
        
        output.hasDuplicatedUser
            .withUnretained(self)
            .subscribe { owner, hasUser in
                if hasUser {
                    owner.showToast(message: I18N.Play.alreadyPlaying, bottom: 100)
                    owner.renewPlayerList(reload: true)
                }
            }.disposed(by: self.disposeBag)
        
        output.error
            .compactMap { $0 as? APIError }
            .withUnretained(self)
            .subscribe { owner, error in
                if owner.isPlaying {
                    owner.showNetworkAlert { _ in
                        owner.dismiss(animated: true)
                    }
                } else {
                    owner.showErrorAlert(errortype: error)
                }
            }.disposed(by: self.disposeBag)
    }
    
    private func changeToQRView() {
        self.naviBar.setTitle(I18N.Play.QR)
        
        self.titleLabel.removeFromSuperview()
        self.startButton.removeFromSuperview()
        self.tableView.removeFromSuperview()
        self.setQRLayout()
    }
}

extension AddPlayerViewController: AddPlayerDelegate {
    func addButtonTapped(teamType: TeamType) {
        let playerListVC = moduleFactory.makePlayerListVC(list: viewModel.originPlayerList, teamType: teamType)
        let bottomSheet = moduleFactory.makeBottomSheetVC(contentVC: playerListVC)
        playerListVC.bottomSheetDelegate = bottomSheet
        self.present(bottomSheet, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension AddPlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AddPlayerHeaderView.className) as? AddPlayerHeaderView else { return UITableViewHeaderFooterView() }
        switch section {
        case 0:
            headerView.setHeaderData(title: I18N.Play.home)
        case 1:
            headerView.setHeaderData(title: I18N.Play.away)
        default:
            break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AddPlayerFooterView.className) as? AddPlayerFooterView else { return UITableViewHeaderFooterView() }
        footerView.setTeamType(teamType: (section == 0) ? .home : .away)
        footerView.buttonDelegate = self
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isPlaying { return 0 }
        switch section {
        case 0:
            if homePlayerList.count >= 2 { return 0 }
        case 1:
            if awayPlayerList.count >= 2 { return 0 }
        default:
            break
        }
        return 72
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (indexPath.section == 0 && indexPath.row == 0) || isPlaying {
            return UISwipeActionsConfiguration()
        } else {
            let delete = UIContextualAction(style: .destructive, title: I18N.Play.delete) { [weak self] (_, _, _) in
                guard let self = self else { return }
                switch indexPath.section {
                case 0:
                    self.viewModel.changeOriginList(id: self.homePlayerList[indexPath.row].userId, isSelected: false, team: .none)
                case 1:
                    self.viewModel.changeOriginList(id: self.awayPlayerList[indexPath.row].userId, isSelected: false, team: .none)
                default:
                    break
                }
                
                self.renewPlayerList()
            }
            delete.backgroundColor = .red
            
            return UISwipeActionsConfiguration(actions: [delete])
        }
    }
}
