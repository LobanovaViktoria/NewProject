import SwiftUI

struct StatusView: View {
    
    //MARK: - Properties
    
    let status: Status
    
    //MARK: - Init
    
    init(status: Status) {
        self.status = status
    }
    
    //MARK: - Body
    
    var body: some View {
        Rectangle()
            .foregroundColor(status.color)
            .frame(height: 42)
            .cornerRadius(16)
            .overlay {
                HStack {
                    Text(status.rawValue.uppercasedFirstChar())
                        .font(.plexSansSemiBold16)
                        .foregroundStyle(.whiteUniversal)
                        .kerning(0.4)
                }
            }
    }
}

//MARK: - Preview

#Preview {
    StatusView(status: .alive)
}
