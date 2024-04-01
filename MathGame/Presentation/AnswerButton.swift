//
//  AnswerButton.swift
//  MathGame
//
//  Created by Antonie Sander on 2024/01/16.
//

import SwiftUI

struct AnswerButton: View {
    var number : Int
    
    var body: some View {
        VStack {
            Text("\(number)")
                .font(.system(size: 35, weight: .bold, design: .rounded))
                .frame(width: 110, height: 110)
                .background(
                    ZStack {
                        Color.indigo
                        
                        RoundedRectangle(cornerRadius: 110/2, style: .continuous)
                            .foregroundStyle(.cyan)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        
                        RoundedRectangle(cornerRadius: 110/2, style: .continuous)
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.cyan]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .padding(2)
                            .blur(radius: 2)
                    }
                )
                .foregroundColor(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 110/2, style: .continuous))
                .padding()
                .shadow(color: Color(.secondaryLabel), radius: 15, x: 10, y: 10)
                .shadow(color: Color(.systemBackground), radius: 15, x: -10, y: -10)
        }
    }
}

struct AnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        AnswerButton(number: 100)
    }
}
