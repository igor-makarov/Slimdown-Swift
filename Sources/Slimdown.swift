import Foundation

/// Slimdown - A simple regex-based Markdown parser in PHP. Supports the
/// following elements (and can be extended via `Slimdown::add_rule()`):
///
/// - Headers
/// - Links
/// - Bold
/// - Emphasis
/// - Deletions
/// - Quotes
/// - Code blocks
/// - Inline code
/// - Blockquotes
/// - Ordered/unordered lists
/// - Horizontal rules
/// - Images
///

public typealias ReplacementFunction = ([String]) -> String

public enum Replacement {
    case matchGroup(String)
    case function(ReplacementFunction)
}

public struct RegexDefinition {
    let pattern: String
    let options: NSRegularExpression.Options
    init(pattern: String, options: NSRegularExpression.Options = []) {
        self.pattern = pattern
        self.options = options
    }
}

public struct Rule {
    let regex: RegexDefinition
    let replacement: Replacement
    init(regex: String, replacement: String) {
        self.regex = .init(pattern: regex)
        self.replacement = .matchGroup(replacement)
    }
    init(regex: String, replacement: @escaping ReplacementFunction) {
        self.regex = .init(pattern: regex)
        self.replacement = .function(replacement)
    }
    init(regex: String, multilineReplacement: @escaping ReplacementFunction) {
        self.regex = .init(pattern: regex, options: .dotMatchesLineSeparators)
        self.replacement = .function(multilineReplacement)
    }
}

private var rules = [
    Rule(regex: #"```(.*?)```"#, multilineReplacement: code_parse),                               // code blocks
    Rule(regex: #"\n(#+)(.*)"#, replacement: header),                                             // headers
    Rule(regex: #"\!\[([^\[]+)\]\(([^\)]+)\)"#, replacement: #"<img src=\'$2\' alt=\'$1\' />"#),  // images
    Rule(regex: #"\[([^\[]+)\]\(([^\)]+)\)"#, replacement: #"<a href=\'$2\'>$1</a>"#),            // links
    Rule(regex: #"(\*\*|__)(.*?)\1"#, replacement: #"<strong>$2</strong>"#),                      // bold
    Rule(regex: #"(\*|_)(.*?)\1"#, replacement: #"<em>$2</em>"#),                                 // emphasis
    Rule(regex: #"\~\~(.*?)\~\~"#, replacement: #"<del>$1</del>"#),                               // del
    Rule(regex: #"\:\"(.*?)\"\:"#, replacement: #"<q>$1</q>"#),                                   // quote
    Rule(regex: #"`(.*?)`"#, replacement: #"<code>$1</code>"#),                                   // inline code
    Rule(regex: #"\n\*(.*)"#, replacement: ul_list),                                              // ul lists
    Rule(regex: #"\n[0-9]+\.(.*)"#, replacement: ol_list),                                        // ol lists
    Rule(regex: #"\n(&gt;|\>)(.*)"#, replacement: blockquote),                                    // blockquotes
    Rule(regex: #"\n-{5,}"#, replacement: "\n<hr />"),                                            // horizontal rule
    Rule(regex: #"\n([^\n]+)\n"#, replacement: paragraph),                                        // add paragraphs
    Rule(regex: #"<\/ul>\s?<ul>"#, replacement:""),                                               // fix extra ul
    Rule(regex: #"<\/ol>\s?<ol>"#, replacement: ""),                                              // fix extra ol
    Rule(regex: #"<\/blockquote><blockquote>"#, replacement: "\n")                                // fix extra blockquote
]

/// Add a rule.
public func addRule(_ rule: Rule) {
    rules.append(rule)
}

/// Render some Markdown into HTML.
public func render(text: String) -> String {
    var result = "\n" + text + "\n"
    for rule in rules {
        switch rule.replacement {
        case .matchGroup(let replacement):
            result = result.replacingOccurrences(of: rule.regex.pattern, with: replacement, options: .regularExpression)
        case .function(let replacementFunction):
            result = result.replace(rule.regex.pattern, options: rule.regex.options, collector: replacementFunction)
            break
        }
    }
    return result.trim()
}

private extension String {
    func replace(_ pattern: String, options: NSRegularExpression.Options = [], collector: ([String]) -> String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else { return self }
        let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, (self as NSString).length))
        guard matches.count > 0 else { return self }
        var splitStart = startIndex
        return matches.map { (match) -> (String, [String]) in
            let range = Range(match.range, in: self)!
            let split = String(self[splitStart ..< range.lowerBound])
            splitStart = range.upperBound
            return (split, (0 ..< match.numberOfRanges)
                .compactMap { Range(match.range(at: $0), in: self) }
                .map { String(self[$0]) }
            )
        }.reduce("") { "\($0)\($1.0)\(collector($1.1))" } + self[Range(matches.last!.range, in: self)!.upperBound ..< endIndex]
    }

    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private func code_parse(_ matches: [String]) -> String {
    var item = matches[1]
    //        item = htmlentities ($item, ENT_COMPAT)
    item = item.replacingOccurrences(of: "\n\n", with: "<br>")
    item = item.replacingOccurrences(of: "\n", with: "<br>")
    while item.hasPrefix("<br>"),
          let start = item.index(item.startIndex, offsetBy: 4, limitedBy: item.endIndex) {
        item = String(item[start..<item.endIndex])
    }
    while item.hasSuffix("<br>"),
          let end = item.index(item.endIndex, offsetBy: -4, limitedBy: item.startIndex) {
        item = String(item[item.startIndex..<end])
    }
    return "<pre><code>\(item.trim())</code></pre>"
}

private func paragraph(_ matches: [String]) -> String {
    let line = matches[1]
    let trimmed = line.trim()
    if trimmed.range(of: #"^<\/?(ul|ol|li|h|p|bl|table|tr|th|td|code)"#, options: .regularExpression) != nil {
        return "\n\(line)\n"
    }
    if (!trimmed.isEmpty) {
        return "\n<p>\(trimmed)</p>\n"
    }
    return trimmed
}

private func ul_list(_ matches: [String]) -> String {
    let item = matches[1]
    return "\n<ul>\n\t<li>\(item.trim())</li>\n</ul>"
}

private func ol_list(_ matches: [String]) -> String {
    let item = matches[1]
    return "\n<ol>\n\t<li>\(item.trim())</li>\n</ol>"
}

private func blockquote(_ matches: [String]) -> String {
    let item = matches[2]
    return "\n<blockquote>\(item.trim())</blockquote>"
}

private func header(_ matches: [String]) -> String {
    let (chars, header) = (matches[1], matches[2])
    let level = chars.count
    return "<h\(level)>\(header.trim())</h\(level)>"
}
