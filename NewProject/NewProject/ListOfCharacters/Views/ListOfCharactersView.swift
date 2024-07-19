import SwiftUI

struct ListOfCharactersView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var coordinator: BaseCoordinator
    @EnvironmentObject var viewModel: ListViewModel
    @State private var scrollId: Int?
    @State private var showProgressView: Bool = false
    
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

// MARK: - Extension ListOfCharactersView

extension ListOfCharactersView {
    
    private var successView: some View {
        ZStack {
            Color.blackUniversal
                .ignoresSafeArea()
            
            VStack {
                title
                    .padding(.top, 12)
                    .padding(.horizontal, 20)
                searchBar
                    .padding(.top, 16)
                    .padding(.horizontal, 20)
                
                if viewModel.filterIsApplied {
                    selectedFilters
                        .padding(.top, 8)
                        .padding(.horizontal, 20)
                }
                if viewModel.characters == [] {
                    notFoundView
                }
                scrollWithCharacters
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                Spacer()
            }
        }
    }
    
    private var notFoundView: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 107)
                .foregroundStyle(
                    .lightBlackUniversal
                )
                .padding(.horizontal, 0)
                .overlay {
                    HStack {
                        Spacer()
                        VStack {
                            Text("No matches found")
                                .foregroundStyle(
                                    .whiteUniversal
                                )
                                .font(.plexSansMedium20)
                            Text("Please try another filters")
                                .foregroundStyle(
                                    .grayForNothingFound
                                )
                                .font(.plexSansRegular12)
                        }
                        .padding(.trailing, 46)
                    }
                }
            Image("nothingFound")
                .resizable()
                .scaledToFit()
                .frame(
                    width: 261,
                    height: 261
                )
        }
    }
    
    private var scrollWithCharacters: some View {
        ScrollView (.vertical, showsIndicators: false) {
            if let characters = viewModel.characters {
                LazyVStack(spacing: 4) {
                    ForEach(characters) { character in
                        CharacterCell(
                            item: CharacterModel(
                                id: character.id,
                                name: character.name,
                                status: character.status,
                                species: character.species,
                                type: character.type,
                                gender: character.gender,
                                origin: character.origin,
                                location: character.location,
                                image: character.image,
                                episode: character.episode,
                                url: character.url,
                                created: character.created
                            )
                        )
                        .onTapGesture {
                            coordinator.characterDetail()
                            viewModel.selectedCharacter = character
                            viewModel.getEpisodes()
                        }
                    }
                }.scrollTargetLayout()
                if showProgressView {
                    ProgressView()
                        .controlSize(.large)
                        .progressViewStyle(
                            CircularProgressViewStyle(
                                tint: .whiteUniversal
                            )
                        )
                        .padding(.top, 20)
                }
            }
        }
        .scrollPosition(id: $scrollId, anchor: .bottom)
        .onChange(of: scrollId) {
            if shouldLoadNextPage(for: scrollId ?? 0) && !viewModel.isLastPage() {
                showProgressView = true
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.5) {
                        withAnimation {
                            viewModel.loadNextPage()
                            showProgressView = !viewModel.isBusy
                        }
                    }
            }
        }
    }
    
    private func shouldLoadNextPage(for currentId: Int) -> Bool {
        if let lastId = self.viewModel.characters?.last?.id {
            return lastId == currentId
        } else {
            return true
        }
    }
    
    private var title: some View {
        Text("Rick & Morty Characters")
            .font(.plexSansBold24)
            .foregroundStyle(.whiteUniversal)
            .kerning(0.4)
    }
    
    private var searchBar: some View {
        HStack {
            SearchBarView(searchText: $viewModel.searchText)
                .onChange(of: viewModel.searchText) { oldValue, newValue in
                    viewModel.updateSearchText()
                }
            Button {
                coordinator.filters()
            } label: {
                Image(
                    viewModel.filterIsApplied
                    ? "activeFilter"
                    : "inActiveFilter"
                )
            }
        }
    }
    
    private var selectedFilters: some View {
        HStack(spacing: 4) {
            if viewModel.selectedStatus != nil {
                SelectedFilterCell(
                    isReset: false,
                    title: viewModel.selectedStatus?.rawValue ?? ""
                ) { }
            }
            if viewModel.selectedGender != nil {
                SelectedFilterCell(
                    isReset: false,
                    title: viewModel.selectedGender?.rawValue ?? ""
                ) { }
            }
            SelectedFilterCell(
                isReset: true,
                title: "Reset all filters") {
                    viewModel.resetFilters()
                }
            
            Spacer()
        }
    }
}

//MARK: - Preview

#Preview {
    ListOfCharactersView()
        .environmentObject(ListViewModel())
}
