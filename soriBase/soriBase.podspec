Pod::Spec.new do |s|
s.name             = "soriBase"
s.version          = "1.0"
s.summary          = "init"
s.description      = "initBase"
s.homepage         = "https://github.com/PhanThanhBao/soriB_base"
s.license          = 'soriB'
s.author           = { "soriB" => "phanthbao@gmail.com" }
s.source           = { :git => "https://github.com/PhanThanhBao/soriB_base.git", :tag => s.version.to_s }
s.platform     = :ios, '8.0'
s.requires_arc = true

# If more than one source file: https://guides.cocoapods.org/syntax/podspec.html#source_files
s.source_files = 'SoriBase.swift' 

end