//
//  URLSession.swift
//  character
//
//  Created by abimanyu on 22/01/21.
//

import UIKit
import SystemConfiguration

extension URLSession {
    
    class func connectedToNetwork() -> Bool {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        guard let networkReachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else { return false }
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilitySetDispatchQueue(networkReachability, DispatchQueue.global(qos: .default))
        if SCNetworkReachabilityGetFlags(networkReachability, &flags) == false { return false }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return isReachable && !needsConnection
    }
}
