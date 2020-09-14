Pod::Spec.new do |spec|
  spec.name         = "Swoin"
  spec.version      = "0.0.1"
  spec.summary      = "A dependency injection library like Koin in Kotlin, but for Swift"

  spec.description  = <<-DESC
  	A dependency injection library like Koin in Kotlin, but for Swift
                 DESC

  spec.homepage     = "http://github.io/ajpolt/Swoin"

  spec.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }

  spec.author        = { "Adam Polt" => "adam@adampolt.com" }

  spec.source        = { :git => "http://github.com/ajpolt/swoin.git", :tag => "#{spec.version}" }

  spec.source_files  = "Swoin", "Swoin/Dependencies", "Swoin/ResolutionStrategies"
end

