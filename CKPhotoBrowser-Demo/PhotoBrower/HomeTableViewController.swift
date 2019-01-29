//
//  HomeTableViewController.swift
//  PhotoBrower
//
//  Created by kingcong on 2019/1/29.
//  Copyright © 2019 ustc. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    let imageArray: [String] = ["MoreExpressionShops","MoreMyFavorites"]
    let titleArray: [String] = ["加载网络图片","加载本地图片"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:"homeID")
        tableView.rowHeight = 60
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        tableView.tableFooterView = UIView()
        
        self.title = "CWPhotoBrowser Demo"
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.titleArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "homeID", for: indexPath)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "homeID")
        }
        
        // Configure the cell...
        cell.imageView?.image = UIImage(named: self.imageArray[indexPath.row])
        cell.textLabel?.text = self.titleArray[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let imageVc = ImageCollectionViewController()
            imageVc.navigationItem.title = self.titleArray[indexPath.row]
            self.navigationController?.pushViewController(imageVc, animated: true)
        } else if indexPath.row == 1{
            let imageVc = LocalImageCollectionViewController()
            imageVc.navigationItem.title = self.titleArray[indexPath.row]
            self.navigationController?.pushViewController(imageVc, animated: true)
        }
    }
}
