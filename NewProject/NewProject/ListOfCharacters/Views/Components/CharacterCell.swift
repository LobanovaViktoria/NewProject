import SwiftUI

struct CharacterCell: View {
    
    //MARK: - Properties
    
    let item: CharacterModel
    
    //MARK: - Body
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 24)
            .fill(.lightBlackUniversal)
            .frame(height: 96)
            .overlay {
                
                HStack (spacing: 16) {
                    AsyncImage(url: URL(string: item.image ?? "")) { phase in
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
                        .frame(
                            width: 84,
                            height: 64
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.leading, 15)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.name ?? "")
                            .foregroundStyle(.whiteUniversal)
                            .font(.plexSansMedium18)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text(item.status?.rawValue.uppercasedFirstChar() ?? "")
                                .foregroundStyle(item.status?.color ?? Color.grayUniversal)
                                .font(.plexSansSemiBold12)
                            Circle()
                                .frame(width: 3)
                                .foregroundStyle(.whiteUniversal)
                            Text(item.species ?? "")
                                .foregroundStyle(.whiteUniversal)
                                .font(.plexSansSemiBold12)
                        }
                        Text(item.gender ?? "")
                            .foregroundStyle(.whiteUniversal)
                            .font(.plexSansRegular12)
                    }
                    .padding(.trailing, 18)
                }
                .padding(.vertical, 16)
            }
    }
}

//MARK: - Preview

#Preview {
    CharacterCell(
        item: CharacterModel(
            id: 3,
            name: "Name",
            status: .alive,
            species: "species",
            type: "fwafaw",
            gender: "Female",
            origin: Location(name: "sdfsf", url: "sdfsdfs"),
            location: Location(name: "sdfsf", url: "sdfsdfs"),
            image: "wfwjfnwkne",
            episode: ["dsfs"],
            url: "sdfsf",
            created: "s"
        )
    )
}
