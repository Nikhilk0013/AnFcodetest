import UIKit

class ANFExploreCardTableViewController: UITableViewController {
    
    private let viewModel = ANFExploreCardTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.fetchPromotions()
    }
    
    private func setupBindings() {
        viewModel.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.showError = { [weak self] error in
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreContentCell", for: indexPath) as? ExploreContentCell else { fatalError() }
        
        let promotion = viewModel.items[indexPath.row]
        cell.promoTitleLabel.text = promotion.title
        viewModel.loadImage(from: promotion.backgroundImage) { image in
            DispatchQueue.main.async {
                cell.promoBackgroundImageView.image = image
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let promotion = viewModel.items[indexPath.row]
            let detailVC = ANFExploreCardDetailViewController()
            detailVC.promotion = promotion
            navigationController?.pushViewController(detailVC, animated: true)
        }
}
