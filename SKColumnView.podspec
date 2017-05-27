Pod::Spec.new do |s|
    s.name         = ‘SKColumnView’
    s.version      = ‘1.0.1’
    s.summary      = ‘A short description of SKColumnView’
    s.description  = <<-DESC 
                          LZTool 是一个用于保存一些常用工具类的工具
                        DESC
    s.license      = { :type => "MIT", :file => "LICENCE" }
    s.author       = { “lijianli” => “lijianli1013@163.com" }
    s.platform     = :ios, "7.0"
    s.homepage     = ‘https://github.com/lijianli1013/SKColumnView'
    s.source       = { :git => "https://github.com/lijianli1013/SKColumnView.git", :tag => s.version.to_s }
    s.source_files = ‘SKColumnViews/**/*.{h,m}’
    s.requires_arc = true
end
