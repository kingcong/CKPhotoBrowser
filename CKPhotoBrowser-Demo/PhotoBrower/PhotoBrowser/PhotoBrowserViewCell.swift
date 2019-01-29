//
//  PhotoBrowerViewCell.swift
//  PhotoBrower
//
//  Created by kingcong on 2019/1/29.
//  Copyright © 2019 ustc. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserViewCellDelegate : NSObjectProtocol {
    func imageViewClick()
    func imageViewLongPress()
}

class PhotoBrowserViewCell: UICollectionViewCell {
    // MARK:- 定义属性
    var data: PhotoBrowerData? {
        didSet {
            setupContent(data: data)
        }
    }
    
    var delegate : PhotoBrowserViewCellDelegate?
    
    // MARK:- 懒加载属性
    private lazy var scrollView : UIScrollView = UIScrollView()
    private lazy var progressView : ProgressView = ProgressView()
    lazy var imageView : UIImageView = UIImageView()
    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI界面内容
extension PhotoBrowserViewCell {
    private func setupUI() {
        // 1.添加子控件
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        
        // 2.设置子控件frame
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        
        // 3.设置控件的属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        // 4.监听imageView的点击
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserViewCell.imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        imageView.isUserInteractionEnabled = true
        
        // 5.监听imageView的长按
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(PhotoBrowserViewCell.imageViewLongPress))
        imageView.addGestureRecognizer(longPressGes)

    }
}


// MARK:- 事件监听
extension PhotoBrowserViewCell {
    @objc private func imageViewClick() {
        delegate?.imageViewClick()
    }
    
    @objc private func imageViewLongPress(ges:UILongPressGestureRecognizer) {
        if (ges.state==UIGestureRecognizer.State.began) {
            delegate?.imageViewLongPress()
        }

    }

}

// MARK:- 设置cell的内容
extension PhotoBrowserViewCell {
    
    private func setupContent(data : PhotoBrowerData?) {
        // 1.nil值校验
        guard let data = data else {
            return
        }
        
        // 2.判断是本地还是网络图片
        switch data.sourceType {
        case .netImage?:
            guard let url = data.url else {
                return
            }
            setupNetContent(picURL: URL(string: url)! as NSURL)
        case .localImage?:
            guard let image = data.image else {
                return
            }
            setImageViewPosition(image: image)
            imageView.image = image
        default:
            print("")
        }
        
    }
    
    // 设置网络图片的内容
    private func setupNetContent(picURL : NSURL!) {
        
        // 1.取出image对象
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
        
        if image != nil {
            // 3.缓存里有图片
            setImageViewPosition(image: image!)
            imageView.image = image
        } else {
            // 4.设置imagView的图片
            progressView.isHidden = false
            
            imageView.sd_setImage(with: picURL as URL, placeholderImage: nil, options: [], progress: { (current, total, _) in
                // 回主线程刷新UI
                DispatchQueue.main.async(execute: {
                    self.progressView.progress = CGFloat(current) / CGFloat(total)
                })
            }) { (resultImage, _, _, _) in
                guard let resultImage = resultImage else {
                    return
                }
                self.progressView.isHidden = true
                self.setImageViewPosition(image: resultImage)
            }
        }
    }
    
    // MARK:- 根据图片设置图片位置
    func setImageViewPosition(image:UIImage) {
        
        let size = imageSizeWithScreen(image: image)
        let height = size.height
        var y : CGFloat = 0
        if height > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        imageView.frame = CGRect(x: 0, y: y, width: size.width, height: size.height)
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    
    // MARK:- 根据图片获取大小
    func imageSizeWithScreen(image:UIImage) -> CGSize {
        var size = UIScreen.main.bounds.size
        size.height = image.size.height * size.width / image.size.width
        return size
    }
    
}

