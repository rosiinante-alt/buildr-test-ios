import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Buildr Test")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("iOS deployment successful!")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
