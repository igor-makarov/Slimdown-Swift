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

public enum Replacement {
    case matchGroup(String)
}

public struct Rule {
    let regex: String
    let replacement: Replacement
    init(regex: String, replacement: String) {
        self.regex = regex
        self.replacement = .matchGroup(replacement)
    }
}

private var rules = [
//    Rule(regex: #"```(.*?)```/s"#, replacement: #"self::code_parse"#),                             // code blocks
//    Rule(regex: #"\n(#+)(.*)"#, replacement: #"self::header"#),                                   // headers
//    Rule(regex: #"\!\[([^\[]+)\]\(([^\)]+)\)"#, replacement: #"<img src=\'$2\' alt=\'$1\' />"#),  // images
    Rule(regex: #"\[([^\[]+)\]\(([^\)]+)\)"#, replacement: #"<a href=\'$2\'>$1</a>"#),            // links
//    Rule(regex: #"(\*\*|__)(.*?)\1"#, replacement: #"<strong>$2</strong>"#),                      // bold
//    Rule(regex: #"(\*|_)(.*?)\1"#, replacement: #"<em>$2</em>"#),                                 // emphasis
//    Rule(regex: #"\~\~(.*?)\~\~"#, replacement: #"<del>$1</del>"#),                               // del
//    Rule(regex: #"\:\"(.*?)\"\:"#, replacement: #"<q>$1</q>"#),                                   // quote
//    Rule(regex: #"`(.*?)`"#, replacement: #"<code>$1</code>"#),                                   // inline code
//    Rule(regex: #"\n\*(.*)"#, replacement: #"self::ul_list"#),                                    // ul lists
//    Rule(regex: #"\n[0-9]+\.(.*)"#, replacement: #"self::ol_list"#),                              // ol lists
//    Rule(regex: #"\n(&gt;|\>)(.*)"#, replacement: #"self::blockquote"#),                          // blockquotes
//    Rule(regex: #"\n-{5,}"#, replacement: #"\n<hr />"#),                                          // horizontal rule
//    Rule(regex: #"\n([^\n]+)\n"#, replacement: #"self::para"#),                                   // add paragraphs
//    Rule(regex: #"<\/ul>\s?<ul>"#, replacement:""),                                               // fix extra ul
//    Rule(regex: #"<\/ol>\s?<ol>"#, replacement: ""),                                              // fix extra ol
//    Rule(regex: #"<\/blockquote><blockquote>"#, replacement: "\n")                                // fix extra blockquote
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
            result = result.replacingOccurrences(of: rule.regex, with: replacement, options: .regularExpression)
        }
    }
    return result.trimmingCharacters(in: .whitespacesAndNewlines)
}


//    private static function code_parse ($regs) {
//        $item = $regs[1];
//        $item = htmlentities ($item, ENT_COMPAT);
//        $item = str_replace ("\n\n", '<br>', $item);
//        $item = str_replace ("\n", '<br>', $item);
//        while (mb_substr ($item, 0, 4) === '<br>') {
//            $item = mb_substr ($item, 4);
//        }
//        while (mb_substr ($item, -4) === '<br>') {
//            $item = mb_substr ($item, 0, -4);
//        }
//        return sprintf ("<pre><code>%s</code></pre>", trim ($item));
//    }
//
//    private static function para ($regs) {
//        $line = $regs[1];
//        $trimmed = trim ($line);
//        if (preg_match ('/^<\/?(ul|ol|li|h|p|bl|table|tr|th|td|code)/', $trimmed)) {
//            return "\n" . $line . "\n";
//        }
//        if (! empty ($trimmed)) {
//            return sprintf ("\n<p>%s</p>\n", $trimmed);
//        }
//        return $trimmed;
//    }
//
//    private static function ul_list ($regs) {
//        $item = $regs[1];
//        return sprintf ("\n<ul>\n\t<li>%s</li>\n</ul>", trim ($item));
//    }
//
//    private static function ol_list ($regs) {
//        $item = $regs[1];
//        return sprintf ("\n<ol>\n\t<li>%s</li>\n</ol>", trim ($item));
//    }
//
//    private static function blockquote ($regs) {
//        $item = $regs[2];
//        return sprintf ("\n<blockquote>%s</blockquote>", trim ($item));
//    }
//
//    private static function header ($regs) {
//        list ($tmp, $chars, $header) = $regs;
//        $level = strlen ($chars);
//        return sprintf ('<h%d>%s</h%d>', $level, trim ($header), $level);
//    }
