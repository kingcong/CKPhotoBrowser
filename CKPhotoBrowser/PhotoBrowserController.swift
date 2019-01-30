//
//  PhotoBrowerController.swift
//  PhotoBrower
//
//  Created by kingcong on 2019/1/29.
//  Copyright © 2019 ustc. All rights reserved.
//


import UIKit
import SDWebImage

private let PhotoBrowserCell = "PhotoBrowserCell"

public class PhotoBrowserController: UIViewController {
    
    // MARK:- 定义属性
    private var indexPath : NSIndexPath = NSIndexPath(item: 0, section: 0)
    public var currentIndex: Int = 0
    public var datasourceArray: [PhotoBrowerData] {
        didSet{
            
        }
    }
    
    // MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    private lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
    private lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")
    private lazy var noticeLab : UILabel = UILabel()
    
    private lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    // MARK:- 自定义构造函数
    public init(currentIndex : Int, datasourceArray : [PhotoBrowerData]) {
        self.currentIndex = currentIndex
        self.datasourceArray = datasourceArray
        self.indexPath = NSIndexPath(item: currentIndex, section: 0)
        // 开始缓存图片
        super.init(nibName: nil, bundle: nil)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 系统回调函数
    override public func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置UI界面
        setupUI()
        
        // 2.缓存图片
        cacheImages()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 2.滚动到对应的图片
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
    }
}


// MARK:- 设置UI界面内容
extension PhotoBrowserController {
    private func setupUI() {
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        view.addSubview(noticeLab)
        
        // 2.设置frame
        collectionView.frame = view.bounds
        closeBtn.frame = CGRect(x: 20, y: SCREEN_HEIGHT-60, width: 90, height: 30)
        saveBtn.frame = CGRect(x: SCREEN_WIDTH-100, y: SCREEN_HEIGHT-60, width: 90, height: 30)
        
        // 设置提醒label
        noticeLab.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        noticeLab.center = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT-80)
        noticeLab.font = UIFont(name: "plain", size: 10.0)
        noticeLab.textColor = UIColor.white
        noticeLab.text = "保存成功"
        noticeLab.textAlignment = NSTextAlignment.center
        noticeLab.backgroundColor = UIColor.black
        noticeLab.alpha = 0
        
        // 3.设置collectionView的属性
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        
        // 4.监听两个按钮的点击
        closeBtn.addTarget(self, action: #selector(PhotoBrowserController.closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserController.saveBtnClick), for: .touchUpInside)
        
    }
}



// MARK:- 缓存图片
extension PhotoBrowserController {
    /// 缓存图片(优先缓存当前选择的图片)
    private func cacheImages() {
        // 0.创建group
        let group = DispatchGroup()
        
        // 1.优先缓存当前网络图片，本地图片就不用缓存
        let currentData = self.datasourceArray[currentIndex]
        if currentData.sourceType == .netImage {
            SDWebImageManager.shared().loadImage(with: URL(string: currentData.url!), options: [SDWebImageOptions.highPriority], progress: nil) { (_, _, _, _, _, _) in
                
            }
        }

        
        // 2.缓存图片
        var index = 0
        for data in self.datasourceArray {
            group.enter()
            guard let url = data.url else {
                break
            }
            // 已经缓存过
            if index == currentIndex {
                break
            }
            
            // 只缓存网络图片
            if data.sourceType == .netImage {
                // 缓存其他图片
                SDWebImageManager.shared().loadImage(with: URL(string: url), options: [], progress: nil) { (_, _, _, _, _, _) in
                    group.leave()
                }
            }
            index = index+1
        }
    }
    
}

// MARK:-设置View的显示
extension PhotoBrowserController {
    public func show() {
        // 1.获取前一个控制器
//        let previousVc = self.view.findController()
        let previousVc: UIViewController = UIView.currentViewController()
        
        // 2.设置modal样式
        self.modalPresentationStyle = .custom
        
        // 4.设置动画的代理
        photoBrowserAnimator.presentedDelegate = self
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = self
        
        // 3.设置转场的代理
        self.transitioningDelegate = photoBrowserAnimator as UIViewControllerTransitioningDelegate
        
        // 4.以modal的形式弹出控制器
        previousVc.present(self, animated: true, completion: nil)
    }
}

