import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var settings: ClockSettings
    @State private var showFullscreen = false
    @State private var selectedTab = "Designer"

    private let fonts = ["Avenir Next", "Helvetica Neue", "SF Pro Rounded", "Georgia", "Baskerville", "Menlo", "Courier", "Didot"]
    private let weights: [(String, String)] = [
        ("Ultra Light", "ultraLight"), ("Thin", "thin"), ("Light", "light"),
        ("Regular", "regular"), ("Medium", "medium"), ("Semibold", "semibold"),
        ("Bold", "bold"), ("Heavy", "heavy"), ("Black", "black")
    ]

    var body: some View {
        HStack(spacing: 0) {
            sidebar
            VStack(spacing: 0) {
                header
                if selectedTab == "Designer" { designer }
                else { lockScreenInfo }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(nsColor: .windowBackgroundColor))
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showFullscreen) {
            FullscreenClockView()
                .environmentObject(settings)
        }
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(spacing: 10) {
                Image(systemName: "clock")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.cyan)
                Text("ClockStudio").font(.system(size: 19, weight: .semibold))
            }
            .padding(.top, 12)

            VStack(alignment: .leading, spacing: 8) {
                sidebarButton("Designer", icon: "slider.horizontal.3")
                sidebarButton("Lock Screen", icon: "lock")
            }

            Spacer()

            Text("VERSION 1.0")
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(width: 190)
        .background(Color.black.opacity(0.22))
    }

    private func sidebarButton(_ title: String, icon: String) -> some View {
        Button {
            selectedTab = title
        } label: {
            Label(title, systemImage: icon)
                .font(.system(size: 13, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 9)
                .padding(.horizontal, 10)
                .background(selectedTab == title ? Color.white.opacity(0.10) : .clear, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(selectedTab == "Designer" ? "Clock designer" : "Native Lock Screen")
                    .font(.system(size: 22, weight: .semibold))
                Text(selectedTab == "Designer" ? "Make the clock yours." : "What macOS allows us to customize.")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if selectedTab == "Designer" {
                Button {
                    showFullscreen = true
                } label: {
                    Label("Preview full screen", systemImage: "arrow.up.left.and.arrow.down.right")
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
            }
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 20)
    }

    private var designer: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                preview
                presets
                HStack(alignment: .top, spacing: 20) {
                    appearanceControls
                    formatControls
                }
            }
            .padding(26)
        }
    }

    private var preview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(colors: [Color(red: 0.07, green: 0.10, blue: 0.16), Color(red: 0.12, green: 0.16, blue: 0.24)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            VStack(spacing: 10) {
                ClockFace(compact: false)
                    .environmentObject(settings)
                Text("LIVE PREVIEW")
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .tracking(2.5)
                    .foregroundStyle(.white.opacity(0.35))
            }
            .padding(30)
        }
        .frame(height: 220)
    }

    private var presets: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Presets", subtitle: "Start with a look, then make it your own")
            HStack(spacing: 10) {
                ForEach(ClockPreset.all) { preset in
                    Button {
                        settings.applyPreset(preset)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("12:45")
                                .font(.custom(preset.font, size: 24).weight(weight(for: preset.weight)))
                                .foregroundStyle(Color(hex: preset.color) ?? .white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Text(preset.name)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.08)))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func weight(for name: String) -> Font.Weight {
        switch name {
        case "ultraLight": .ultraLight
        case "thin": .thin
        case "regular": .regular
        case "medium": .medium
        case "semibold": .semibold
        case "bold": .bold
        case "heavy": .heavy
        case "black": .black
        default: .light
        }
    }

    private var appearanceControls: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Typography", subtitle: "Font, weight and scale")
            VStack(alignment: .leading, spacing: 7) {
                controlLabel("FONT")
                Picker("Font", selection: $settings.fontName) {
                    ForEach(fonts, id: \.self) { Text($0).tag($0) }
                }
                .labelsHidden()
            }
            VStack(alignment: .leading, spacing: 7) {
                controlLabel("WEIGHT")
                Picker("Weight", selection: $settings.weightName) {
                    ForEach(weights, id: \.1) { Text($0.0).tag($0.1) }
                }
                .labelsHidden()
            }
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    controlLabel("SIZE")
                    Spacer()
                    Text("\(Int(settings.clockSize)) pt").font(.caption.monospacedDigit()).foregroundStyle(.secondary)
                }
                Slider(value: $settings.clockSize, in: 48...180)
                    .tint(.cyan)
            }
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    controlLabel("LETTER SPACING")
                    Spacer()
                    Text(settings.letterSpacing, format: .number.precision(.fractionLength(1))).font(.caption.monospacedDigit()).foregroundStyle(.secondary)
                }
                Slider(value: $settings.letterSpacing, in: -5...12)
                    .tint(.cyan)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 14))
    }

    private var formatControls: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Appearance", subtitle: "Colour and information")
            VStack(alignment: .leading, spacing: 8) {
                controlLabel("CLOCK COLOUR")
                ColorPicker("Choose colour", selection: Binding(
                    get: { settings.color },
                    set: { settings.colorHex = $0.hexString }
                ), supportsOpacity: false)
                .labelsHidden()
                HStack(spacing: 8) {
                    ForEach(["F5F5F7", "A7C7E7", "B9A0DC", "E8C07D", "F0A6B8", "A8D5BA"], id: \.self) { hex in
                        Circle()
                            .fill(Color(hex: hex) ?? .white)
                            .frame(width: 20, height: 20)
                            .overlay(Circle().stroke(.white.opacity(settings.colorHex == hex ? 0.9 : 0), lineWidth: 2).padding(-3))
                            .onTapGesture { settings.colorHex = hex }
                    }
                }
            }
            Divider().opacity(0.3)
            Toggle("Show date", isOn: $settings.showDate)
            Toggle("Show seconds", isOn: $settings.showSeconds)
            Toggle("24-hour time", isOn: $settings.use24Hour)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 14))
    }

    private var lockScreenInfo: some View {
        VStack(alignment: .leading, spacing: 18) {
            Label("Important macOS limitation", systemImage: "info.circle.fill")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.cyan)
            Text("Apple does not provide a public API that lets third-party apps replace or freely restyle the secure Lock Screen clock. ClockStudio will not use private APIs or risky system modifications.")
                .fixedSize(horizontal: false, vertical: true)
                .foregroundStyle(.secondary)
            Text("If your macOS version offers native clock appearance controls, you can change those in System Settings. ClockStudio's custom fonts, colours, weight and layout apply to its own full-screen clock experience.")
                .fixedSize(horizontal: false, vertical: true)
            Button {
                if let url = URL(string: "x-apple.systempreferences:com.apple.Desktop-Settings.extension") {
                    NSWorkspace.shared.open(url)
                } else {
                    NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Applications/System Settings.app"))
                }
            } label: {
                Label("Open System Settings", systemImage: "gear")
            }
            .buttonStyle(.borderedProminent)
            .tint(.cyan)
            Spacer()
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func sectionTitle(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).font(.system(size: 14, weight: .semibold))
            Text(subtitle).font(.system(size: 11)).foregroundStyle(.secondary)
        }
    }

    private func controlLabel(_ value: String) -> some View {
        Text(value).font(.system(size: 9, weight: .bold)).tracking(1.1).foregroundStyle(.secondary)
    }
}

extension Color {
    var hexString: String {
        let ns = NSColor(self).usingColorSpace(.deviceRGB) ?? NSColor.white
        return String(format: "%02X%02X%02X", Int(ns.redComponent * 255), Int(ns.greenComponent * 255), Int(ns.blueComponent * 255))
    }
}
