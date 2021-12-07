import SwiftUI

struct FormPostView: View {
    @State var pickerSelectedItemPost: Int = 0
    @State var postTitle: String = ""
    @State var postDescription: String = ""
    @State private var showingSheet = false
    var body: some View {
        
        Form {
            Section(header: Text("Categoria da Postagem")) {
                
                Picker("Categoria", selection: $pickerSelectedItemPost) {
                    Text("Necessidade").tag(0)
                    Text("Doação").tag(1)
                }
                .pickerStyle(.segmented)
                
            }
            Section(header: Text("Título da Postagem")) {
                TextField("", text: $postTitle)
            }
            
            Section(header: Text("Descrição da Postagem")) {
                TextEditor(text: $postDescription)
                    .frame(height: 100)
            }
            
            Section(header: Text("Itens")) {
                List{
                    NavigationLink(destination: AddItemView()){
                        Text ("Adicionar item...")
                        
                    }}
                
            }
        }
        .navigationTitle("Nova Postagem")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button(action: {
            print("Ola")
        }) {
            Text("Adicionar")
        }
        )
    }
    
}

struct FormPostView_Previews: PreviewProvider {
    static var previews: some View {
        FormPostView()
    }
}