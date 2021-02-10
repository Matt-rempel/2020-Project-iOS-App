//
//  ScriptureStyleSheet.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-18.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import Foundation

// Use enum rawValues to store UserDefaults preferences
enum ScriptureTranslation: String {
	case kjv = "kjv"
	case nlt = "nlt"
    case niv = "niv"
}

enum ScriptureColor: String {
	case dark = "dark"
	case light = "light"
	case sepia = "sepia"
}

enum ScriptureFontSize: String {
	case extraSmall = "extraSmall"
	case small = "small"
	case medium = "medium"
	case large = "large"
	case extraLarge = "extraLarge"
	case boomer = "boomer"
}

enum ScriptureFontFamily: String {
	case times = "times"
	case arial = "arial"
	case helvetica = "helvetica"
	case georgia = "georgia"
	case avenir = "avenir"
}

enum ScriptureError: Error {
    case bookNotFound
    case requestError(message: String)
}

class ScriptureStyleSheet  {
	
    static func getFormatedTitle(parts: PassageParts) throws -> String {
        var output = ""
        
        let booksToAbv = [
            "1 Chronicles": "1CH",
            "1 Corinthians": "1CO",
            "1 John": "1JN",
            "1 Kings": "1KI",
            "1 Peter": "1PE",
            "1 Samuel": "1SA",
            "1 Thessalonians": "1TH",
            "1 Timothy": "1TI",
            "2 Chronicles": "2CH",
            "2 Corinthians": "2CO",
            "2 John": "2JN",
            "2 Kings": "2KI",
            "2 Peter": "2PE",
            "2 Samuel": "2SA",
            "2 Thessalonians": "2TH",
            "2 Timothy": "2TI",
            "3 John": "3JN",
            "Acts": "ACT",
            "Amos": "AMO",
            "Colossians": "COL",
            "Daniel": "DAN",
            "Deuteronomy": "DEU",
            "Ecclesiastes": "ECC",
            "Ephesians": "EPH",
            "Esther": "EST",
            "Exodus": "EXO",
            "Ezekiel": "EZK",
            "Ezra": "EZR",
            "Galatians": "GAL",
            "Genesis": "GEN",
            "Habakkuk": "HAB",
            "Haggai": "HAG",
            "Hebrews": "HEB",
            "Hosea": "HOS",
            "Isaiah": "ISA",
            "James": "JAS",
            "Jeremiah": "JER",
            "Job": "JOB",
            "Joel": "JOL",
            "John": "JHN",
            "Jonah": "JON",
            "Joshua": "JOS",
            "Jude": "JUD",
            "Judges": "JDG",
            "Lamentations": "LAM",
            "Leviticus": "LEV",
            "Luke": "LUK",
            "Malachi": "MAL",
            "Mark": "MRK",
            "Matthew": "MAT",
            "Micah": "MIC",
            "Nahum": "NAM",
            "Nehemiah": "NEH",
            "Numbers": "NUM",
            "Obadiah": "OBA",
            "Philemon": "PHM",
            "Philippians": "PHP",
            "Proverbs": "PRO",
            "Psalms": "PSA",
            "Psalm": "PSA",
            "Revelation": "REV",
            "Romans": "ROM",
            "Ruth": "RUT",
            "Song of Songs": "SNG",
            "Titus": "TIT",
            "Zechariah": "ZEC",
            "Zephaniah": "ZEP",
        ]

        guard let formatedBook = booksToAbv[parts.book ?? ""] else {
            throw ScriptureError.bookNotFound
        }
        
        guard var formatedStart = parts.start else {
            throw ScriptureError.bookNotFound
        }
        
        guard var formatedEnd = parts.end else {
            throw ScriptureError.bookNotFound
        }
        
        formatedStart = formatedStart.replacingOccurrences(of: ":", with: ".")
        formatedStart = formatedStart.replacingOccurrences(of: "a", with: "")
        formatedStart = formatedStart.replacingOccurrences(of: "b", with: "")
        formatedEnd = formatedEnd.replacingOccurrences(of: ":", with: ".")
        formatedEnd = formatedEnd.replacingOccurrences(of: "a", with: "")
        formatedEnd = formatedEnd.replacingOccurrences(of: "b", with: "")
        
        output = "\(formatedBook).\(formatedStart)-\(formatedBook).\(formatedEnd)"
        
        return output
        
    }
    
	static func getFullFontName(font: ScriptureFontFamily) -> String {
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
	
	static func getFullFontSize(size: ScriptureFontSize) -> String {
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
	
	static func getFullColor(color: ScriptureColor) -> String {
			switch color {
			case .dark:
				return "Dark"
			case .light:
				return "Light"
			case .sepia:
				return "Sepia"
			}
	}
	
	static func getFullTranslation(translation: ScriptureTranslation) -> String {
			switch translation {
//			case .esv:
//				return "ESV"
			case .kjv:
				return "KJV"
			case .nlt:
				return "NLT"
            case .niv:
                return "NIV"
        }
	}
	
	static func getColorForBody() -> String {
		switch UserDefaultsHelper.getScriptureColor() {
		case .dark:
			return "color: white;background-color: black;"
		case .light:
			return "color: black;background-color: white;"
		case .sepia:
			return "color: gray;background-color: #fff8c9;"
		}
	}
	
	static func getFontSizeForBody() -> String {
		switch UserDefaultsHelper.getScriptureFontSize() {
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
	
	static func getFontFamilyForBody() -> String {
		switch UserDefaultsHelper.getScriptureFontFamily()  {
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
	
	public static func getESVScriptureTag() -> String {
		return "<p style='text-align: right;'>ESV</p>"
	}
	
    public static func getNIVCopyright() -> String {
        return """
        <p style="font-size: 12px;">THE HOLY BIBLE, NEW INTERNATIONAL VERSION ®, NIV ®
        Copyright © 1973, 1978, 1984, 2011 by Biblica, Inc.
        Used with permission of Biblica, Inc. All rights reserved worldwide.</p>
        <p style="font-size: 12px;">The "NIV", "New International Version", "Biblica", "International Bible Society" and the Biblica Logo are trademarks registered in the United States Patent and Trademark Office by Biblica, Inc. Used with permission.</p>
        """
    }
    
    public static func getNLTCopyright() -> String {
        return """
        <p style="font-size: 12px;">Scripture quotations marked (NLT) are taken from the Holy Bible, New Living Translation, copyright ©1996, 2004, 2015 by Tyndale House Foundation. Used by permission of Tyndale House Publishers, a Division of Tyndale House Ministries, Carol Stream, Illinois 60188. All rights reserved.</p>
        """
    }
    
    public static func getKJVCopyright() -> String {
        return """
        <p style="font-size: 12px;">King James Version 1611, spelling, punctuation and text formatting modernized by ABS in 1962; typesetting © 2010 American Bible Society.</p>
        """
    }
    
	public static func getFullHTMLWith(body: String) -> String {
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
//padding-right: 15;
//	float: left;
	
	static let htmlStart = """
<html>

<style>
body {
			font-family: "Arial";
			
"""
	static let htmlEnd = "</section></body></html>"
	static let style = """
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
