platform :ios, '12.0'

def rxswift
	pod 'RxSwift'
	pod 'RxCocoa'	
	pod 'RxDataSources'
end


target 'SimplePostsApp' do
  use_frameworks!
  rxswift
  pod 'Kingfisher'
  pod 'RealmSwift'
  
  target 'SimplePostsAppTests' do
    inherit! :search_paths
   	pod 'RxBlocking'
   	pod 'iOSSnapshotTestCase'
  end
end
