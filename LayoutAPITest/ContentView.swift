//
//  ContentView.swift
//  LayoutAPITest
//
//  Created by Daniel Spalek on 07/07/2022.
//


//The compactMap() method lets us transform the elements of an array just like map() does, except once the transformation completes an extra step happens: all optionals get unwrapped, and any nil values get discarded.
import SwiftUI

struct ContentView: View {
    @State var tags: [Tag] = rawTags.compactMap { tag -> Tag? in
        return .init(name: tag) // Make tag array.
    }
    var body: some View {
        NavigationStack{
            VStack{
//                 MARK: New toggle API
//                Toggle("SwiftUI", isOn: .constant(false))
//                    .toggleStyle(.button) // we don't want a switch
//                    .buttonStyle(.bordered)
//                    .tint(.red)
                TagView(alignment: .center, spacing: 10){
                    ForEach($tags) { $tag in
                        Toggle("SwiftUI", isOn: $tag.isSelected)
                            .toggleStyle(.button) // we don't want a switch
                            .buttonStyle(.bordered)
                            .tint(.red)
                    }
                }
            }
            .padding(15)
            .navigationTitle("Layout")
        }
    }
}

// MARK: Building the custom layout with the new layout API
struct TagView: Layout{
    var alignment: Alignment = .center
    var spacing: CGFloat = 10
    // new Xcode 14 completes the entire init by itself , just type init
    init(alignment: Alignment, spacing: CGFloat) {
        self.alignment = alignment
        self.spacing = spacing
    }
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        // Returning default proposal size
        return .init(width: proposal.width ?? 0, height: proposal.height ?? 0)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // MARK: Placing view
        // For testing
        
        // note that origin starts from applied padding from parent view
        var origin = bounds.origin
        var maxWidth = bounds.width
        
        subviews.forEach { view in
            let viewSize = view.sizeThatFits(proposal)
            view.place(at: origin, proposal: proposal)
            origin.x += viewSize.width
        }
    }
    
    
}

// MARK: String tags
var rawTags: [String] = [
    "SwiftUI", "Xcode", "Apple", "WWDC22", "iOS 16", "iPadOS 16", "macOS 13", "watchOS 9", "Xcode 14", "APIs"
]

// MARK: Model for the tags
struct Tag: Identifiable{
    var id = UUID().uuidString
    var name: String
    var isSelected: Bool = false
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
