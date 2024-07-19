
import SwiftUI

struct CustomNavBar: View {
    
    // MARK: - Properties
    
    let actionForLeftButton: () -> ()
    let title: String
    
    // MARK: - Init
    
    init(
        actionForLeftButton: @escaping () -> (),
        title: String
    ) {
        self.actionForLeftButton = actionForLeftButton
        self.title = title
    }
      
    // MARK: - Body
    
    var body: some View {
        HStack {
            Button {
                actionForLeftButton()
            } label: {
                Image(
                    systemName: "chevron.backward"
                )
                .resizable()
                .foregroundStyle(.whiteUniversal)
                .frame(
                    width: 9,
                    height: 18
                )
            }
           
            Text(title)
                .foregroundStyle(.whiteUniversal)
                .font(.plexSansBold24)
                .kerning(0.4)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    ZStack {
        Color.blackUniversal
            .ignoresSafeArea()
        CustomNavBar(
            actionForLeftButton: {},
            title: "Title"
        )
    }
}
