import Testing
@testable import ARCUIComponents

struct ARCUIComponentsTests {
    @Test
    func versionIsNotEmpty() {
        #expect(!ARCUIComponents.version.isEmpty)
    }

    @Test
    func infoContainsVersion() {
        #expect(ARCUIComponents.info.contains(ARCUIComponents.version))
    }

    @Test
    func infoContainsComponentsList() {
        let info = ARCUIComponents.info
        #expect(info.contains("ARCMenu"))
        #expect(info.contains("ARCFavoriteButton"))
        #expect(info.contains("ARCListCard"))
    }
}
