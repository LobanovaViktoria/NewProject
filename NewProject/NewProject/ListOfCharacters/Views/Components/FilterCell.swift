import SwiftUI

struct FilterCell: View {
    
    // MARK: - Properties
    
    let selected: Bool
    let title: String
    let action: () -> ()
    
    // MARK: - Init
    
    init(
        selected: Bool,
        title: String,
        action: @escaping () -> ()
    ) {
        self.selected = selected
        self.title = title
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .font(.plexSansRegular12)
                    .foregroundStyle(
                    selected
                    ? .blackUniversal
                    : .whiteUniversal
                    )
                if selected {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 9,
                        height: 8)
                        .foregroundStyle(.blackUniversal)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
           
            .background(
                selected
                ? Color.whiteUniversal
                : Color.blackUniversal
             )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                selected
                ? RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        .searchBorder, lineWidth: 0)
                    
                : RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        .searchBorder, lineWidth: 2)
            }
        }
    }
}

//MARK: - Preview

#Preview {
    
    ZStack {
        Color.blackUniversal
            .ignoresSafeArea()
        HStack {
            FilterCell(
                selected: false,
                title: "Title",
                action: {}
            )
            
            FilterCell(
                selected: true,
                title: "Title",
                action: {}
            )
        }
    }
}
