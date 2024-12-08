import Foundation

public enum MagicPacketError: Error {
    case socketSetupFailed(reason: String)
    case setSocketOptionFailed(reason: String)
    case sendMagicPacketFailed(reason: String)
}

public func sendMagicPacket(to macAddress: String, broadcast: String = "255.255.255.255", port: Int = 9, interfaceName: String = "en0") throws(MagicPacketError) {
    // socket file descriptor
    var fd: Int32
    var target = sockaddr_in()
    
    target.sin_family = sa_family_t(AF_INET)
    
    // check broadcast address (is an IP address or domain name)
    var broadcastAddress = inet_addr(broadcast)
    if broadcastAddress == INADDR_NONE {
        broadcastAddress = inet_addr(gethostbyname(broadcast))
    }
    target.sin_addr.s_addr = broadcastAddress
    
    let isLittleEndian = Int(OSHostByteOrder()) == OSLittleEndian
    target.sin_port = isLittleEndian ? _OSSwapInt16(UInt16(port)) : UInt16(port)
    
    // setup the packet socket
    fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
    if fd < 0 {
        let error = String(utf8String: strerror(errno)) ?? ""
        throw MagicPacketError.socketSetupFailed(reason: error)
    }
    
    let intLen = socklen_t(MemoryLayout<Int>.stride)
    
    // Get the network interface index for the specified interface
    var interfaceIndex = if_nametoindex(interfaceName)
    if setsockopt(fd, IPPROTO_IP, IP_BOUND_IF, &interfaceIndex, intLen) == -1 {
        close(fd)
        let error = String(utf8String: strerror(errno)) ?? ""
        throw MagicPacketError.setSocketOptionFailed(reason: error)
    }
    
    let packet = createMagicPacket(macAddress: macAddress)
    let sockAddressLength = socklen_t(MemoryLayout<sockaddr>.stride)
    
    // set socket option
    if setsockopt(fd, SOL_SOCKET, SO_BROADCAST, &broadcastAddress, intLen) == -1 {
        close(fd)
        let error = String(utf8String: strerror(errno)) ?? ""
        throw MagicPacketError.setSocketOptionFailed(reason: error)
    }
    
    // send magic packet
    var targetCast = unsafeBitCast(target, to: sockaddr.self)
    if sendto(fd, packet, packet.count, 0, &targetCast, sockAddressLength) != packet.count {
        close(fd)
        let error = String(utf8String: strerror(errno)) ?? ""
        throw MagicPacketError.sendMagicPacketFailed(reason: error)
    }
    
    close(fd)
}

private func createMagicPacket(macAddress: String) -> [CUnsignedChar] {
    var buffer = [CUnsignedChar]()
    
    // create header
    for _ in 1...6 {
        buffer.append(0xFF)
    }
    
    let components = macAddress.components(separatedBy: ":")
    let numbers = components.map {
        return strtoul($0, nil, 16)
    }
    
    // repeat MAC address 16 times
    for _ in 1...16 {
        for number in numbers {
            buffer.append(CUnsignedChar(number))
        }
    }
    
    return buffer
}
