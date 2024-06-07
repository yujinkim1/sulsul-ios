import ProjectDescription

let config = Config(
    compatibleXcodeVersions: .all,
    swiftVersion: "5.0",
    plugins: [
        .local(path: .relativeToManifest("../../Plugins/EnvironmentPlugin")),
    ],
    generationOptions: .options()
)
