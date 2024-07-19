import SwiftUI

struct CustomButton: View {
    
    //MARK: - Properties
    
    let title: String
    
    //MARK: - Init
    
    init(
        title: String
    ) {
        self.title = title
    }
    
    //MARK: - Body
    
    var body: some View {
        Rectangle()
            .foregroundColor(.turquoiseUniversal)
            .frame(height: 42)
            .cornerRadius(16)
            .overlay {
                HStack {
                    Text(title)
                        .font(.plexSansMedium18)
                        .foregroundStyle(.whiteUniversal)
                }
            }
    }
}

//MARK: - Preview

#Preview {
    CustomButton(title: "Button")
}
