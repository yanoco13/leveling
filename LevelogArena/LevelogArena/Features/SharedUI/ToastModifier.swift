//
//  ToastModifier.swift
//  LevelogArena
//

import SwiftUI


struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            if let t = toast {
                Text(t.message)
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Capsule().fill(.thinMaterial))
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 2) { withAnimation { toast = nil } } }
            }
        }
        .animation(.spring, value: toast != nil)
    }
}


extension View { func toast(_ binding: Binding<Toast?>) -> some View { self.modifier(ToastModifier(toast: binding)) } }
