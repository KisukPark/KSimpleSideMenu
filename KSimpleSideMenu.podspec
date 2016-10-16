Pod::Spec.new do |s|
  s.name             = 'KSimpleSideMenu'
  s.version          = '0.1.0'
  s.summary          = 'Simple and easy-to-use side menu library for swift3, Xcode8, iOS'
  s.description      = <<-DESC
Simple and easy-to-use side menu library for swift3, iOS.
Supports 1) tap gesture to close menu 2) pan gesture to open/close menu.
                       DESC
  s.homepage         = 'https://github.com/KisukPark/KSimpleSideMenu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kisukpark' => 'kisuk0521@gmail.com' }
  s.source           = { :git => 'https://github.com/KisukPark/KSimpleSideMenu.git', :tag => s.version.to_s }

  s.requires_arc          = true

  s.ios.deployment_target = '8.0'

  s.source_files = 'Sources/**/*.swift'

  # s.frameworks = 'UIKit'
end
