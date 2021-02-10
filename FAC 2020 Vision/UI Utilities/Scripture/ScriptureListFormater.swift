//
//  ScriptureListFormater.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-05.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation

/**
 This class is responsible for taking a list of scriptures and returning a formated string of the scripture
 */
class ScriptureListFormater {
    
    let booksToAbv = [
        "1 Chronicles": "1 Chron.",
        "1 Corinthians": "1 Cor.",
        "1 John": "1 John",
        "1 Kings": "1 Kings",
        "1 Peter": "1 Peter",
        "1 Samuel": "1 Sam.",
        "1 Thessalonians": "1 Thess.",
        "1 Timothy": "1 Tim.",
        "2 Chronicles": "2 Chron.",
        "2 Corinthians": "2 Cor.",
        "2 John": "2 John",
        "2 Kings": "2 Kings",
        "2 Peter": "2 Peter",
        "2 Samuel": "2 Sam.",
        "2 Thessalonians": "2 Thess.",
        "2 Timothy": "2 Tim.",
        "3 John": "3 John",
        "Acts": "Acts",
        "Amos": "Amos",
        "Colossians": "Col.",
        "Daniel": "Dan.",
        "Deuteronomy": "Deut.",
        "Ecclesiastes": "Ecc.",
        "Ephesians": "Eph.",
        "Esther": "Est.",
        "Exodus": "Exod.",
        "Ezekiel": "Ezek.",
        "Ezra": "Ezra",
        "Galatians": "Gal.",
        "Genesis": "Gen.",
        "Habakkuk": "Haba.",
        "Haggai": "Hag.",
        "Hebrews": "Heb.",
        "Hosea": "Hosea",
        "Isaiah": "Isa.",
        "James": "Jam.",
        "Jeremiah": "Jer.",
        "Job": "Job",
        "Joel": "Joel",
        "John": "John",
        "Jonah": "Jonah",
        "Joshua": "Jos.",
        "Jude": "Jude",
        "Judges": "Jud.",
        "Lamentations": "Lam.",
        "Leviticus": "Lev.",
        "Luke": "Luke",
        "Malachi": "Mal.",
        "Mark": "Mark",
        "Matthew": "Matt.",
        "Micah": "Mic",
        "Nahum": "Nah.",
        "Nehemiah": "Neh.",
        "Numbers": "Num.",
        "Obadiah": "Oba.",
        "Philemon": "Philemon.",
        "Philippians": "Phil.",
        "Proverbs": "Prov.",
        "Psalms": "Pslam",
        "Psalm": "Psalm",
        "Revelation": "Rev.",
        "Romans": "Rom.",
        "Ruth": "Ruth",
        "Song of Songs": "Song.",
        "Titus": "Titus",
        "Zechariah": "Zech.",
        "Zephaniah": "Zeph.",
        
    ]
    
    func getFormatedTitle(title: String) -> String {
        var output = ""
        
        if title != "" {
            let numOfSpaces = title.components(separatedBy:" ").count-1
                        
            var bookName = ""
            var formatedBookName = ""
            
            if title.contains("Song of Songs") {
                let components = title.components(separatedBy: " ")
                bookName = components[0] + " " + components[1] + " " + components[2]
                formatedBookName = booksToAbv[bookName] ?? ""
                
                output = "\(formatedBookName) \(components[3])"
            } else if numOfSpaces == 2 {
                let components = title.components(separatedBy: " ")
                bookName = components[0] + " " + components[1]
                formatedBookName = booksToAbv[bookName] ?? ""
                
                output = "\(formatedBookName) \(components[2])"
            } else {
                let components = title.components(separatedBy: " ")
                bookName = components[0]
                formatedBookName = booksToAbv[bookName] ?? ""
                
                output = "\(formatedBookName) \(components[1])"
            }
        } else {
            output = ""
        }
        
        return output
    }
}
