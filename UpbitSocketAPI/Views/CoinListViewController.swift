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
        let input = CoinListViewModel.Input(networkResult: coinTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.coinList.observe(on: MainScheduler.asyncInstance).bind { result in
            let items = result.map { UpbitList(market: $0.market, koreanName: $0.koreanName, englishName: $0.englishName)}
            var coinSection = BehaviorSubject(value: [ListSection(items: items)])
            
            let dataSource = RxTableViewSectionedReloadDataSource<ListSection> { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinListCell.identifier, for: indexPath) as? CoinListCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.configure(like: false, name: item.koreanName, code: item.market)
                return cell
            }
            
            coinSection.bind(to: self.tableView.rx.items(dataSource: dataSource))
                .disposed(by: self.disposeBag)
        }
        .disposed(by: disposeBag)
    }
    
    
    private func setUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    
    
    
}

