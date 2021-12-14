import SwiftUI

struct FormProfileRegView: View {
    @AppStorage("appleID") var appleID: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    @State var avatar: Int = 0
    @State var organizationName: String = ""
    @State var organizationCategory: String = ""
    @State var organizationZipCode: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var website: String = ""
    @State var selected0 = true
    @State var selected1 = false
    @State var selected2 = false
    @State var selected3 = false
    
    let avatarImages: [String] = [
        "profileCat1",
        "profilePug",
        "profileDog",
        "profileCat2"
    ]
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Escolha seu avatar")) {
                    HStack {
                        ForEach(avatarImages.indices, id: \.self) { index in
                            Button {
                                avatar = index
                            } label: {
                                Image(avatarImages[index])
                                    .resizable()
                                    .frame(width: 65, height: 65)
                                    .scaledToFill()
                            }
                            .overlay {
                                if avatar == index {
                                    Circle().stroke(Color.green, lineWidth: 4)
                                }
                            }.opacity(avatar == index ? 1 : 0.5)
                            
                            Spacer()
                        }
                        
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                Section(header: Text("Adicione informações da organização")) {
                    NavigationLink(destination: CategoryView(selectedCategory: $organizationCategory, categories: ["ONG", "Protetor Independente", "Loja", "Fornecedor"])) {
                        
                        HStack {
                            Text("Categoria")
                            Spacer()
                            Text("\(organizationCategory)")
                                .foregroundColor(.secondary)
                        }
                    }
                    TextField("Nome da organização", text: $organizationName)
                    NavigationLink(destination: CategoryView(selectedCategory: $organizationZipCode, categories: ["AC", "AL", "AP", "AM", "BA", "CE", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO", "DF"])) {
                        
                        HStack {
                            Text("Estado da organização")
                            Spacer()
                            Text("\(organizationZipCode)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Adicione pelo menos um contato")) {
                    TextField("e-mail", text: $email)
                    TextField("telefone", text: $phone)
                    TextField("website", text: $website)
                }
            }
        }
        .navigationTitle("Complete seu perfil")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let userData: [String: Any] = [
                        "createdAt": Date().timeIntervalSince1970,
                        "appleID": appleID,
                        "avatar": avatar,
                        "organizationName": organizationName,
                        "organizationCategory": organizationCategory,
                        "organizationZipCode": organizationZipCode,
                        "email": email,
                        "phone": phone,
                        "website": website
                    ]
                    ServerService.shared.postRequest(route: .user, body: userData) { result in
                        switch result {
                            case .success(let response):
                                print("User created!")
                                print(response)
                            case .failure(let error):
                                print("ERRORERRORERRORERRORERRORERROR")
                                print(error.localizedDescription)
                        }
                    }
                    self.dismiss()
                } label: {
                    Text("Concluir")
                }
            }
        }
    }
}

struct FormProfileRegView_Previews: PreviewProvider {
    static var previews: some View {
        FormProfileRegView()
    }
}