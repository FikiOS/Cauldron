import Foundation

enum SubCommand: String {
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
  var subCommand: SubCommand { get }
  var arguments: [String] { get }
  var output: Output { get }
  var verbose: Bool { get } // = "--verbose"
  var debug: Bool { get } // = "--debug"
  var quiet: Bool { get } // = "--quiet"
  var evalAll: Bool { get } // = "--eval-All"
  var commandLine: [String] { get }
}

extension BrewCommand {
  var arguments: [String] { ["--login"] }
  var output: Output { .json }
  var verbose: Bool { false }
  var debug: Bool { false }
  var quiet: Bool { false }
  var evalAll: Bool { false }

  var commandLine: [String] {
    let subCommand = [subCommand.value]
    let output = [output.value]
    let verbose = verbose ? ["--verbose"] : Array.empty
    let debug = debug ? ["--debug"] : Array.empty
    let quiet = quiet ? ["--quiet"] : Array.empty
    let evalAll = evalAll ? ["--eval-all"] : Array.empty

    return subCommand + output + verbose + debug + quiet + evalAll + arguments
  }
}
