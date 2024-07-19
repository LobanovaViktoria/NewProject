import SwiftUI

struct NavBarForFilter: View {
    
    // MARK: - Properties
    
    let actionForLeftButton: () -> ()
    let actionForRightButton: () -> ()
    let title: String
    @Binding var filterIsApplied: Bool
    
    // MARK: - Init
    
    init(
        actionForLeftButton: @escaping () -> (),
        actionForRightButton: @escaping () -> (),
        title: String,
        filterIsApplied: Binding<Bool>
        
    ) {
        self.actionForLeftButton = actionForLeftButton
        self.actionForRightButton = actionForRightButton
        self.title = title
        self._filterIsApplied = filterIsApplied
    }
      
    // MARK: - Body
    
    var body: some View {
        HStack {
            Button {
                actionForLeftButton()
            } label: {
                Image(
                    systemName: "xmark"
                )
                .resizable()
                .foregroundStyle(.whiteUniversal)
                .frame(
                    width: 13,
                    height: 13
                )
            }
           Spacer()
            Text(title)
                .foregroundStyle(.whiteUniversal)
                .font(.plexSansSemiBold20)
             
            Spacer()
            Button {
                actionForRightButton()
            } label: {
                Text("Reset")
                    .foregroundStyle(
                        filterIsApplied
                        ? .turquoiseUniversal
                        : .whiteUniversal
                    )
                    .font(.plexSansRegular14)
            }
        }
    }
}

//MARK: - Preview

#Preview {
    ZStack {
        Color.blackUniversal
            .ignoresSafeArea()
        NavBarForFilter(
            actionForLeftButton: {},
            actionForRightButton: {},
            title: "Title", filterIsApplied: .constant(true))
    }
}
