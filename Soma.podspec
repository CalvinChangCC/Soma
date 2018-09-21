Pod::Spec.new do |s|
  s.name         = "Soma"
  s.version      = "1.0.1"

  s.summary      = "SocketIO socket network layer."
  s.description  = <<-DESC
                   SocketIO socket network layer.
                   DESC

  s.homepage     = "http://git.sapphireinfo.com.tw/ios/Soma.git"
  s.license      = "MIT"
  s.author       = { "calvin.chang" => "calvin.chang@sapphireinfo.com.tw" }
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0'
  s.source       = { :git => "git@git.sapphireinfo.com.tw:ios/Soma.git", :tag => s.version }
  s.source_files = "Classes/**/*.{swift}"
  s.dependency "Socket.IO-Client-Swift", "~> 13.1.0"
  s.requires_arc = true
end
