//
//  ScriptureStyleSheet.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-18.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import Foundation
import UIKit

class ScriptureStyleSheet {
    
    let udManager = UserDefaultsManager()
    
    func getFullFontName(font: ScriptureFontFamily) -> String {
		switch font {
		case .times:
			return "Times New Roman"
		case .arial:
			return "Arial"
		case .helvetica:
			return "Helvetica"
		case .georgia:
			return "Georgia"
		case .avenir:
			return "Avenir Next"
		}
	}
	
    func getFullFontSize(size: ScriptureFontSize) -> String {
		switch size {
		case .extraSmall:
			return "Extra Small"
		case .small:
			return "Small"
		case .medium:
			return "Medium"
		case .large:
			return "Large"
		case .extraLarge:
			return "Extra Large"
		case .boomer:
			return "Extra Extra Large"
		}
	}

    func getFullColor(color: ScriptureColor) -> String {
        switch color {
        case .dark:
            return "Dark"
        case .light:
            return "Light"
        case .sepia:
            return "Sepia"
        case .system:
            return "System"
        }
	}

    func getFullTranslation(translation: ScriptureTranslation) -> String {
        switch translation {
        case .kjv:
            return "KJV"
        case .nlt:
            return "NLT"
        case .niv:
            return "NIV"
        }
	}

    func getColorForBody() -> String {
        switch udManager.getScriptureColor() {
        case .dark:
			return "color: white;background-color: black;"
        case .light:
			return "color: black;background-color: white;"
        case .sepia:
			return "color: gray;background-color: #fff8c9;"
        case .system:
            if DarkModeManager().isDarkMode {
                return "color: white;background-color: black;"
            } else {
                return "color: black;background-color: white;"
            }
        }
	}

    func getFontSizeForBody() -> String {
		switch udManager.getScriptureFontSize() {
		case .extraSmall:
			return "font-size: 12px; }; p {font-size: 14pt;}; .extra_text {font-size: 34;}; .s1 {font-weight: bold;}"
		case .small:
			return "font-size: 14px; }; p {font-size: 16pt;}; .extra_text {font-size: 36;}; .s1 {font-weight: bold;}"
		case .medium:
			return "font-size: 18px; }; p {font-size: 20pt;}; .extra_text {font-size: 40;}; .s1 {font-weight: bold;}"
		case .large:
			return "font-size: 24px; }; p {font-size: 26pt;}; .extra_text {font-size: 46;}; .s1 {font-weight: bold;}"
		case .extraLarge:
			return "font-size: 28px; }; p {font-size: 30pt;}; .extra_text {font-size: 50;}; .s1 {font-weight: bold;}"
		case .boomer:
			return "font-size: 38px; }; p {font-size: 40pt;}; .extra_text {font-size: 60;}; .s1 {font-weight: bold;}"
		}
	}

    func getFontFamilyForBody() -> String {
		switch udManager.getScriptureFontFamily() {
		case .times:
			return "font-family: \"Times New Roman\";"
		case .arial:
			return "font-family: \"Arial\";"
		case .helvetica:
			return "font-family: \"Helvetica\";"
		case .georgia:
			return "font-family: \"Georgia\";"
		case .avenir:
			return "font-family: \"Avenir\";"
		}
	}

     func getCopyright(copyright: String?) -> String {
        return """
        <p style="font-size: 12px;">\(copyright ?? "")</p>
        """
    }

	 func getFullHTMLWith(body: String) -> String {
		var output = ""

		output += self.htmlStart
		output += getColorForBody()
		output += getFontFamilyForBody()
		output += getFontSizeForBody()
		output += self.style
		output += body
		output += self.htmlEnd

		return output
	}

    let htmlStart = """
<html>

<style>
body {
			font-family: "Arial";

"""
    let htmlEnd = "</section></body></html>"
    let style = """
.section {
    padding: 16px !important;
}
			h3 {
				font-style: italic;
			}

			.chapter-num {

			}

.a-tn, .tn-ref {
    display: none
}

.chapter-number, .subhead {
    font-weight: bold;
}




			.verse-num,
			.v,
			.fr,
			.vn {
				/*float: left;*/
				padding-right: 5px;
				vertical-align: super;
				font-size: smaller;
				font-weight: bold;
			}
    .s1 {
        font-weight: bold;
    }
    p {
        line-height: 150%;
    }
			.vn {
				padding: 5px;
			}

			.book-name {

			}

			.starts-chapter {

			}

			.line {

			}

			.begin-line-group {

			}

			.interlinear p {
				text-indent: 0;
			}
			.nd {
				font-weight: 500;
			}

			.add {
				font-style: italic;
			}


		</style>
	<body>
<section class="section">

"""

}
