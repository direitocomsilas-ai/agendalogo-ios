import SwiftUI
import WebKit

struct ContentView: View {
    @StateObject private var model = WebViewModel()

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            WebView(model: model)
                .ignoresSafeArea()

            if model.isOffline {
                offlineView
                    .background(Color.white.ignoresSafeArea())
            }
        }
    }

    private var offlineView: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 56, weight: .light))
                .foregroundColor(Color(red: 0.02, green: 0.59, blue: 0.41))
            Text("Sem conexão")
                .font(.title2.bold())
            Text("Verifique sua internet para usar o Agenda Logo.\nSua agenda e seus clientes voltam a aparecer quando a conexão voltar.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button {
                model.retry()
            } label: {
                Text("Tentar novamente")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Color(red: 0.02, green: 0.59, blue: 0.41))
                    .cornerRadius(16)
            }
        }
    }
}
