import Foundation

enum Command: String {
    case info = "info"
    case install = "install"
    case uninstall = "uninstall"
    case update = "update"
    case upgrade = "upgrade"
    case search = "search"
    case list = "list"
    case tap = "tap"
    case untap = "untap"
    case services = "services"
    case cleanup = "cleanup"
    case doctor = "doctor"
    case outdated = "outdated"
    case pin = "pin"
    case unpin = "unpin"
    case link = "link"
    case unlink = "unlink"

    var value: String { rawValue }
}

enum Output: String {
    case json = "--json=v2"
    case text = ""

    var value: String { rawValue }
}

protocol BrewCommand {
    var command: Command { get }
    var arguments: [String] { get }
    var output: Output { get }
    var verbose: Bool { get } // = "--verbose"
    var debug: Bool { get } // = "--debug"
    var quiet: Bool { get } // = "--quiet"
    var commandLine: String { get }
}

extension BrewCommand {
    var arguments: [String] { ["--login"] }
    var output: Output { .json }
    var verbose: Bool { false }
    var debug: Bool { false }
    var quiet: Bool { false }

    var commandLine: String {
        let command = command.value
        let output = output.value
        let arguments = arguments.joined(separator: " ")
        let verbose = verbose ? "--verbose" : String.empty
        let debug = debug ? "--debug" : String.empty
        let quiet = quiet ? "--quiet" : String.empty

        print(command + " " + arguments + " " + output + " " + verbose + " " + debug + " " + quiet)
        
        return command + " " + arguments + " " + output + " " + verbose + " " + debug + " " + quiet // command + arguments + output + verbose + debug + quiet
    }
}
