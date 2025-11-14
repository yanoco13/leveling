//
//  AnyEncodable.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import Foundation


struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    init<T: Encodable>(_ value: T) { _encode = value.encode }
    func encode(to encoder: Encoder) throws { try _encode(encoder) }
}
