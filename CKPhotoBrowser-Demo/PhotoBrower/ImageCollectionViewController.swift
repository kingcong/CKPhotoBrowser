//
//  ImageCollectionViewController.swift
//  PhotoBrower
//
//  Created by kingcong on 2019/1/29.
//  Copyright © 2019 ustc. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "CellID"

class ImageCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView? = nil
    
//    let urlstrs = ["http://wx2.sinaimg.cn/bmiddle/8c803935ly1fzkxv3ljk6j20j10wfjxo.jpg",
//                   "http://wx1.sinaimg.cn/bmiddle/8c803935ly1fzkxvlqk2sj20j20bv40t.jpg",
//                   "http://wx3.sinaimg.cn/bmiddle/8c803935ly1fzkxvlh6xwj20fa05wq4n.jpg",
//                   "http://wx3.sinaimg.cn/bmiddle/8c803935ly1fzky5m8ok9j20ku0uwdl9.jpg",
//                   "http://wx4.sinaimg.cn/bmiddle/8c803935ly1fzky39r20fj20ro04z0tf.jpg"]
    

    let urlstrs = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548786775868&di=10de54f5f5131d08b0eb8076c8a50866&imgtype=0&src=http%3A%2F%2Fk1.jsqq.net%2Fuploads%2Fallimg%2F160609%2F5_160609154717_1.jpg",
                   "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548786775866&di=332e61b5f2c8f92032f2490e228946e5&imgtype=0&src=http%3A%2F%2Fpic23.nipic.com%2F20120824%2F7103350_125929483000_2.jpg",
                   "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548786775899&di=ada04b320c85440f8cfc9b0378837564&imgtype=0&src=http%3A%2F%2Fimg0.ph.126.net%2FhR270vvvXfhUZeZPhJRC6Q%3D%3D%2F2174957145143848911.jpg",
                   "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548786775896&di=9ebd32e40c1873ffb66070d9e309b531&imgtype=0&src=http%3A%2F%2Fimg7.ph.126.net%2FEj4xnq--jFh47qu0_1ZgJA%3D%3D%2F670191919565447477.jpg",
                   "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548786775895&di=64370e02636e1ca8c2973b8199516efe&imgtype=0&src=http%3A%2F%2Fs4.sinaimg.cn%2Fmw690%2F006PhMfPzy7cMuwsFZV03%26690",
                   "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548786912610&di=8a9267b7955afd6680d28aa62c0af833&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201503%2F07%2F20150307162725_tPhuj.thumb.700_0.jpeg",
                   "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548786912608&di=72a0b645bc291097a0b75d0568ef8ace&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201409%2F11%2F20140911164043_GiU2i.thumb.700_0.jpeg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        
        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.view.addSubview(collectionView!)
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.urlstrs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        if cell == nil {
            cell = UICollectionViewCell()
        }
        
        cell.backgroundColor = armColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.contentMode = .scaleAspectFit
        cell.contentView.addSubview(imageView)
        cell.tag = indexPath.item
        imageView.sd_setImage(with: URL(string: self.urlstrs[indexPath.item]), completed: nil)
    
        return cell
    }


    func armColor()->UIColor{
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var datas: [PhotoBrowerData] = []
        var index: Int = 0
        
        for url in urlstrs {
            let imageView = collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.contentView.subviews.first as! UIImageView
            let data: PhotoBrowerData = PhotoBrowerData(url: url, sourceObject: imageView)
            datas.append(data)
            index = index+1
        }
        
        let photoBrowerVc = PhotoBrowserController(currentIndex: indexPath.item, datasourceArray: datas)
        photoBrowerVc.show()

    }
}
