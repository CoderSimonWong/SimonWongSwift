//
//  AppDelegate+Config.swift
//  SimonWongSwift
//
//  Created by Admin on 2020/10/16.
//  Copyright © 2020 SimonWong. All rights reserved.
//

extension AppDelegate {
    
    func configureBases() {
        AppDelegate.configureAppearance()
        AppDelegate.configureDDLog()
        AppDelegate.configureIQKeyboardManager()
        AppDelegate.configureAdapter()
    }
    
    private static func configureAppearance() {
        // UINavigationBar
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barStyle = .default // 主题
        navigationBar.isTranslucent = false // 透明
        navigationBar.tintColor = .darkText // 按钮颜色
        navigationBar.barTintColor = nil // 背景颜色
        navigationBar.shadowImage = UIImage() // 去除分割线
        navigationBar.titleTextAttributes = [.font: UIFont.mediumSystemFont(ofSize: 17), .foregroundColor: UIColor.darkText] // 标题
        
        // UILabel
        UILabel.appearance().backgroundColor = .clear // 用于可视化测试调节颜色后还是显示透明
        // UITextField
        UITextField.appearance().tintColor = .darkText
        // UITextView
        UITextView.appearance().tintColor = .darkText
        UITextView.appearance().keyboardDismissMode = .none
        // UISwitch
        UISwitch.appearance().onTintColor = .darkText
//        UISwitch.appearance().tintColor = .disabled
        // UIScrollView
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        // UITableViewCell
        UITableViewCell.appearance().selectionStyle = .none
        UITableViewCell.appearance().accessoryType = .none
        UITableViewCell.appearance().tintColor = .darkText
    }
    
    private static func configureDDLog() {
        var logLevel: DDLogLevel = .off
        #if DEBUG
        logLevel = .verbose
        #else
        logLevel = .warning
        #endif
        if #available(iOS 10.0, *) {
            DDLog.add(DDOSLogger.sharedInstance, with: logLevel)
        } else {
            DDLog.add(DDTTYLogger.sharedInstance!, with: logLevel) // TTY - Xcode控制台
            DDLog.add(DDASLLogger.sharedInstance, with: logLevel) // ASL - Apple system logs 苹果系统日志
        }
        let fileLogger: DDFileLogger = DDFileLogger() // 本地文件日志
        fileLogger.rollingFrequency = 60 * 60 * 24 // 每24小时创建一个新的文件
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7 // 最多创建7个文件
        DDLog.add(fileLogger, with: logLevel)
    }
    
    private static func configureIQKeyboardManager() {
        let manager = IQKeyboardManager.shared
        manager.enable = true
        manager.shouldToolbarUsesTextFieldTintColor = true
        manager.placeholderFont = .systemFont(ofSize: 15)
        manager.shouldResignOnTouchOutside = true
        manager.enableAutoToolbar = false
    }
    
    private static func configureAdapter() {
        CATextLayer.useAdapter()
        UIFont.useAdapter()
        UILabel.useAdapter()
        UIButton.useAdapter()
        UITextField.useAdapter()
        UITextView.useAdapter()
    }
    
}
