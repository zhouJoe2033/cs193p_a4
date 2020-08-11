//
//  OptionalImage.swift
//  cs193p_a4
//
//  Created by Joe on 2020-08-11.
//  Copyright © 2020 Joe. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}

