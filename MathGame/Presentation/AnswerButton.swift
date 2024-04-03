//
//  AnswerButton.swift
//  MathGame
//
//  Created by Antonie Sander on 2024/01/16.
//

import SwiftUI

struct AnswerButton: View {
    var text: String = ""
    var number: Int
    var width: Double = 110
    var height: Double = 110
    var font: Font = .system(size: 35, weight: .bold, design: .rounded)
    var buttonColor: Color = .cyan
    @Environment(\.colorScheme) var colorScheme
    
    var colorSchemeLightGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.cyan]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var colorSchemeDarkGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.black.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        VStack {
            Text("\(text)\(number)")
                .font(font)
                .frame(width: width, height: height)
                .background(
                    ZStack {
                        //buttonColor
                        colorScheme == .light ? buttonColor : .indigo.opacity(0.3)
                        
                        RoundedRectangle(cornerRadius: height/2, style: .continuous)
                            .foregroundStyle(colorScheme == .light ? buttonColor : .indigo.opacity(0.3))
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        
                        RoundedRectangle(cornerRadius: height/2, style: .continuous)
                            .fill(
                                colorScheme == .light ? colorSchemeLightGradient : colorSchemeDarkGradient
                            )
                            .padding(2)
                            .blur(radius: 2)
                    }
                )
                .foregroundColor(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: height/2, style: .continuous))
                .padding()
                .shadow(color: Color(.black).opacity(0.2), radius: 15, x: 10, y: 10)
        }
    }
}

struct AnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        @Environment(\.colorScheme) var colorScheme
        AnswerButton(number: 100)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(colorScheme == .light ? LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.cyan]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.4), Color.black]), startPoint: .top, endPoint: .bottom))
    }
}
