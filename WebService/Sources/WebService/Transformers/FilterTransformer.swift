import Foundation
import Apodini
import NIO

struct FilterTransformer: ResponseTransformer {

    let excludedIDParameter: Parameter<UUID>
    
    init(_ excludedID: Parameter<UUID>) {
        self.excludedIDParameter = excludedID
    }
    
    func transform(content: [User]) -> [User] {
        let excludedID = excludedIDParameter.wrappedValue
        return content
            .filter { $0.id != nil && $0.id != excludedID }
            .sorted { $0.name < $1.name }
    }
}
