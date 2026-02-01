import SwiftUI

@main
struct PyDojoApp: App {
    @StateObject private var vm = AppVM()
    var body: some Scene {
        WindowGroup { RootView().environmentObject(vm) }
    }
}
