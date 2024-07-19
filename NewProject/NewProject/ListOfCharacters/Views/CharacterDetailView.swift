import SwiftUI

struct CharacterDetailView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var coordinator: BaseCoordinator
    @EnvironmentObject var viewModel: ListViewModel
    
    // MARK: - Body
    
    var body: some View {
        switch viewModel.state {
        case .failed:
            ErrorView()
        case .success:
            successView
        }
    }
}

// MARK: - Extension CharacterDetail

extension CharacterDetailView {
    private var successView: some View {
        ZStack {
            Color.blackUniversal
                .ignoresSafeArea()
            VStack {
                navBar
                    .padding(.top, 12)
                detailInfo
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.lightBlackUniversal)
                    )
                 
                Spacer()
                    .toolbar(.hidden, for: .navigationBar)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var navBar: some View {
        CustomNavBar(
            actionForLeftButton: {
                coordinator.removeLast()
                viewModel.updateEpisodes()
            },
            title: viewModel.selectedCharacter?.name ?? "No name"
        )
    }
    
    private var detailInfo: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if let selectedItem = viewModel.selectedCharacter {
                AsyncImage(
                    url: URL(
                        string: selectedItem.image ?? ""
                    )
                ) { phase in
                    switch phase {
                    case .failure:
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        ProgressView()
                    }
                }
                .centerCropped()
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.bottom, 16)
                
                StatusView(
                    status: selectedItem.status ?? .unknown
                )
                .padding(.bottom, 24)
                VStack (alignment: .leading, spacing: 16) {
                    property(
                        title: "Species:",
                        value: selectedItem.species ?? ""
                    )
                    property(
                        title: "Gender:",
                        value: selectedItem.gender ?? ""
                    )
                    property(
                        title: "Episodes:",
                        value: viewModel.episodesName.joined(separator: ", ")
                    )
                    property(
                        title: "Last known location:",
                        value: selectedItem.location.name ?? ""
                    )
                }
                .padding(.horizontal, 0)
            }
        }
        .padding(16)
    }
    
    @ViewBuilder func property(
        title: String,
        value: String
    ) -> some View {
        Group {
            Text(title)
                .font(.plexSansSemiBold16) +
            Text(" ") +
            Text(value)
                .font(.plexSansRegular16)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .foregroundStyle(.whiteUniversal)
    }
}

// MARK: - Preview

#Preview {
    CharacterDetailView()
        .environmentObject(ListViewModel())
}
