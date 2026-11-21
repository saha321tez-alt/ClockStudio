import SwiftUI

struct ClockFace: View {
    @EnvironmentObject private var settings: ClockSettings
    var compact = false
    @State private var now = Date()

    private var timeText: String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = settings.use24Hour ? (settings.showSeconds ? "HH:mm:ss" : "HH:mm") : (settings.showSeconds ? "h:mm:ss" : "h:mm")
        return formatter.string(from: now)
    }

    private var dateText: String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: now).uppercased()
    }

    var body: some View {
        VStack(spacing: compact ? 4 : 12) {
            Text(timeText)
                .font(.custom(settings.fontName, size: compact ? 30 : settings.clockSize).weight(settings.fontWeight))
                .tracking(settings.letterSpacing)
                .foregroundStyle(settings.color)
                .contentTransition(.numericText())
                .minimumScaleFactor(0.35)
                .lineLimit(1)
            if settings.showDate {
                Text(dateText)
                    .font(.system(size: compact ? 9 : 12, weight: .medium, design: .rounded))
                    .tracking(compact ? 1.5 : 3)
                    .foregroundStyle(settings.color.opacity(0.65))
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { date in
            now = date
        }
    }
}

struct FullscreenClockView: View {
    @EnvironmentObject private var settings: ClockSettings
    @Environment(\.dismiss) private var dismiss
    @State private var backgroundStyle = 0

    private let backgrounds: [LinearGradient] = [
        LinearGradient(colors: [Color.black, Color(red: 0.07, green: 0.10, blue: 0.17)], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color(red: 0.08, green: 0.04, blue: 0.15), Color.black], startPoint: .top, endPoint: .bottom),
        LinearGradient(colors: [Color(red: 0.02, green: 0.12, blue: 0.14), Color.black], startPoint: .topLeading, endPoint: .bottomTrailing)
    ]

    var body: some View {
        ZStack {
            backgrounds[backgroundStyle].ignoresSafeArea()
            ClockFace()
                .environmentObject(settings)
                .padding(40)
            VStack {
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(.escape)
                }
                Spacer()
                HStack {
                    Text("CLICK BACKGROUND TO CHANGE AMBIENCE")
                        .font(.system(size: 9, weight: .medium))
                        .tracking(1.5)
                        .foregroundStyle(.white.opacity(0.25))
                    Spacer()
                    Text("ESC TO EXIT")
                        .font(.system(size: 9, weight: .medium))
                        .tracking(1.5)
                        .foregroundStyle(.white.opacity(0.25))
                }
            }
            .padding(28)
        }
        .contentShape(Rectangle())
        .onTapGesture { backgroundStyle = (backgroundStyle + 1) % backgrounds.count }
        .onAppear {
            NSApp.presentationOptions = [.autoHideDock, .autoHideMenuBar]
        }
        .onDisappear {
            NSApp.presentationOptions = []
        }
    }
}
