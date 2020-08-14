//  EmojiArtDocument.swift
//  cs193p_a4
//
//  Created by Joe on 2020-08-11.
//  Copyright © 2020 Joe. All rights reserved.

import SwiftUI

class EmojiArtDocument: ObservableObject {
    
    static let palett: String = "1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣"
    
    private static let untitled = "EmojiArtDocument.Untitled"
    
    @Published private var emojiArt: EmojiArt = EmojiArt() {
        willSet { objectWillChange.send() }
        didSet { UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled) }
    }
    
    @Published private(set) var backgroundImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    var emojis_selected: Set<EmojiArt.Emoji> { emojiArt.emojis_selected }

    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        fetchBackgroundImageData()
    }
        
    // MARK: - Intents
    func deleteEmoji(_ emoji: EmojiArt.Emoji) {
        emojiArt.deleteEmoji(emoji)
    }
    
    func selectEmoji(_ emoji: EmojiArt.Emoji) {
        emojiArt.selectEmoji(emoji)
    }

    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by position: CGPoint) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x = Int(position.x)
            emojiArt.emojis[index].y = Int(position.y)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    func reSetSelectedEmojis() {
        emojiArt.reSetSelectedEmojis()
    }
    
    func setBackgroundURL(url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
    
    
    
}
