//
//  NumbersViewController.swift
//  NavigationBarHiding
//
//  Created by Stephen Anthony on 01/05/2021.
//

import UIKit

/// A view controller that shows a list of numbers. Tapping a number shows
/// another numbers view controller.
final class NumbersViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.title = "Title"
        if ProcessInfo.processInfo.environment["USE_PRIVATE_API"] == "YES" {
            navigationItem._setManualScrollEdgeAppearanceEnabled(true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = indexPath.row.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        show(NumbersViewController(style: .grouped), sender: self)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard ProcessInfo.processInfo.environment["USE_PRIVATE_API"] == "YES" else { return }
        let scrolledDownDistance = scrollView.contentOffset.y + scrollView.safeAreaInsets.top
        let scrollDistanceRequiredToShowNavigationBar: CGFloat = 10
        let alpha = min(1, max(0, scrolledDownDistance / scrollDistanceRequiredToShowNavigationBar))
        navigationItem._setManualScrollEdgeAppearanceProgress(alpha)
    }
}
