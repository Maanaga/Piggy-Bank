import SwiftUI

struct AmountSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let isActive: Bool
    var onActivate: () -> Void

    private let trackHeight: CGFloat = 8
    private let thumbSize: CGFloat = 28

    private var fraction: Double {
        let span = range.upperBound - range.lowerBound
        guard span > 0 else { return 0 }
        return (value - range.lowerBound) / span
    }

    var body: some View {
        GeometryReader { geo in
            let usableWidth = geo.size.width - thumbSize
            let thumbX = usableWidth * fraction

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(height: trackHeight)

                Capsule()
                    .fill(Color("primaryBlue"))
                    .frame(width: thumbX + thumbSize / 2, height: trackHeight)

                Circle()
                    .fill(.white)
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    .overlay(
                        Circle()
                            .fill(Color("primaryBlue"))
                            .frame(width: 14, height: 14)
                    )
                    .offset(x: thumbX)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { drag in
                                if !isActive { onActivate() }
                                let newX = min(max(drag.location.x - thumbSize / 2, 0), usableWidth)
                                let newFraction = newX / usableWidth
                                let span = range.upperBound - range.lowerBound
                                value = range.lowerBound + span * newFraction
                            }
                    )
            }
            .frame(height: thumbSize)
        }
        .frame(height: thumbSize)
        .contentShape(Rectangle())
        .onTapGesture { location in
            if !isActive { onActivate() }
            let usableWidth = UIScreen.main.bounds.width - 40 - thumbSize
            let tappedX = min(max(location.x - thumbSize / 2, 0), usableWidth)
            let newFraction = tappedX / usableWidth
            let span = range.upperBound - range.lowerBound
            withAnimation(.easeOut(duration: 0.15)) {
                value = range.lowerBound + span * newFraction
            }
        }
    }
}
