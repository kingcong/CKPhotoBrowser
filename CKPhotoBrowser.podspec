Pod::Spec.new do |s|

  s.name         = "CKPhotoBrowser"
  s.version      = "1.0.0"
  #主要标题
  s.summary      = "a swift photo browser"
  #详细描述（必须大于主要标题的长度）
  s.description  = <<-DESC
              一个swift的图片浏览器
                   DESC
  #仓库主页
  s.homepage     = "https://github.com/kingcong/CKPhotoBrowser"
  s.license      = "Apache License Version 2.0"
  s.author       = { "wangcong" => "2441413514@qq.com" }
  s.platform     = :ios,'8.0'
  #仓库地址（注意下tag号）
  s.source       = { :git => "https://github.com/kingcong/CKPhotoBrowser.git", :tag => "#{s.version}" }
  #这里路径必须正确，因为swift只有一个文件不需要s.public_header_files
  #s.public_header_files = "Classes/*.h"
  s.source_files = "CKPhotoBrowser/*.swift"
  s.framework    = "UIKit","Foundation"
  s.requires_arc = true
  s.dependency 'SDWebImage'
end