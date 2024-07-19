import SwiftUI

struct ErrorView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ListViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.blackUniversal
                .ignoresSafeArea()
            
            VStack {
                Image("connectionError")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 263, height: 263)
                    .padding(.bottom, 32)
                VStack {
                    infoBlock
                    Spacer()
                    CustomButton(title: "Retry")
                        .padding(.horizontal, 16.5)
                        .onTapGesture {
                            presentationMode
                                .wrappedValue.dismiss()
                            viewModel.refresh()
                        }
                }
                .padding(.horizontal, 70)
                .frame(height: 152)
                Spacer()
                    .toolbar(.hidden, for: .navigationBar)
            }
            .padding(.top, 66)
        }
    }
}

// MARK: - Extension

extension ErrorView {
    
    private var infoBlock: some View {
        VStack {
            Text("Network Error")
                .foregroundStyle(.whiteUniversal)
                .font(.plexSansSemiBold28)
                .kerning( 0.4)
                .padding(.bottom, 4)
            
            Text("There was an error connecting.\n Please check your internet.")
                .foregroundStyle(.grayUniversal)
                .font(.plexSansRegular16)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .kerning( 0.4)
        }
    }
}

// MARK: - Enums

enum AppState {
    case failed
    case success
}

// MARK: - Preview

#Preview {
    ErrorView()
}
