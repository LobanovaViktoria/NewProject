import SwiftUI

struct SearchBarView: View {
    
    //MARK: - Properties
    
    @Binding var searchText: String
    @FocusState private var searchIsFocused: Bool
    
    //MARK: - Body
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.whiteUniversal)
            ZStack (alignment: . leading) {
                if searchText.isEmpty && !searchIsFocused {
                    Text("Search")
                        .foregroundStyle(.whiteUniversal)
                        .font(.plexSansRegular14)
                }
                TextField("", text: $searchText)
                    .foregroundStyle(.whiteUniversal)
                    .focused($searchIsFocused)
                    .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(.whiteUniversal)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchIsFocused = false
                            searchText = ""
                        }
                    , alignment: .trailing
                )
            }
        }
        .font(.plexSansRegular14)
        .padding(.horizontal, 15)
        .frame(height: 40)
        .background(
        RoundedRectangle(cornerRadius: 16)
            .stroke(.searchBorder, lineWidth: 2)
        )
    }
}

//MARK: - Preview

#Preview {
    ZStack {
        Color.blackUniversal
            .ignoresSafeArea()
        SearchBarView(searchText: .constant(""))
    }
}
