//
//  PinnedView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData

struct PinnedView: View {
    @Query(filter: #Predicate<Task> {$0.isPinned == true})
    private var tasks: [Task]

    var body: some View {
        // TODO: make pinniing actually an editable thing from UI perspective?
        VStack {
            Text("             Pinned Tasks       📌")
                .font(.title)
                .bold()
                .padding(.top)
            if tasks.count != 0 {
                ForEach(tasks) { task in
                    TaskView(task: task)
                }
            } else {
                Text("There are no pinned tasks!")
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 0.133, saturation: 0.898, brightness: 0.783)/*@END_MENU_TOKEN@*/)
                    .cornerRadius(10)
            }
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .frame(maxWidth: .infinity)
        // TODO: make a better UI for this box
        .background(.yellow)
        .cornerRadius(10)
    }
}

#Preview {
    PinnedView()
}
