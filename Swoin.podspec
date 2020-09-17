Pod::Spec.new do |spec|
  spec.name         = "Swoin"
  spec.version      = "0.0.5"
  spec.summary      = "A dependency injection library in Swift, inspired by Koin"

  spec.description  = <<-DESC
  	A dependency injection library like Koin in Kotlin, but for Swift. 
                 DESC

  spec.homepage     = "https://ajpolt.github.io/swoin"

  spec.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }

  spec.author        = { "Adam Polt" => "adam@adampolt.com" }

  spec.source        = { :git => "https://github.com/ajpolt/swoin.git", :tag => "#{spec.version}" }

  spec.source_files  = "Swoin", "Swoin/Dependencies", "Swoin/Cache", "Swoin/Modules", "Swoin/Injection"

  spec.swift_version = '5.2'
  spec.ios.deployment_target  = '9.0'

end

