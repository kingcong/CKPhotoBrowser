# CKPhotoBrowser
## 简单介绍
CKPhotoBrowser是基于Swift4.0版本开发的图片浏览器框架，开发思路模仿了微信、微博图片浏览器的动态效果，功能强大，集成方便并且易于扩展。

## 安装
### CocoaPods
1. 在 Podfile 中添加 pod 'CKPhotoBrowser'。
2. 执行 pod install 或 pod update。
3. 导入 import CKPhotoBrowser
4. 若搜索不到库，可使用 rm ~/Library/Caches/CocoaPods/search_index.json 移除本地索引然后再执行安装，或者更新一下 CocoaPods 版本。

### 手动导入
1. 下载 CKPhotoBrowser 文件夹所有内容并且拖入你的工程中。
2. 链接以下 frameworks：
* SDWebImage
3. 导入 CKPhotoBrowser

## 使用
对于CKPhotoBrowser的使用非常简单，只需要初始化图片数据数组即可，这里使用的是图片数据模型PhotoBrowerData,主要包括3个属性

1. url : 网络图片地址
2. image : 本地图片地址
3. sourceObject : 点击的图片ImageView

### 简单代码示例

```swift
// 1. 初始化数据
let data1: PhotoBrowerData = PhotoBrowerData(image: image, sourceObject: imageView)

let data2: PhotoBrowerData = PhotoBrowerData(url: "", sourceObject: imageView)

let data3: PhotoBrowerData = PhotoBrowerData(url: "", sourceObject: imageView)

// 2. 添加数据到数组中
let datas: [PhotoBrowerData] = [data1, data2, data3]
       
// 3. 初始化图片浏览器
let photoBrowerVc = PhotoBrowserController(currentIndex: indexPath.item, datasourceArray: datas)

// 4. 显示图片浏览器
photoBrowerVc.show()

```
## 问题
欢迎提交pull request

## License
Mit License
