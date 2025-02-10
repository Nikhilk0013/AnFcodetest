import UIKit

class ANFExploreCardDetailViewController: UIViewController {
    
    var promotion: Promotion?
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let topDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let promoMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let bottomDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureView()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(backgroundImageView)
        stackView.addArrangedSubview(topDescriptionLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(promoMessageLabel)
        stackView.addArrangedSubview(bottomDescriptionLabel)
        
        NSLayoutConstraint.activate([
            backgroundImageView.heightAnchor.constraint(equalToConstant: 200),
            backgroundImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureView() {
        guard let promotion = promotion else { return }
        
        topDescriptionLabel.text = promotion.topDescription
        titleLabel.text = promotion.title
        promoMessageLabel.text = promotion.promoMessage
        if let htmlString = promotion.bottomDescription, let  attributedString = htmlToAttributedString(htmlString: htmlString) {
            bottomDescriptionLabel.attributedText = attributedString
        }
        
        loadImage(from: promotion.backgroundImage) { image in
            DispatchQueue.main.async {
                self.backgroundImageView.image = image
            }
        }
        guard let content = promotion.content else { return }
        for item in content {
            let button = UIButton(type: .system)
            button.setTitle(item.title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 5
            button.addAction(UIAction(handler: { _ in
                if let url = URL(string: item.target) {
                    UIApplication.shared.open(url)
                }
            }), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
            button.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8).isActive = true
        }
    }
    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func htmlToAttributedString(htmlString: String) -> NSAttributedString? {
            guard let data = htmlString.data(using: .utf8) else { return nil }
            do {
                return try NSAttributedString(
                    data: data,
                    options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                    documentAttributes: nil
                )
            } catch {
                print("Error converting HTML to Attributed String: \(error)")
                return nil
            }
        }
}
