import Testing
@testable import AwakeKit

@Test func example() async throws {
    try sendMagicPacket(to: "c2:d4:ee:f4:cf:dd", broadcast: "255.255.255.255", port: 9, interfaceName: "en0")
}
