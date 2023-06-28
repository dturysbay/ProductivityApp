//
//  View.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 20.06.2023.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        let set = Set<Element>(self)
        return Array<Element>(set)
    }
}
