//
//  DataFetchPhase.swift
//  BlueMovie
//
//  Created by Wilson Leung on 9/2/2022.
//

import Foundation

enum DataFetchPhase<V> {
    case empty
    case success(V)
    case failure(Error)

    var value: V? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
}
