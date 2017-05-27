Pod::Spec.new do |s|
    s.name         = "SKColumnView"
    s.version      = "1.0.1"
    s.summary      = "SKColumnView 菜单栏滚动视图"
    s.description  = <<-DESC 
                          SKColumnView 菜单栏滚动视图，菜单按钮在可滑动范围内居中显示。
                        DESC
    s.license      = { :type => "MIT", :file => "LICENCE" }
    s.author       = { "lijianli" => "lijianli1013@163.com" }
    s.platform     = :ios, "7.0"
    s.homepage     = "https://github.com/lijianli1013/SKColumnView"
    s.source       = { :git => "https://github.com/lijianli1013/SKColumnView.git", :tag => s.version.to_s }
    s.source_files = "SKColumnViews/**/*.{h,m}"
    s.requires_arc = true
end
