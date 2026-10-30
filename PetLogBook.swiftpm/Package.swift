// swift-tools-version: 6.0

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "PetLogBook",
    defaultLocalization: "en",
    platforms: [
        .iOS("27.0")
    ],
    products: [
        .iOSApplication(
            name: "PetLogBook",
            targets: ["AppModule"],
            bundleIdentifier: "com.chamala.petlogbook",
            teamIdentifier: "T3MS8GM9TK",
            displayVersion: "1.0.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .asset("AccentColor"),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            appCategory: .lifestyle,
            // Имя на домашнем экране и ответ на вопрос о шифровании при загрузке в App Store.
            additionalInfoPlistContentFilePath: "AdditionalInfo.plist"
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "Sources"
        )
    ]
)
