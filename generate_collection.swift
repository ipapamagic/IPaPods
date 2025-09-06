#!/usr/bin/env swift

import Foundation

// Base paths
let ipaPodsPath = "/Users/ipapa/Documents/MyWork/iOSLibrary/IPaPods"
let sourceLibraryPath = "/Users/ipapa/Documents/MyWork/iOSLibrary"

// Collection JSON structures
struct CollectionJSON: Codable {
    let formatVersion: String
    let generatedAt: String
    let generatedBy: GeneratedBy
    let keywords: [String]
    let name: String
    let overview: String
    let packages: [Package]
    
    struct GeneratedBy: Codable {
        let name: String
    }
}

struct Package: Codable {
    let keywords: [String]
    let license: License?
    let readmeURL: String?
    let summary: String
    let url: String
    let versions: [Version]
    
    struct License: Codable {
        let name: String
        let url: String
    }
}

struct Version: Codable {
    let defaultToolsVersion: String
    let manifests: [String: Manifest]
    let summary: String
    let version: String
}

struct Manifest: Codable {
    let minimumPlatformVersions: [PlatformVersion]?
    let packageName: String
    let products: [Product]
    let targets: [Target]
    let toolsVersion: String
}

struct PlatformVersion: Codable {
    let name: String
    let version: String
}

struct Product: Codable {
    let name: String
    let targets: [String]
    let type: ProductType
}

struct ProductType: Codable {
    let library: [String]
}

struct Target: Codable {
    let moduleName: String
    let name: String
}


// Convert camelCase to kebab-case for SPM package names
func convertToKebabCase(_ camelCase: String) -> String {
    var result = camelCase
    
    // Replace IPa prefix
    result = result.replacingOccurrences(of: "IPa", with: "ipa-")
    
    // Handle specific common abbreviations first
    let abbreviations = [
        "BLE": "ble",
        "AV": "av", 
        "CSV": "csv",
        "FB": "fb",
        "UI": "ui",
        "VR": "vr",
        "XML": "xml",
        "URL": "url"
    ]
    
    for (abbr, replacement) in abbreviations {
        result = result.replacingOccurrences(of: abbr, with: "-\(replacement)")
    }
    
    // Handle normal camelCase transitions
    result = result.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1-$2", options: .regularExpression)
    
    // Clean up and lowercase
    result = result.lowercased()
        .replacingOccurrences(of: "--", with: "-")
        .replacingOccurrences(of: "^-", with: "", options: .regularExpression)
        .replacingOccurrences(of: "-$", with: "", options: .regularExpression)
    
    return result
}

// Get all versions from IPaPods directory
func getAllVersionsFromIPaPods(for packageName: String) -> [String] {
    let packagePath = "\(ipaPodsPath)/\(packageName)"
    
    guard let contents = try? FileManager.default.contentsOfDirectory(atPath: packagePath) else {
        print("⚠️  \(packageName): Could not read IPaPods directory")
        return []
    }
    
    // Filter out non-version directories (like .DS_Store)
    let versionDirs = contents.filter { item in
        var isDir: ObjCBool = false
        let fullPath = "\(packagePath)/\(item)"
        return FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) && 
               isDir.boolValue && 
               !item.hasPrefix(".")
    }
    
    // Sort versions from newest to oldest
    let sortedVersions = versionDirs.sorted { version1, version2 in
        return version1.compare(version2, options: .numeric) == .orderedDescending
    }
    
    print("✅ \(packageName): Found \(sortedVersions.count) versions [\(sortedVersions.joined(separator: ", "))]")
    return sortedVersions
}

// All available packages (only those that exist locally and have Package.swift)
func getAllPackages() -> [String] {
    return [
        "IPaAppleSignIn", "IPaAVCamera", "IPaAVPlayer", "IPaBLEKit",
        "IPaBlockOperation", "IPaCoreData", "IPaCSVParser", 
        "IPaDataPagerUI", "IPaDownloadManager", "IPaFBKit", 
        "IPaFileCache", "IPaFlickr", "IPaImagePreviewer",
        "IPaImageTool", "IPaImgur", "IPaIndicator", 
        "IPaInfiniteScrollController", "IPaKeyChain", "IPaLog", 
        "IPaMarqueeView", "IPaPageController", "IPaPickerUI",
        "IPaSecurity", "IPaStoreKit", "IPaSwiftUIHelper", "IPaSwiftUIView",
        "IPaTokenView", "IPaUIKitHelper", "IPaURLResourceUI", 
        "IPaVRKit", "IPaXMLSection"
    ]
}


// Parse Package.swift from local path
func parsePackageSwift(at path: String, packageName: String, spmPackageName: String) -> (products: [Product], targets: [Target], toolsVersion: String, platforms: [PlatformVersion]?)? {
    let packageSwiftPath = "\(path)/Package.swift"
    
    guard FileManager.default.fileExists(atPath: packageSwiftPath) else {
        print("⚠️  Package.swift not found at \(packageSwiftPath)")
        return nil
    }
    
    guard let content = try? String(contentsOfFile: packageSwiftPath, encoding: .utf8) else {
        print("⚠️  Failed to read Package.swift for \(packageName)")
        return nil
    }
    
    // Basic parsing - this is simplified and may need adjustment for complex Package.swift files
    var products: [Product] = []
    var targets: [Target] = []
    var toolsVersion = "5.7"
    var platforms: [PlatformVersion]? = nil
    
    // Extract tools version
    if let toolsMatch = content.range(of: #"// swift-tools-version:\s*([0-9.]+)"#, options: .regularExpression) {
        let versionString = String(content[toolsMatch])
        if let versionRange = versionString.range(of: #"[0-9.]+"#, options: .regularExpression) {
            toolsVersion = String(versionString[versionRange])
        }
    }
    
    // Simple product extraction (assumes library products)
    products.append(Product(
        name: spmPackageName,
        targets: [spmPackageName],
        type: ProductType(library: ["automatic"])
    ))
    
    // Simple target extraction
    targets.append(Target(
        moduleName: spmPackageName,
        name: spmPackageName
    ))
    
    // Check for iOS platform requirement
    if content.contains(".iOS") {
        platforms = [PlatformVersion(name: "ios", version: "11.0")]
    }
    
    return (products: products, targets: targets, toolsVersion: toolsVersion, platforms: platforms)
}

