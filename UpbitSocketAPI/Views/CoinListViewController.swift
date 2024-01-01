//
//  ViewController.swift
//  UpbitSocketAPI
//
//  Created by 황인호 on 12/26/23.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources

struct CoinList: Decodable {
    var coinCode: String
    var coinName: String
}

struct ListSection {
    var items: [Item]
}

extension ListSection: SectionModelType {
    typealias Item = UpbitList
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}

final class CoinListViewController: UIViewController {
    
    private let buttonView = {
        let view = UIView()
        return view
    }()
    
    private let allButton = {
        let bt = CustomSortingButton()
        bt.setTitle("  All  ", for: .normal)
        return bt
    }()
    
    private let krButton = {
        let bt = CustomSortingButton()
        bt.setTitle("  KRW  ", for: .normal)
        return bt
    }()
    
    private let btcButton = {
        let bt = CustomSortingButton()
        bt.setTitle("  BTC  ", for: .normal)
        return bt
    }()
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var tableView = {
        let view = UITableView()
        view.rowHeight = 40
        view.register(CoinListCell.self, forCellReuseIdentifier: CoinListCell.identifier)
        view.backgroundColor = .green
        view.separatorStyle = .singleLine
        return view
    }()
    
    private let viewModel = CoinListViewModel()
    
    private let disposeBag = DisposeBag()
    
    let coinTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        bind()
        coinTrigger.onNext(())
    }
    
    private func bind() {
        let input = CoinListViewModel.Input(
            networkResult: coinTrigger.asObservable(),
            krwButtonTapped: krButton.rx.tap.asObservable(),
            btcButtonTapped: btcButton.rx.tap.asObservable(),
            allButtonTapped: allButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.coinList
            .observe(on: MainScheduler.asyncInstance)
            .bind { result in
                let items = result.map { UpbitList(market: $0.market, koreanName: $0.koreanName, englishName: $0.englishName)}
                let coinSection = BehaviorSubject(value: [ListSection(items: items)])
                
                let dataSource = RxTableViewSectionedReloadDataSource<ListSection> { dataSource, tableView, indexPath, item in
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinListCell.identifier, for: indexPath) as? CoinListCell else { return UITableViewCell() }
                    cell.selectionStyle = .none
                    cell.configure(like: false, name: item.koreanName, code: item.market)
                    return cell
                }
                coinSection.bind(to: self.tableView.rx.items(dataSource: dataSource))
                    .disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
        
        output.krwCoinList
            .observe(on: MainScheduler.asyncInstance)
            .bind { result in
                self.tableView.delegate = nil
                self.tableView.dataSource = nil
                
                let items = result.map { UpbitList(market: $0.market, koreanName: $0.koreanName, englishName: $0.englishName)}
                let coinSection = BehaviorSubject(value: [ListSection(items: items)])
                
                let dataSource = RxTableViewSectionedReloadDataSource<ListSection> { dataSource, tableView, indexPath, item in
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinListCell.identifier, for: indexPath) as? CoinListCell else { return UITableViewCell() }
                    cell.selectionStyle = .none
                    cell.configure(like: false, name: item.koreanName, code: item.market)
                    return cell
                }
                coinSection.bind(to: self.tableView.rx.items(dataSource: dataSource))
                    .disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        output.btcCoinList
            .observe(on: MainScheduler.asyncInstance)
            .bind { result in
                self.tableView.delegate = nil
                self.tableView.dataSource = nil
                
                let items = result.map { UpbitList(market: $0.market, koreanName: $0.koreanName, englishName: $0.englishName)}
                let coinSection = BehaviorSubject(value: [ListSection(items: items)])
                
                let dataSource = RxTableViewSectionedReloadDataSource<ListSection> { dataSource, tableView, indexPath, item in
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinListCell.identifier, for: indexPath) as? CoinListCell else { return UITableViewCell() }
                    cell.selectionStyle = .none
                    cell.configure(like: false, name: item.koreanName, code: item.market)
                    return cell
                }
                coinSection.bind(to: self.tableView.rx.items(dataSource: dataSource))
                    .disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        output.allCoinList
            .observe(on: MainScheduler.asyncInstance)
            .bind { result in
                self.tableView.delegate = nil
                self.tableView.dataSource = nil
                
                let items = result.map { UpbitList(market: $0.market, koreanName: $0.koreanName, englishName: $0.englishName)}
                let coinSection = BehaviorSubject(value: [ListSection(items: items)])
                
                let dataSource = RxTableViewSectionedReloadDataSource<ListSection> { dataSource, tableView, indexPath, item in
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinListCell.identifier, for: indexPath) as? CoinListCell else { return UITableViewCell() }
                    cell.selectionStyle = .none
                    cell.configure(like: false, name: item.koreanName, code: item.market)
                    return cell
                }
                coinSection.bind(to: self.tableView.rx.items(dataSource: dataSource))
                    .disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
    }
    
    
    private func setUI() {
        [buttonView, stackView, tableView].forEach {
            view.addSubview($0)
        }
        
        [allButton, krButton, btcButton].forEach {
            stackView.addSubview($0)
        }
        
        buttonView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(buttonView).multipliedBy(0.8)
            make.centerY.equalTo(buttonView)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
        }
        
        allButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        krButton.snp.makeConstraints { make in
            make.leading.equalTo(allButton.snp.trailing).offset(10)
            make.height.equalToSuperview()
        }
        
        btcButton.snp.makeConstraints { make in
            make.leading.equalTo(krButton.snp.trailing).offset(10)
            make.height.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(buttonView.snp.bottom)
        }
        
    }
    
    
    
    
}

