//
//  SearchVC.swift
//  SearchTest
//
//  Created by Jo JANGHUI on 2018. 9. 11..
//  Copyright © 2018년 JhDAT. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    let get = GetService()
    let userDefault = UserDefaults.standard
    let color = UIColor(red: 0.314, green: 0.227, blue: 0.710, alpha: 1)
    lazy var notResultView = NotResultV(frame: self.tableView.frame)
    
    var replacingText: String = ""
    var searchList: [String] = [] {
        didSet {
            userDefault.set(searchList, forKey: "searchList")
        }
    }
    var resultArr: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var removeTextField: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    @IBAction func actionSearch(_ sender: UIButton) {
        addSearchList()
    }
    
    @IBAction func textFieldClearButton(_ sender: UIButton) {
        notResultView.label.text = "검색어를 입력하세요"
        replacingText = ""
        textField.text = nil
        resultArr = searchList
        textField.endEditing(true)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(notResultView)
        appCacheLoad()
        
        textField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func appCacheLoad() {
        if userDefault.array(forKey: "searchList") == nil {
            userDefault.set(resultArr, forKey: "searchList")
            notResultView.isHidden = false
        } else {
            searchList = userDefault.array(forKey: "searchList") as! [String]
            resultArr = searchList
            notResultView.isHidden = true
        }
    }
    
    func addSearchList () {
        textField.endEditing(true)
        guard let text = textField.text, text != "" else { return }
        if searchList.count >= 20 {
            searchList.removeLast()
        }
        searchList = searchList.filter { $0 != text }
        searchList.insert(text, at: 0)
    }
}

// MARK: - UITableViewDataSource
extension SearchVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            if resultArr.isEmpty {
                notResultView.isHidden = false
            } else {
                notResultView.isHidden = true
            }
            
            let resultLabel = notResultView.label
            if resultArr.isEmpty, replacingText == "" {
                resultLabel.text = "검색어를 입력하세요"
            } else if resultArr.isEmpty {
                resultLabel.text = "검색결과를 찾을수가\n없습니다."
            }
            return resultArr.count
        }
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if replacingText == "" || textField.text == "" {
                tableView.rowHeight = 12
            } else {
                tableView.rowHeight = 0
            }
            let reCell = tableView.dequeueReusableCell(withIdentifier: "searchHistory",
                                                       for: indexPath)
            if let textlabel = reCell.textLabel {
                textlabel.text = "Search History"
                textlabel.textColor = UIColor.gray
                textlabel.font = UIFont(name: "Helvetica Neue", size: 12)
            }
            return reCell
        default:
            tableView.rowHeight = 50
            let reCell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell",
                                                       for: indexPath) as! SearchResultTVC
            let title = resultArr[indexPath.row]
            
            if replacingText == "" {
                reCell.titleLabel.text = title
                reCell.titleLabel.textColor = .black
                reCell.delegate = self
                reCell.indexpath = indexPath
                reCell.statusButton.setImage(UIImage(named: "CancelImg"), for: .normal)
                reCell.statusButton.setTitle("\(indexPath.row)", for: .normal)
            } else {
                let attributedString = NSMutableAttributedString(string: title)
                let range: NSRange = attributedString.mutableString.range(of: replacingText,
                                                                          options: .caseInsensitive)
                
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                              value: color,
                                              range: range)
                reCell.titleLabel.attributedText = attributedString
                
                reCell.statusButton.setImage(UIImage(named: "CheckMarkImg"), for: .normal)
                reCell.statusButton.setTitle("normal", for: .normal)
                reCell.selectionStyle = UITableViewCellSelectionStyle.none
            }
            return reCell
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        default:
            if textField.text == "" {
                textField.text = searchList[indexPath.row]
                replacingText = textField.text!
                get.search(words: textField.text!) { [weak self] (result) in
                    guard let strongSelf = self else { return }
                    guard let relatedQuerty = result[1].relatedQuery else { return }
                    strongSelf.resultArr = relatedQuerty
                    strongSelf.textField.endEditing(true)
                }
                return
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SearchVC: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        replacingText = (text as NSString).replacingCharacters(in: range, with: string)
        if replacingText == "" {
            resultArr = searchList
        } else {
            notResultView.isHidden = true
            get.search(words: replacingText) { [weak self] (result) in
                guard let strongSelf = self else { return }
                guard let relatedQuerty = result[1].relatedQuery else { return }
                strongSelf.resultArr = relatedQuerty
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addSearchList()
        return true
    }
}

// MARK: - SearchResultTVCDelegate
extension SearchVC: SearchResultTVCDelegate {
    func actionCancelButton(_ indexpath: IndexPath) {
        resultArr.remove(at: indexpath.row)
        searchList.remove(at: indexpath.row)
    }
}
