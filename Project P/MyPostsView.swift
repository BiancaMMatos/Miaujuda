//
//  MyPostsView.swift
//  Project P
//
//  Created by João Victor Ferreira Pimenta on 01/12/21.
//

import SwiftUI



struct MyPostsView: View {
    @State var pickerSelectedItemMyPosts: Int = 0
    
    var body: some View {
        NavigationView{
            ScrollView (.vertical){
                VStack {
                    Picker ("Status", selection: $pickerSelectedItemMyPosts ){
                        Text("Ativas").tag(0)
                        Text("Inativas").tag(1)
                        
                    }.pickerStyle(.segmented)
                    
                    
                    
                    Group{
                        Text("um texto")
                        Text("um texto")
                        Text("um texto")
                        Text("um texto")
                        Text("um texto")
                        Text("um texto")
                        Text("um texto")
                    }
                    
                }
            }
        } .navigationTitle("Minhas Postagens").navigationBarTitleDisplayMode(.inline)
        
    }
}

struct MyPostsView_Previews: PreviewProvider {
    static var previews: some View {
        MyPostsView()
    }
}
