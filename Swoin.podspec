Pod::Spec.new do |spec|
  spec.name         = "Swoin"
  spec.version      = "0.0.2"
  spec.summary      = "A dependency injection library in Swift, inspired by Koin"

  spec.description  = <<-DESC
  	A dependency injection library like Koin in Kotlin, but for Swift. 
                 DESC

  spec.homepage     = "http://github.io/ajpolt/Swoin"

  spec.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }

  spec.author        = { "Adam Polt" => "adam@adampolt.com" }

  spec.source        = { :git => "https://github.com/ajpolt/swoin.git", :tag => "#{spec.version}" }

  spec.source_files  = "Swoin", "Swoin/Dependencies", "Swoin/Cache"

  spec.swift_version = '5.2'
  spec.ios.deployment_target  = '9.0'

end

