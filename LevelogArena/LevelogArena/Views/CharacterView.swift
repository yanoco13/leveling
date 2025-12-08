import SwiftUI
import Lottie

/// LottieアニメをSwiftUI上で再生するキャラビュー
struct CharacterView: View {
    let animationName: String
    var loopMode: LottieLoopMode = .loop
    var speed: CGFloat = 1.0

    var body: some View {
        LottieView(animation: .named(animationName))
            .playing(loopMode: loopMode)
            .animationSpeed(speed)
            .frame(width: 220, height: 220)
    }
}
