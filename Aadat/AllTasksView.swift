//
//  PinnedView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData

struct AllTasksView: View {
    @Query private var tasks: [Task]

    var body: some View {
        VStack {
            Text("All Tasks")
                .font(.title)
                .bold()
                .padding(.top)
                .multilineTextAlignment(.center)
            if tasks.count != 0 {
                ForEach(tasks) { task in
                    TaskView(task: task)
                }
            } else {
                Text("There are no tasks!")
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 0.572, saturation: 0.644, brightness: 0.831)/*@END_MENU_TOKEN@*/)
                    .cornerRadius(10)
            }
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .frame(maxWidth: .infinity)
        // TODO: make a better UI for this box
        .background(Color(red: 0.341, green: 0.6431372549019608, blue: 1.0))
        .cornerRadius(10)
    }
}

#Preview {
    AllTasksView()
}
