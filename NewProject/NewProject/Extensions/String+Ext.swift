import SwiftUI

extension String {    
    func uppercasedFirstChar() -> String {
        return prefix(1).uppercased() + self.dropFirst()
    }
}
