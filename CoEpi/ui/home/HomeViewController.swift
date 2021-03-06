import UIKit

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel

    @IBOutlet weak var stackContainerView: UIView!
    @IBOutlet weak var stackContainerViewTwo: UIView!
    @IBAction func checkInButtonTapped(_ sender: UIButton) {
        viewModel.quizTapped()
    }
    @IBAction func seeAlertsButtonTapped(_ sender: UIButton) {
        viewModel.seeAlertsTapped()
    }
    @IBOutlet weak var myHealthDescriptionLabel: UILabel!
    @IBOutlet weak var contactAlertsDescriptionLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var buildLabel: UILabel!
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
        self.title = self.viewModel.title
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: Fonts.robotoRegular]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func debugTapped(_: UIButton) {
        viewModel.debugTapped()
    }
    
    @objc func share(sender: UIView) {
        Sharer().share(viewController: self, sourceView: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineHeightMultiple = 1.07
        
        let share = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share(sender:)))
        share.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = share
        
        myHealthDescriptionLabel.numberOfLines = 0
        myHealthDescriptionLabel.lineBreakMode = .byWordWrapping
        myHealthDescriptionLabel.sizeToFit()
        
        myHealthDescriptionLabel.attributedText = NSMutableAttributedString(string: "Monitor your health and report symptoms.", attributes: [NSAttributedString.Key.kern: 0.25, NSAttributedString.Key.paragraphStyle: paragraphStyle ])
        
        contactAlertsDescriptionLabel.numberOfLines = 0
        contactAlertsDescriptionLabel.lineBreakMode = .byWordWrapping
        contactAlertsDescriptionLabel.attributedText = NSMutableAttributedString(string: "Approximate times that you may have been exposed to a symptomatic individual", attributes: [NSAttributedString.Key.kern: 0.25, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        configureCardView(cardView: self.stackContainerView)
        configureCardView(cardView: self.stackContainerViewTwo)
        
        versionLabel.text = getVersionNumber()
        buildLabel.text = getBuildNumber()
    }
    
    private func getVersionNumber() -> String{
        
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
         else{
            fatalError("Failed to read bundle version")
        }
        print("Version : \(version)");
        return "Version: \(version)"
    }
    
    private func getBuildNumber() -> String {
        guard let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            fatalError("Failed to read build number")
        }
        print("Build : \(build)")
        return "Build: \(build)"
    }
    
    private func configureCardView(cardView: UIView){
        cardView.layer.cornerRadius = 6
        cardView.layer.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1).cgColor
        //https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-shadow-to-a-uiview
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 3
    }
}
