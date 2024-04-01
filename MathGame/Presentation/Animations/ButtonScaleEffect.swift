//
//  ButtonScaleEffect.swift
//  MathGame
//
//  Created by Antonie Sander on 2024/04/01.
//

import SwiftUI

struct ButtonScaleEffect: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
