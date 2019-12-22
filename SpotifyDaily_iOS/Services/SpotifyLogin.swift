import Foundation
import SafariServices
import RxSwift

class SpotifyLogin {
    
    weak internal var safariVC: SFSafariViewController?
    internal var urlBuilder: URLBuilder?
    private let disposeBag = DisposeBag()
    
    private var configuration: Configuration
    private let sessionService: SessionService
    private let networkingClient: Networking
    
    init(configuration: Configuration, sessionService: SessionService, networkingClient: Networking) {
        self.sessionService = sessionService
        self.networkingClient = networkingClient
        self.configuration = configuration
        
        self.urlBuilder = URLBuilder(clientID: configuration.clientID,
                                     clientSecret: configuration.clientSecret,
                                     redirectURL: configuration.redirectURL,
                                     showDialog: true)
    }
    
    // MARK: Interface
    public func applicationOpenURL(_ url: URL) -> Bool {
        guard let urlBuilder = urlBuilder else {
            return false
        }
        
        guard urlBuilder.canHandleURL(url) else {
            return false
        }
        
        safariVC?.dismiss(animated: true, completion: nil)
        
        let parsedURL = urlBuilder.parse(url: url)
        if let code = parsedURL.code, !parsedURL.error {
            networkingClient.createSignInResponse(code: code,
                                                  redirectURL: configuration.redirectURL,
                                                  clientID: configuration.clientID,
                                                  clientSecret: configuration.clientSecret)
                .bind(onNext: { [weak self] response in
                    Logger.info("Signing user in")
                    self?.sessionService.signIn(response: response)
                })
                .disposed(by: disposeBag)
        }
        
        return true
    }
}
