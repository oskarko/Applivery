//
//  MarvelComicsAppApp.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import SwiftUI
import AppKit

@main
struct MarvelComicsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {}
    }
}

// MARK: - AppDelegate
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusBar()
    }

    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem?.button?.image = NSImage(systemSymbolName: "book", accessibilityDescription: nil)
        statusItem?.button?.action = #selector(togglePopover)

        popover = NSPopover()
        popover?.contentSize = NSSize(width: 600, height: 600)
        popover?.behavior = .transient
        let apiService = MarvelAPIService() // or LocalService()
        let repository = MarvelRepository(service: apiService)
        let useCase = FetchComicsUseCaseImpl(repository: repository)
        let viewModel = ComicListViewModel(fetchComicsUseCase: useCase)
        popover?.contentViewController = NSHostingController(rootView: ComicListView(viewModel: viewModel))
    }

    @objc private func togglePopover() {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(nil)
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
