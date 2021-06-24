//
//  UnleashSpec.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Nimble
import PromiseKit
import Quick

@testable import UnleashClient

class UnleashSpec : QuickSpec {
    override func spec() {
        let appName: String = "test"
        let url: String = "https://test.com"
        let interval: TimeInterval = 3232
        var toggleRepository: ToggleRepositoryProtocol?
        var unleash: Unleash {
            return Unleash(toggleRepository: toggleRepository!, appName: appName, url: url, refreshInterval: interval,
                           strategies: [DefaultStrategy()])
        }
        
        beforeEach {
            let error = Promise<[String : Any]?> { _ in
                throw TestError.error
            }
            toggleRepository = ToggleRepositoryMock(toggles: nil)
        }
        
        describe("#init") {
            context("when default initializer") {
                let success = Promise<[String : Any]?> { seal in
                    seal.fulfill([:])
                }
                it("sets default values") {
                    // Act
                    let result = unleash
                    
                    // Assert
                    expect(result.appName).to(equal(appName))
                    expect(result.url).to(equal(url))
                    expect(result.refreshInterval).to(equal(interval))
                    expect(result.strategies.count).to(equal(1))
                }
                
            }
            
        }
        
        describe("#isEnabled") {
            context("when toggles cached") {
                context("when feature disabled") {
                    it("return false") {
                        // Arrange
                        let name = "feature"
                        let feature = FeatureBuilder()
                            .withName(name: name)
                            .disable()
                            .build()
                        let toggles = TogglesBuilder()
                            .withFeature(feature: feature)
                            .build()
                        toggleRepository = ToggleRepositoryMock(toggles: toggles)
                        
                        // Act
                        let result = unleash.isEnabled(name: name)
                        
                        // Assert
                        expect(result).to(beFalse())
                    }
                }
                
                context("when feature enabled") {
                    it("return toggles enabled value") {
                        // Arrange
                        let name = "feature"
                        let feature = FeatureBuilder()
                            .withName(name: name)
                            .build()
                        let toggles = TogglesBuilder()
                            .withFeature(feature: feature)
                            .build()
                        toggleRepository = ToggleRepositoryMock(toggles: toggles)
                        
                        // Act
                        let result = unleash.isEnabled(name: name)
                        
                        // Assert
                        expect(result).to(beTrue())
                    }
                }
            }
            
            context("when toggles not cached") {
                it("return false") {
                    // Act
                    let result = unleash.isEnabled(name: "feature")
                    
                    // Assert
                    expect(result).to(beFalse())
                }
            }
        }
    }
}
