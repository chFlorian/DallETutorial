// Created by Florian Schweizer on 09.11.22

import SwiftUI

struct ContentView: View {
    @State private var prompt: String = ""
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Enter prompt", text: $prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            
            Button("Generate") {
                isLoading = true
                Task {
                    do {
                        let response = try await DallEImageGenerator.shared.generateImage(withPrompt: prompt, apiKey: Secrets.apiKey)
                        
                        if let url = response.data.map(\.url).first {
                            let (data, _) = try await URLSession.shared.data(from: url)
                            
                            image = UIImage(data: data)
                            isLoading = false
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256, height: 256)
                
                Button("Save Image") {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            } else {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 256, height: 256)
                    .overlay {
                        if isLoading {
                            VStack {
                                ProgressView()
                                
                                Text("Loading...")
                            }
                        }
                    }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
