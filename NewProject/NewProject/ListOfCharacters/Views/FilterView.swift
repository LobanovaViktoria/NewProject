import SwiftUI

struct FilterView: View {
    
    //MARK: - Properties
    
    @EnvironmentObject var coordinator: BaseCoordinator
    @EnvironmentObject var viewModel: ListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Color.blackUniversal
                .ignoresSafeArea()
            VStack {
                navBar
                header(title: "Status")
                sectionStatus
                header(title: "Gender")
                sectionGender
                CustomButton(title: "Apply")
                    .onTapGesture {
                        presentationMode
                            .wrappedValue.dismiss()
                        viewModel.applyFilters()
                    }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 20)
        }
    }
}

//MARK: - Extension FilterView

extension FilterView {
    private var navBar: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
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
            Text("Filters")
                .foregroundStyle(.whiteUniversal)
                .font(.plexSansSemiBold20)
             
            Spacer()
            Button {
                viewModel.resetFilters()
            } label: {
                Text("Reset")
                    .foregroundStyle(
                        (viewModel.selectedGender != nil
                         ||
                         viewModel.selectedStatus != nil)
                        ? .turquoiseUniversal
                        : .whiteUniversal
                    )
                    .font(.plexSansRegular14)
            }
        }
    }
    
    private var sectionStatus: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach( Status.allCases, id: \.self) { item in
                    FilterCell(
                        selected: item.rawValue == viewModel.selectedStatus?.rawValue,
                        title: item.rawValue,
                        action: {
                            viewModel.statusChange(item: item)
                        }
                    )
                }
            }
        }
    }
    
    private var sectionGender: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach( Gender.allCases, id: \.self) { item in
                    FilterCell(
                        selected: item.rawValue == viewModel.selectedGender?.rawValue,
                        title: item.rawValue,
                        action: {
                            viewModel.genderChange(item: item)
                        }
                    )
                }
            }
            .padding(.bottom, 24)
        }
    }
    
    @ViewBuilder func header(
        title: String
    ) -> some View {
        Text(title)
            .font(.plexSansMedium14)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .foregroundStyle(.whiteUniversal)
            .padding(.top, 24)
    }
}

//MARK: - Preview

#Preview {
    ZStack {
        Color.blackUniversal
            .ignoresSafeArea()
        FilterView()
            .environmentObject(ListViewModel())
    }
}

