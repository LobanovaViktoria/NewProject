import SwiftUI

struct SelectedFilterCell: View {
    
    // MARK: - Properties
    
    let isReset: Bool
    let title: String
    let action: () -> ()
    
    // MARK: - Init
    
    init(
        isReset: Bool,
        title: String,
        action: @escaping () -> ()
    ) {
        self.isReset = isReset
        self.title = title
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button {
            action()
        } label: {
                Text(title)
                    .font(.plexSansRegular8)
                    .foregroundStyle(
                    isReset
                    ? .whiteUniversal
                    : .blackUniversal
                    )
            .padding(.horizontal, 16)
            .padding(.vertical, 6.5)
           
            .background(
                isReset
                ? Color.turquoiseUniversal
                : Color.whiteUniversal
             )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16.85
                )
            )
        }
    }
}

//MARK: - Preview

#Preview {
    
    ZStack {
        Color.blackUniversal
            .ignoresSafeArea()
        HStack {
            SelectedFilterCell(
                isReset: false,
                title: "Title",
                action: {}
            )
            
            SelectedFilterCell(
                isReset: true,
                title: "Title",
                action: {}
            )
        }
    }
}