// Generate collection JSON
func generateCollectionJSON() {
    print("🚀 Starting IPaPods Collection Generator")
    print("==========================================")
    
    let packageNames = getAllPackages()
    print("📋 Processing \(packageNames.count) packages")
    print("📍 Using IPaPods directory versions")
    
    var packages: [Package] = []
    
    for packageName in packageNames {
        print("\n🔨 Processing \(packageName)...")
        
        // Convert to kebab-case for SPM
        let spmPackageName = convertToKebabCase(packageName)
        print("📝 SPM name: \(spmPackageName)")
        
        // Get all versions from IPaPods directory
        let versions = getAllVersionsFromIPaPods(for: packageName)
        guard !versions.isEmpty else {
            print("⚠️  \(packageName): No versions found, skipping")
            continue
        }
        
        // Parse Package.swift from source library (use for all versions)
        var products: [Product] = []
        var targets: [Target] = []
        var toolsVersion = "5.7"
        var platforms: [PlatformVersion]? = nil
        
        let packagePath = "\(sourceLibraryPath)/\(packageName)"
        if let parsed = parsePackageSwift(at: packagePath, packageName: packageName, spmPackageName: spmPackageName) {
            products = parsed.products
            targets = parsed.targets
            toolsVersion = parsed.toolsVersion
            platforms = parsed.platforms
        } else {
            // Fallback to basic structure
            products = [Product(name: spmPackageName, targets: [spmPackageName], type: ProductType(library: ["automatic"]))]
            targets = [Target(moduleName: spmPackageName, name: spmPackageName)]
        }
        
        // Create manifest
        let manifest = Manifest(
            minimumPlatformVersions: platforms,
            packageName: spmPackageName,
            products: products,
            targets: targets,
            toolsVersion: toolsVersion
        )
        
        // Create version objects for all available versions
        var packageVersions: [Version] = []
        for version in versions {
            let packageVersion = Version(
                defaultToolsVersion: toolsVersion,
                manifests: [toolsVersion: manifest],
                summary: "",
                version: version
            )
            packageVersions.append(packageVersion)
        }
        
        // Create package
        let package = Package(
            keywords: [],
            license: Package.License(
                name: "MIT",
                url: "https://raw.githubusercontent.com/ipapamagic/\(packageName)/master/LICENSE"
            ),
            readmeURL: "https://raw.githubusercontent.com/ipapamagic/\(packageName)/master/README.md",
            summary: "iOS utility library \(packageName)",
            url: "https://github.com/ipapamagic/\(packageName).git",
            versions: packageVersions
        )
        
        packages.append(package)
        print("✅ Added \(packageName)")
        
    }
    
    // Create collection
    let collection = CollectionJSON(
        formatVersion: "1.0",
        generatedAt: ISO8601DateFormatter().string(from: Date()),
        generatedBy: CollectionJSON.GeneratedBy(name: "ipapamagic"),
        keywords: ["ios", "swift", "utilities"],
        name: "IPaPods Collection",
        overview: "A collection of iOS utility libraries and frameworks developed by ipapamagic",
        packages: packages
    )
    
    // Write to file
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(collection)
        
        try jsonData.write(to: URL(fileURLWithPath: "docs/collection.json"))
        print("\n✅ Collection generated successfully!")
        print("📁 Output file: docs/collection.json")
        print("📊 Total packages: \(packages.count)")
    } catch {
        print("❌ Failed to write collection.json: \(error)")
        exit(1)
    }
}

// Sign collection with certificates
func signCollection() {
    print("\n🔐 Signing collection...")
    
    let process = Process()
    process.launchPath = "./package-collection-sign"
    process.arguments = [
        "docs/collection.json",
        "docs/collection-signed.json", 
        "swift_package_rsa.pem",
        "swift_package.cer",
        "AppleWWDRCAG3.cer",
        "AppleRootCA.cer"
    ]
    
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe
    
    do {
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus == 0 {
            print("✅ Collection signed successfully!")
            print("📁 Signed file: docs/collection-signed.json")
        } else {
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ Signing failed: \(output)")
            exit(1)
        }
    } catch {
        print("❌ Failed to run signing tool: \(error)")
        exit(1)
    }
}

// Parse command line arguments
let shouldSign = CommandLine.arguments.contains("--sign")
let showHelp = CommandLine.arguments.contains("--help")

// Print usage
if showHelp {
    print("IPaPods Collection Generator")
    print("============================")
    print("Generates Swift Package Collection from IPaPods directory versions")
    print("")
    print("Usage:")
    print("  ./generate_collection.swift                    # Generate collection.json")
    print("  ./generate_collection.swift --sign             # Generate and sign collection")
    print("  ./generate_collection.swift --help             # Show this help")
    print("")
    print("Signing requires:")
    print("  - package-collection-sign (Apple's signing tool)")
    print("  - swift_package.cer (Your certificate)")
    print("  - swift_package_rsa.pem (Your private key)")
    print("  - AppleWWDRCAG3.cer (Apple intermediate certificate)")
    print("  - AppleRootCA.cer (Apple root certificate)")
    exit(0)
}

// Main execution
generateCollectionJSON()

if shouldSign {
    signCollection()
}