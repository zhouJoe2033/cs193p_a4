//
//  ContentView.swift
//  cs193p_a4
//
//  Created by Joe on 2020-08-11.
//  Copyright © 2020 Joe. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palett.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defaultEmojiSize))
                            .onDrag{ return NSItemProvider(object: emoji as NSItemProviderWriting) }
                    }
                }
            }
            .padding(.horizontal)
            
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(OptionalImage(uiImage: self.document.backgroundImage)
                        .scaleEffect(self.zoomScale)
                    )

                    ForEach(self.document.emojis) { emoji in
                        Text(emoji.text)
                            .underline(self.document.emojis_selected.contains(emoji), color: .black)
                            .font(animatableWithSize: emoji.fontSize * self.zoomScale)
                            .position(self.position(for: emoji, in: geometry.size))
                            .gesture(self.selectEmojisGesture(emoji))
                            .gesture(self.deleteEmojiGesture(emoji))
                            .gesture(self.dragEmojisGesture(emoji))
                    }
                }
                .clipped()
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - self.panOffSet.width, y: location.y - self.panOffSet.height)
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    
                    return self.drop(providers: providers, at: location)
                }
                .gesture(self.tapBackgroundGesture())
            }
        }
    }
    

    
    
    
    
    
    
    
    
    
    
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0

    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func tapBackgroundGesture() -> some Gesture {
        TapGesture(count: 1)
            .onEnded { self.document.reSetSelectedEmojis()}
    }
    
    private func deleteEmojiGesture(_ emoji: EmojiArt.Emoji) -> some Gesture {
        LongPressGesture(minimumDuration: 1)
            .onEnded { _ in
                self.document.deleteEmoji(emoji)
        }
    }
    
    private func selectEmojisGesture(_ emoji: EmojiArt.Emoji) -> some Gesture {
        TapGesture(count: 1)
            .onEnded { self.document.selectEmoji(emoji) }
    }
    
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero

    private var panOffSet: CGSize {
        (steadyStatePanOffset + gesturePanOffset ) * zoomScale
    }
    
    private func dragEmojisGesture(_ emoji: EmojiArt.Emoji) -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transcation in
                gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
            }
            .onEnded { finalDragGestureValue in
                self.steadyStatePanOffset = self.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
            }
            .exclusively(before: selectEmojisGesture(emoji))
    }
  
    


    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
    
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)

        if self.document.emojis_selected.count == 0 {
            location = CGPoint(x: location.x + panOffSet.width, y: location.y + panOffSet.height)
        } else {
            if self.document.emojis_selected.contains(emoji) {
                location = CGPoint(x: location.x + panOffSet.width, y: location.y + panOffSet.height)
            }
        }
 
        return location
    }

    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.setBackgroundURL(url: url)
        }
        
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }

    private let defaultEmojiSize: CGFloat = 40
}















