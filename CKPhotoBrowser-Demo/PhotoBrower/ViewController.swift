//
//  ViewController.swift
//  PhotoBrower
//
//  Created by kingcong on 2019/1/28.
//  Copyright © 2019 ustc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    @IBOutlet weak var imageView: UIImageView!
    
    let urlstrs = ["http://wx2.sinaimg.cn/bmiddle/8c803935ly1fzkxv3ljk6j20j10wfjxo.jpg",
                "http://wx1.sinaimg.cn/bmiddle/8c803935ly1fzkxvlqk2sj20j20bv40t.jpg",
                "http://wx3.sinaimg.cn/bmiddle/8c803935ly1fzkxvlh6xwj20fa05wq4n.jpg",
                "http://wx3.sinaimg.cn/bmiddle/8c803935ly1fzky5m8ok9j20ku0uwdl9.jpg",
                "http://wx4.sinaimg.cn/bmiddle/8c803935ly1fzky39r20fj20ro04z0tf.jpg"]
    
    var urls: Array<NSURL> = []
    
    var sourceImageViews: Array<UIImageView> = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for urlstr in urlstrs {
            let url: NSURL = NSURL(string: urlstr)!
            urls.append(url)
            sourceImageViews.append(imageView)
        }
    }

    @IBAction func btnClick(_ sender: Any) {
        
        var datas: [PhotoBrowerData] = []
        var index = 0
        for url in urlstrs {
            let data: PhotoBrowerData = PhotoBrowerData()
            data.url = url
            data.sourceObject = sourceImageViews[index]
            datas.append(data)
            index = index+1
        }
        
        let photoBrowerVc = PhotoBrowserController(currentIndex: 0, datasourceArray: datas)
        photoBrowerVc.show()
    }
    
}


