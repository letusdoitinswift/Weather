//
//  DoneButtonView.swift
//  WeatherApp
//
//  Created by Manish Gupta on 10/18/24.
//

import SwiftUI

struct DoneButtonView: View {
    @Environment (\.dismiss) var dismiss
    var body: some View {
        Text("Done")
            .fontWeight(.bold)
            .font(.system(size: 10))
            .foregroundStyle(Color.accentColor)
            .padding([.leading, .trailing, .bottom, .top], 7)
            .background(.blue)
            .cornerRadius(4)
            .onTapGesture {
                dismiss()
            }
    }
}

#Preview {
    DoneButtonView()
}
