use_frameworks!

target ‘FriendsInfinity’ do
  pod "Koloda", :path => "./Koloda"
  pod 'Alamofire', '~> 4.2.0'
  pod 'SwiftLoader'
  pod 'Firebase/Core’
  pod 'Firebase/Auth'
  pod 'ImageSlideshow', '~> 1.2'
  pod "ImageSlideshow/Alamofire"
end

post_install do |installer|
  `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end
