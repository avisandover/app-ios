import Foundation
import os.log

protocol CenMatcher {
    func hasMatches(key: CENKey, maxTimestamp: Int64) -> Bool
}

class CenMatcherImpl: CenMatcher {
    private let cenRepo: CENRepo // TODO decouple from DB
    private let cenLogic: CenLogic

    init(cenRepo: CENRepo, cenLogic: CenLogic) {
        self.cenRepo = cenRepo
        self.cenLogic = cenLogic
    }

    func hasMatches(key: CENKey, maxTimestamp: Int64) -> Bool {
        !match(key: key, maxTimestamp: maxTimestamp).isEmpty
    }

    // Copied from Android implementation
    private func match(key: CENKey, maxTimestamp: Int64) -> [CEN] {

        // Unclear why maxTimestamp is a parameter
        let maxTimestamp = Date().coEpiTimestamp

        let interval: Int64 = 7 * 24 * 60 * 60
        
        // take the last 7 days of timestamps and generate all the possible CENs (e.g. 7 days) TODO: Parallelize this?
        let minTimestamp: Int64 = maxTimestamp - interval
        let CENLifetimeInSeconds = 15 * 60   // every 15 mins a new CEN is generated

        // last time (unix timestamp) the CENKeys were requested

        let max = Int(Double(interval)/Double(CENLifetimeInSeconds))

        var possibleCENs: [String] = []
        possibleCENs.reserveCapacity(max)

        for i in 0...max {
            let ts = maxTimestamp - Int64(CENLifetimeInSeconds * i)
            let cen = cenLogic.generateCen(CENKey: key.cenKey, timestamp: ts)
//            possibleCENs[i] = cen.toHex()
            possibleCENs.append(cen.toHex()) // No fixed size array
        }

        os_log("Generated results for key: %@, possible CENs count: %@, CENs: %@", log: servicesLog, type: .debug, key.cenKey,
               "\(possibleCENs.count)", "\(possibleCENs)")

//        let currentlyStoredCens = cenRepo.loadAllCENRecords()
//        os_log("Currently stored CENs: %@, minTime: %@, maxtime: %@", log: servicesLog, type: .debug,
//               "\(String(describing: currentlyStoredCens))", "\(minTimestamp)", "\(maxTimestamp)")

        return cenRepo.match(start: minTimestamp, end: maxTimestamp, hexEncodedCENs: possibleCENs)
    }
}
