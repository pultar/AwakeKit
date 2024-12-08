import Testing
@testable import WakeOnLan

@Test func example() async throws {
    try sendMagicPacket(to: "c2:d4:ee:f4:cf:dd")
}
