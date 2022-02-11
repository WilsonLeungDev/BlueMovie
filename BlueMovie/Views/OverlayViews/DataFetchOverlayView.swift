//
//  DataFetchOverlayView.swift
//  BlueMovie
//
//  Created by Wilson Leung on 9/2/2022.
//

import SwiftUI

protocol EmptyData {
    var isEmpty: Bool { get }
}

struct DataFetchOverlayView<V: EmptyData>: View {
    let phase: DataFetchPhase<V>
    let retryAction: () -> ()
    
    var body: some View {
        switch phase {
        case .empty:
            ProgressView()
        case .success(let value) where value.isEmpty:
            EmptyPlaceholderView(text: "No data", image: Image(systemName: "film"))
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: retryAction)
        default:
            EmptyView()
        }
    }
}

extension Array: EmptyData {}
extension Optional: EmptyData {
    var isEmpty: Bool {
        if case .none = self {
            return true
        }
        return false
    }
}

struct DataFetchOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DataFetchOverlayView(phase: .success([])) {
                print("Retry")
            }
            DataFetchOverlayView<[Movie]>(phase: .failure(MovieError.invalidResponse)) {
                print("Retry")
            }
            DataFetchOverlayView<Movie?>(phase: .empty) {
                print("Retry")
            }
        }
    }
}
