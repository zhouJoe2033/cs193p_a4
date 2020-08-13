//
//  EmojiArt.swift
//  cs193p_a4
//
//  Created by Joe on 2020-08-11.
//  Copyright © 2020 Joe. All rights reserved.
//

import Foundation
import SwiftUI

struct EmojiArt: Codable {
    
    var backgroundURL: URL?
    var emojis = [Emoji]()
    var emojis_selected: Set<Emoji> = []
     
    struct Emoji: Identifiable, Codable, Hashable {
        let id: Int
        let text: String
        var x: Int
        var y: Int
        var size: Int
        
        fileprivate init(id: Int, text: String, x: Int, y: Int, size: Int) {
            self.id = id
            self.text = text
            self.x = x
            self.y = y
            self.size = size
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }

    init() {
        reSetSelectedEmojis()
    }
    
    init?(json: Data?) {
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json!) {
            self = newEmojiArt
        } else {
            return nil
        }
        
        reSetSelectedEmojis()
    }

    var uniqueEmojiId: Int = 0

    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(id: uniqueEmojiId, text: text, x: x, y: y, size: size))
    }
    
    mutating func selectEmoji(_ emoji: Emoji) {
        if !emojis_selected.contains(emoji){
            emojis_selected.insert(emoji)
        }else{
            emojis_selected.remove(emoji)
        }
    }
    
    //TODO task 2, clear selected emojis when re-start the app, see if can use @State instead
    mutating func reSetSelectedEmojis() {
        emojis_selected = []
    }
    
    mutating func deleteEmoji(_ emoji: Emoji) {
        emojis.remove(at: emojis.firstIndex(of: emoji)!)
        emojis_selected.remove(emoji)
    }
    
    
    
}

