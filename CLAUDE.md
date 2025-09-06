# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is **IPaPods**, a comprehensive collection of iOS utility libraries and frameworks developed by ipapamagic. The repository contains 38+ individual CocoaPods, each with multiple versions, organized in a private pods collection structure.

## Architecture & Structure

### Organization Pattern
- Each library follows the pattern: `LibraryName/Version/LibraryName.podspec`
- Libraries are versioned independently with semantic versioning
- All libraries target iOS 11.0+ and use Swift 5.3+
- Common dependency hierarchy: Many libraries depend on `IPaUIKitHelper` and `IPaLog`

### Core Library Categories

**UI Components & Extensions:**
- `IPaDesignableUI` - Interface Builder designable components with subspecs (IPaDesignable, IPaFitContent, IPaImageURL, IPaNestedScrollView, IPaStyleButton)
- `IPaUIKitHelper` - UIKit utility functions and extensions
- `IPaSwiftUIHelper` - SwiftUI utility functions and extensions
- `IPaIndicator` - Loading indicators and progress views
- `IPaCollectionViewLayout` - Custom collection view layouts

**Media & Image Processing:**
- `IPaAVCamera` - Camera utilities and AVFoundation helpers
- `IPaAVPlayer` - Audio and video player utilities
- `IPaImageTool` - Image processing and manipulation tools
- `IPaImageURLLoader` - Asynchronous image loading from URLs
- `IPaImagePreviewer` - Image preview and gallery components

**Data Management:**
- `IPaCoreDataController` - Core Data controller and management tools
- `IPaFileCache` - File caching and management system
- `IPaDownloadManager` - File download management utilities
- `IPaCSVParser` - CSV file parsing utilities

**Networking & APIs:**
- `IPaReachability` - Network reachability monitoring
- `IPaNetworkState` - Network connectivity state monitoring
- `IPaFBKit` - Facebook SDK integration utilities
- `IPaFlickr` - Flickr API integration utilities
- `IPaImgur` - Imgur API integration utilities

**Security & Data Storage:**
- `IPaSecurity` - Security utilities and encryption tools
- `IPaKeyChain` - Keychain access and management utilities
- `IPaStoreKit` - App Store and in-app purchase utilities

**Utility Libraries:**
- `IPaLog` - Logging utilities and debugging tools
- `IPaBlockOperation` - Block-based operation utilities
- `IPaPageController` - Page view controller utilities

## Development Commands

### CocoaPods Validation
```bash
pod lib lint <PodName>.podspec
```
Use this to validate podspec files before submitting updates.

### Common Pod Operations
```bash
# Check pod syntax
pod spec lint <PodName>.podspec

# Search for dependencies
pod search <DependencyName>

# Update local pod repo
pod repo update
```

## Swift Package Manager Support

The repository includes `collection.json` which defines SPM package collections for all libraries. This allows easy integration via Xcode's Package Collections feature.

### Adding to Xcode
1. Use the collection.json URL to add the entire collection
2. Individual packages can be added using their GitHub URLs
3. All packages support Swift 5.0+ toolchain

## Key Dependencies & Relationships

### Common Base Dependencies
- `IPaUIKitHelper` - Used by most UI-related pods
- `IPaLog` - Logging framework used across many pods

### Complex Dependency Examples
- `IPaDesignableUI/IPaImageURL` depends on `IPaDownloadManager`, `IPaImageTool`, and `IPaFileCache`
- Many UI components depend on the base `IPaDesignable` subspec

## Version Management

- Libraries use independent versioning
- Latest versions are maintained in collection.json
- Multiple versions coexist in the repository structure
- Check collection.json for current stable versions

## Testing & Validation

- Use `pod lib lint` for individual pod validation
- Test iOS deployment target compatibility (minimum iOS 11.0)
- Verify Swift version compatibility (5.3+)
- Check inter-pod dependencies for version compatibility

## Working with Subspecs

Many pods use subspecs for modular functionality:

```ruby
# Example: IPaDesignableUI
s.subspec 'IPaDesignable' do |sp|
  sp.source_files = 'IPaDesignableUI/Classes/IPaDesignable/*'
end

s.subspec 'IPaImageURL' do |sp|
  sp.dependency 'IPaDesignableUI/IPaDesignable'
  # Additional dependencies...
end
```

When working with pods that have subspecs, understand the dependency chain and ensure proper subspec targeting.