// MARK:- 事件监听函数
extension PhotoBrowserController {
    @objc private func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveBtnClick() {
        // 1.获取当前正在显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        
        // 2.将image对象保存相册
//        UIImageWriteToSavedPhotosAlbum(image, self, Selector(("image:didFinishSavingWithError:contextInfo:")), nil)
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : AnyObject) {
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        noticeLab.text = showInfo
        
        noticeLab.alpha = 0
        UIView.animate(withDuration: 1.0, animations: {
            self.noticeLab.alpha = 1.0
        }) { (_) in

        }
        
        // 延迟1秒
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 1.0, animations: {
                self.noticeLab.alpha = 0
            }, completion: nil)
        }
    }
    
}


// MARK:- 实现collectionView的数据源方法
extension PhotoBrowserController : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasourceArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserViewCell
        
        // 2.给cell设置数据
        cell.data = datasourceArray[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}

// MARK:- PhotoBrowserViewCell的代理方法
extension PhotoBrowserController : PhotoBrowserViewCellDelegate {
    func imageViewLongPress() {
        saveBtnClick()
    }
    
    func imageViewClick() {
        closeBtnClick()
    }
}

// MARK:- 遵守AnimatorPresentedDelegate
extension PhotoBrowserController : AnimatorPresentedDelegate {
    func startRect(indexPath: NSIndexPath) -> CGRect {
        // 1.获取cell
        let imageView = datasourceArray[indexPath.item].sourceObject
        
        // 2.获取cell的frame
        let startFrame = imageView!.superview!.convert(imageView!.frame, to: UIApplication.shared.keyWindow!)
        
        return startFrame
    }
    
    func endRect(indexPath: NSIndexPath) -> CGRect {
        
        var image: UIImage?
        
        let data = datasourceArray[indexPath.item]
        
        // 判断是否是本地图片
        if data.sourceType == .localImage {
            image = data.image
            return imageFrameWithScreen(image: image!)
        }
        
        // 1.获取该位置的image对象
        let picURL = NSURL(string: datasourceArray[indexPath.item].url!)!
        image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)

        if image != nil {
            // 2.计算结束后的frame

            return imageFrameWithScreen(image: image!)
        } else {
            // 3.Image为空
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: picURL as URL, options: [], progress: nil, completed: { (resultImage, _, _, _) in
//                return self.imageFrameWithScreen(image: resultImage!)
            })
        }
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    // MARK:- 根据图片获取大小
    func imageFrameWithScreen(image:UIImage) -> CGRect {
        let size = imageSizeWithScreen(image: image)
        let h: CGFloat = size.height
        let w = size.width
        var y : CGFloat = 0
        if h > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    
    func imageSizeWithScreen(image:UIImage) -> CGSize {
        var size = UIScreen.main.bounds.size
        size.height = image.size.height * size.width / image.size.width
        return size
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        // 1.创建UIImageView对象
        let imageView = UIImageView()
        
        let data = self.datasourceArray[indexPath.item]
        
        // 从本地加载
        if data.sourceType == .localImage {
            imageView.image = data.image
        } else {
            // 2.获取该位置的image对象
            let picURL = NSURL(string: datasourceArray[indexPath.item].url!)!
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
            
            // 3.设置imageView的属性
            if image != nil {
                // 3.缓存里有图片
                imageView.image = image
            } else {
                // 4.设置imagView的图片
                imageView.sd_setImage(with: picURL as URL, placeholderImage: nil)
            }
        }
        
//        imageView.contentMode = data.sourceObject!.contentMode
//        imageView.clipsToBounds = data.sourceObject!.clipsToBounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}

// MARK:- 遵守AnimatorDismissDelegate
extension PhotoBrowserController : AnimatorDismissDelegate {
    
    func indexPathForDimissView() -> NSIndexPath {
        // 1.获取当前正在显示的indexPath
        let cell = collectionView.visibleCells.first!
        
        return collectionView.indexPath(for: cell)! as NSIndexPath
    }
    
    func imageViewForDimissView() -> UIImageView {
        // 1.创建UIImageView对象
        let imageView = UIImageView()
        
        // 2.设置imageView的frame
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        
        let indexPath = collectionView.indexPath(for: cell)!
        let data = datasourceArray[indexPath.item]
        // 3.设置imageView的属性
        imageView.contentMode = data.sourceObject?.contentMode ?? .scaleAspectFill
        imageView.clipsToBounds = data.sourceObject?.clipsToBounds ?? true
        
        return imageView
    }
}

// MARK:- 自定义布局
class PhotoBrowserCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 1.设置itemSize
        itemSize = collectionView!.frame.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        // 2.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
