//
//  NavigationBarBackgroundHidingNavigationController.swift
//  NavigationBarHiding
//
//  Created by Stephen Anthony on 01/05/2021.
//

import UIKit

/// A `UINavigationController` subclass that automatically hides and shows its
/// navigation bar based on the user's scrolling of the view controllers
/// displayed in the navigation stack.
final class NavigationBarBackgroundHidingNavigationController: UINavigationController {
    private var scrollViewContentOffsetObservation: NSKeyValueObservation?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        configureScrollingObservation(forViewController: viewController)
    }
    
    @discardableResult override func popViewController(animated: Bool) -> UIViewController? {
        let poppedViewController = super.popViewController(animated: animated)
        if let topViewController = topViewController {
            configureScrollingObservation(forViewController: topViewController)
        }
        return poppedViewController
    }
    
    @discardableResult override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let poppedViewControllers = super.popToViewController(viewController, animated: animated)
        configureScrollingObservation(forViewController: viewController)
        return poppedViewControllers
    }
    
    @discardableResult override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let poppedViewControllers = super.popToRootViewController(animated: animated)
        if let topViewController = topViewController {
            configureScrollingObservation(forViewController: topViewController)
        }
        return poppedViewControllers
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        if let topViewController = topViewController {
            configureScrollingObservation(forViewController: topViewController)
        }
    }
    
    private func configureScrollingObservation(forViewController viewController: UIViewController) {
        scrollViewContentOffsetObservation = nil
        guard let scrollView = viewController.primaryChildScrollView else {
            navigationBar.setBackgroundAlpha(1.0)
            return
        }
        
        let transitionCompletion: ((UIViewControllerTransitionCoordinatorContext?) -> Void) = { [weak self] context in
            guard let self = self else { return }
            if let context = context, context.isCancelled, let visibleViewController = self.visibleViewController {
                self.configureScrollingObservation(forViewController: visibleViewController)
                return
            }
            self.navigationBar.setBackgroundAlpha(scrollView.navigationBarAlphaForCurrentScrollPosition)
            self.scrollViewContentOffsetObservation = scrollView.observe(\.contentOffset) { [weak self] (scrollView, _) in
                self?.navigationBar.setBackgroundAlpha(scrollView.navigationBarAlphaForCurrentScrollPosition)
            }
        }
        
        if let transitionCoordinator = self.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { [navigationBar] _ in
                navigationBar.setBackgroundAlpha(scrollView.navigationBarAlphaForCurrentScrollPosition)
            }, completion: transitionCompletion)
        } else {
            transitionCompletion(nil)
        }
    }
}

private extension UIView {
    func firstSubview<T: UIView>(ofKind kind: T.Type) -> T? {
        for subview in subviews {
            if let matchingSubview = subview as? T ?? subview.firstSubview(ofKind: kind) {
                return matchingSubview
            }
        }
        return nil
    }
}

private extension UIViewController {
    var primaryChildScrollView: UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }
        view.layoutIfNeeded()
        return view.firstSubview(ofKind: UIScrollView.self)
    }
}

private extension UIScrollView {
    var navigationBarAlphaForCurrentScrollPosition: CGFloat {
        let scrolledDownDistance = contentOffset.y + safeAreaInsets.top
        let scrollDistanceRequiredToShowNavigationBar: CGFloat = 10
        return min(1, max(0, scrolledDownDistance / scrollDistanceRequiredToShowNavigationBar))
    }
}

private extension UINavigationBar {
    func setBackgroundAlpha(_ backgroundAlpha: CGFloat) {
        subviews.first?.alpha = backgroundAlpha
    }
}
