//
//  Feature.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation


public enum TypeEnum: String, Codable {
    case killSwitch = "kill-switch"
    case operational = "operational"
    case release = "release"
}


// MARK: - Feature
public class Feature: Codable {
    
    public init(name: String, type: TypeEnum, enabled: Bool, stale: Bool, strategies: [ActivationStrategy]) {
        self.name = name
        self.type = type
        self.enabled = enabled
        self.stale = stale
        self.strategies = strategies
    }
    
    let name: String
    let type: TypeEnum
    let enabled, stale: Bool
    let strategies: [ActivationStrategy]
}


// MARK: - Parameters
public class FeatureParameters: Codable {
    let parametersStore, store: String?

    enum CodingKeys: String, CodingKey {
        case parametersStore = "store"
        case store = "Store"
    }
}
