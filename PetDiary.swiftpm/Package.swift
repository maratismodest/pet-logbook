// swift-tools-version: 6.0

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "PetDiary",
    platforms: [
        .iOS("27.0")
    ],
    products: [
        .iOSApplication(
            name: "PetDiary",
            targets: ["AppModule"],
            bundleIdentifier: "com.petlogbook.PetDiary",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .dog),
            accentColor: .presetColor(.orange),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "Sources"
        )
    ]
)
