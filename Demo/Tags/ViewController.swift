//
//  ViewController.swift
//  TagsView
//
//  Created by 聂小波 on 2023/5/18.
//

import UIKit
import Foundation
import SnapKit

class BTagCollectionViewCell: UICollectionViewCell {
  
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .orange
        contentView.addSubview(tagLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(text: String) -> Void {
        tagLabel.text = text
        tagLabel.snp.remakeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }

    class func getTagItemSize(text: String) -> CGSize {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 22)
//        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let size = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil)
        return CGSize(width: min(size.width + 10, UIScreen.main.bounds.size.width - 50), height: size.height + 10)
    }
}

class BTagsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewLeftAlignedLayout()
        layout.minimumInteritemSpacing = 6.0
        layout.minimumLineSpacing = 6.0
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.delegate = self
        view.dataSource = self
        view.isUserInteractionEnabled = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        view.register(BTagCollectionViewCell.self, forCellWithReuseIdentifier: "BTagCollectionViewCell")
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    var datas = Array<String>() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() -> Void {
        backgroundColor = .white
        collectionView.backgroundColor = .white
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BTagCollectionViewCell", for: indexPath) as! BTagCollectionViewCell
        cell.setupData(text: datas[indexPath.row])
        cell.contentView.sizeToFit()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        BTagCollectionViewCell.getTagItemSize(text: datas[indexPath.row])
    }
    
}

class BTagsUITableViewCell: UITableViewCell {
    lazy var tagsView: BTagsView = {
        return BTagsView()
    }()
    
    var datas = Array<String>() {
        didSet {
            tagsView.datas = datas
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        tagsView.collectionView.setNeedsLayout()
        tagsView.collectionView.layoutIfNeeded()
        let height = tagsView.collectionView.collectionViewLayout.collectionViewContentSize.height
        return CGSize(width: size.width, height: height + size.height)
    }
    
    func setupSubViews() -> Void {
        contentView.backgroundColor = .white
        contentView.addSubview(tagsView)
        tagsView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
}

class ViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    var tableView : UITableView!
    static let cellId = "BTagsUITableViewCell"
    let dataSource = [
        ["北京北京北京","上海上海上海","广州","深圳深","杭州","成都","天津"],
        ["重庆","武汉","贵阳贵阳贵阳贵阳","郑州","济南","西安","合肥","南京","南宁","太原","昆明","福州"],
        ["宁波","青岛","众所周知，iOS设备已良好的用户体验赢得了广大的用户群。iOS系统在用户点击屏幕会立即做出响应。而且很大一部分的操作是来自于用户的滑动操作。所以滑动的顺滑是使用户沉浸在app中享受的必要条件。接下来我们就谈谈iOS 10 中增加了那些新特性。","珠海","厦门","上海","烟台"],
        ["金堂","金牛","内江","高新阳贵阳贵","合肥","合肥","合肥"],
        ["合肥","合肥","合肥阳贵阳贵阳贵阳贵","昆明阳贵阳贵","昆明","昆明","昆明","昆明","昆明","昆明","昆明","昆明","昆明"],
        ["宁波","青岛","众所周知，iOS设备已良好的用户体验赢得了广大的用户群。iOS系统在用户点击屏幕会立即做出响应。而且很大一部分的操作是来自于用户的滑动操作。所以滑动的顺滑是使用户沉浸在app中享受的必要条件。接下来我们就谈谈iOS 10 中增加了那些新特性。","珠海","厦门","上海","烟台"],
        ["金堂","金牛","内江","高新阳贵阳贵","合肥","合肥","合肥"],
        ["合肥","合肥","合肥阳贵阳贵阳贵阳贵","昆明阳贵阳贵","昆明","昆明","昆明","昆明","昆明","昆明","昆明","昆明","昆明"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 30.0
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        view.addSubview(tableView)
        //cell注册
        tableView.register(BTagsUITableViewCell.self, forCellReuseIdentifier: ViewController.cellId)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 30))
        titleLabel.text = "Section \(section)"
        titleLabel.backgroundColor = .lightGray
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellId, for: indexPath) as! BTagsUITableViewCell
        cell.datas = dataSource[indexPath.section]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }

}

