import SwiftUI
import WebKit
import SafariServices

final class WebViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var isOffline = false
    weak var webView: WKWebView?
    let startURL = URL(string: "https://agendez-estetica-pobno0o.verdent.app")!

    func retry() {
        isOffline = false
        webView?.reload()
    }
}

struct WebView: UIViewRepresentable {
    @ObservedObject var model: WebViewModel

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let web = WKWebView(frame: .zero, configuration: config)
        web.navigationDelegate = context.coordinator
        web.allowsBackForwardNavigationGestures = true
        web.scrollView.contentInsetAdjustmentBehavior = .never
        model.webView = web
        web.load(URLRequest(url: model.startURL))
        return web
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(model)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        private let model: WebViewModel

        init(_ model: WebViewModel) {
            self.model = model
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async { self.model.isLoading = true }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.model.isLoading = false
                self.model.isOffline = false
            }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.model.isLoading = false
                self.model.isOffline = true
            }
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            let scheme = url.scheme?.lowercased() ?? ""
            let host = url.host?.lowercased() ?? ""

            // Ligações, e-mails, WhatsApp e SMS abrem no app correspondente do iPhone
            if ["tel", "mailto", "whatsapp", "sms", "itms-apps"].contains(scheme) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }

            // Login com Google não funciona dentro do WebView (Google bloqueia):
            // abre no Safari do próprio iPhone
            if host.contains("accounts.google.com") || host.contains("appleid.apple.com") {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }

        // Links com target="_blank" (janela nova) abrem na mesma tela
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let url = navigationAction.request.url {
                let host = url.host?.lowercased() ?? ""
                if host.contains("accounts.google.com") {
                    UIApplication.shared.open(url)
                    return nil
                }
            }
            webView.load(navigationAction.request)
            return nil
        }
    }
}
