//
//  SMScrollExampleSubviewController.swift
//  SimonWongSwift
//
//  Created by SimonWong on 2020/10/19.
//  Copyright © 2020 SimonWong. All rights reserved.
//

import UIKit

class SMScrollExampleSubviewController: BasePlainTableViewController, UITableViewDataSource, UITableViewDelegate {

    var index: Int = 0
    
    private var pageController: SMScrollExamplePageController!
    private var canScroll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageController = wm_pageController as? SMScrollExamplePageController
        configureTableView()
    }
    
    override func configureTableView() {
        super.configureTableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            print("navigationController?.navigationBar.height ?? 0: \(navigationController?.navigationBar.height ?? 0)")
            print("self.view.safeAreaInsets.bottom: \(self.view.safeAreaInsets.bottom)")
            make.height.equalTo(UIScreenHeight - 88 - SMScrollExamplePageController.menuViewHeight - self.view.safeAreaInsets.bottom)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func register() {
        _ = NotificationCenter.default.rx.notification(SMScrollExampleNotification.didScrollToTop)
            .take(until: self.rx.deallocated)
            .subscribe(onNext: { [weak self] (notification) in
                guard let ws = self else { return }
                let object = notification.object
                if object as? SMScrollExamplePageController != ws.pageController { return }
                guard let userInfo = notification.userInfo else { return }
                let canScroll: Bool = userInfo["canScroll"] as! Bool
                if canScroll {
                    ws.canScroll = canScroll
                    let vc = ws.pageController.currentViewController
                    if vc != self { return }
                    ws.tableView.showsVerticalScrollIndicator = true
                    let offsetY = userInfo["offsetY"] as! CGFloat
                    if ws.tableView.contentOffset.y < ws.tableView.contentSize.height - ws.tableView.height {
                        let newOffsetY = ws.tableView.contentOffset.y + offsetY
                        ws.tableView.contentOffset = CGPoint(x: .zero, y: newOffsetY)
                    }
                }
            })
        _ = NotificationCenter.default.rx.notification(SMScrollExampleNotification.didLeaveTheTop).take(until: self.rx.deallocated).subscribe(onNext: { [weak self] (notification) in
            guard let ws = self else { return }
            let object = notification.object
            if object as? SMScrollExamplePageController != ws.pageController { return }
            ws.canScroll = false
            ws.tableView.showsVerticalScrollIndicator = false
            ws.tableView.contentOffset = .zero
        })
        _ = NotificationCenter.default.rx.notification(SMScrollExampleNotification.forceAllScrollToTop).take(until: self.rx.deallocated).subscribe(onNext: { [weak self] (notification) in
            guard let ws = self else { return }
            let object = notification.object
            if object as? SMScrollExamplePageController != ws.pageController { return }
            ws.canScroll = false
            ws.tableView.contentOffset = .zero
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !canScroll {
            tableView.contentOffset = .zero
        }
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            NotificationCenter.default.post(name: SMScrollExampleNotification.didLeaveTheTop, object: pageController, userInfo: ["canScroll": true])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.reuseIdentifier) as? BaseTableViewCell
        if cell == nil {
            cell = BaseTableViewCell(style: .value1, reuseIdentifier: BaseTableViewCell.reuseIdentifier)
        }
        cell?.backgroundColor = CGFloat(indexPath.row).remainder(dividingBy: 2) == 0 ? UIColor.red.withAlphaComponent(0.3) : UIColor.blue.withAlphaComponent(0.3)
        cell?.textLabel?.text = "\(pageController.menuView!.dataSource.menuView(pageController.menuView, titleAt: index)!)_\(indexPath.row)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}