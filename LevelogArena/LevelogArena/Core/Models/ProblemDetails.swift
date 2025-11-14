//
//  ProblemDetails.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import Foundation


// RFC7807 application/problem+json
struct ProblemDetails: Codable, Error, LocalizedError {
    let type: String?
    let title: String?
    let status: Int?
    let detail: String?
    let instance: String?
    let errorCode: String?
    var errorDescription: String? { detail ?? title ?? errorCode }
}
