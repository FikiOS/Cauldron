//
//  ExecuteCommandServiceProtocol.swift
//  ExecuteCommandService
//
//  Created by David Alarcon on 6/2/25.
//

import Foundation

/// The protocol that this service will vend as its API. This protocol will also need to be visible to the process hosting the service.
@objc protocol ExecuteCommandServiceProtocol {
  func runCommand(path: String, arguments: [String]) async throws -> Data
}
