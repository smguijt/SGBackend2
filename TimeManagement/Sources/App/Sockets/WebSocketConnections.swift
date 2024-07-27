import Vapor
import NIO
import NIOConcurrencyHelpers

final class WebSocketConnections {
    private var connections: [UUID: WebSocket] = [:]
    private let lock = Lock()

    func add(_ ws: WebSocket) {
        let id = UUID()
        lock.withLockVoid {
            print("WebSocketConnections:add -> id: \(id.uuidString)")
            connections[id] = ws
        }
        ws.onClose.whenComplete { [weak self] _ in
            print("WebSocketConnections:onClose")
            self?.remove(id)
        }
    }

    func remove(_ id: UUID) {
        lock.withLockVoid {
            print("WebSocketConnections:remove --> id: \(id.uuidString)")
            connections.removeValue(forKey: id)
        }
    }

    func closeAll() {
        lock.withLockVoid {
            print("WebSocketConnections:closeAll")
            connections.values.forEach { $0.close(promise: nil) }
            connections.removeAll()
        }
    }
}

struct WebSocketShutdown: LifecycleHandler {
    func shutdown(_ application: Application) {
        print("WebSocketConnections:WebSocketShutdown")
        application.webSocketConnections.closeAll()
    }
}

extension Application {
    
    private struct WebSocketConnectionsKey: StorageKey {
        typealias Value = WebSocketConnections
    }

    var webSocketConnections: WebSocketConnections {
        if let existing = storage[WebSocketConnectionsKey.self] {
            return existing
        } else {
            let new = WebSocketConnections()
            storage[WebSocketConnectionsKey.self] = new
            return new
        }
    }
}
