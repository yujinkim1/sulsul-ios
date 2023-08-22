import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    static let bundleID = "bumjun.SulSul-iOS"
    static let iosVersion = "16.2"
    
    /// Helper function to create the Project for this ExampleApp
    public static func app(
        name: String,
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return self.project(
            name: name,
            product: .app,
            bundleID: bundleID + "\(name)",
            dependencies: dependencies,
            resources: resources
        )
    }
}

extension Project {
    public static func framework(name: String,
                                 dependencies: [TargetDependency] = [],
                                 resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return .project(name: name,
                        product: .framework,
                        bundleID: bundleID + ".\(name)",
                        dependencies: dependencies,
                        resources: resources)
    }
    
    public static func project(
        name: String,
        product: Product,
        bundleID: String,
        schemes: [Scheme] = [],
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return Project(
            name: name,
            targets: [
                Target(
                    name: name,
                    platform: .iOS,
                    product: product,
                    bundleId: bundleID,
                    deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone, .ipad]),
                    infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
                    sources: ["Sources/**"],
                    resources: resources,
                    dependencies: dependencies
                )
            ],
            schemes: schemes
        )
    }
}

public extension TargetDependency {
    static let alamofire: TargetDependency = .external(name: "Alamofire")
    static let snapKit: TargetDependency = .external(name: "SnapKit")
    static let swinject: TargetDependency = .external(name: "Swinject")
    static let then: TargetDependency = .external(name: "Then")
}

