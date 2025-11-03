import SwiftUI

struct PhotoCaptureView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)

                    Text("カメラビュー")
                        .font(.title2)
                        .foregroundStyle(.white)

                    Text("（サンプル実装）")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text("閉じる")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white.opacity(0.2))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    PhotoCaptureView()
}
