//
//  NavigationBarHidingTests.swift
//  NavigationBarHidingTests
//
//  Created by Stephen Anthony on 03/05/2021.
//

import XCTest
@testable import Bar_Hiding

final class NavigationBarBackgroundHidingNavigationControllerTests: XCTestCase {
    private var navigationController: NavigationBarBackgroundHidingNavigationController!
    private var rootScrollViewContainingViewController: UITableViewController!
    
    override func setUp() {
        super.setUp()
        rootScrollViewContainingViewController = UITableViewController(style: .plain)
        rootScrollViewContainingViewController.navigationItem.title = "Hello"
    }
    
    override func tearDown() {
        navigationController = nil
        rootScrollViewContainingViewController = nil
        super.tearDown()
    }
    
    private func givenANavigationControllerWithAScrollableRoot() {
        navigationController = NavigationBarBackgroundHidingNavigationController(navigationBarClass: AlphaObservingNavigationBar.self, toolbarClass: nil)
        navigationController.setViewControllers([rootScrollViewContainingViewController], animated: false)
        navigationController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 800)
    }
    
    private func givenANavigationControllerWithoutAScrollableRoot() {
        navigationController = NavigationBarBackgroundHidingNavigationController(navigationBarClass: AlphaObservingNavigationBar.self, toolbarClass: nil)
        navigationController.setViewControllers([UIViewController()], animated: false)
        navigationController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 800)
    }
    
    private func when(scrollView: UIScrollView, isScrolledVerticallyBy verticalDelta: CGFloat) {
        scrollView.contentOffset.y += verticalDelta
    }
    
    private func whenTheUserPushes(viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func whenTheUserPopsAViewController() {
        navigationController.popViewController(animated: false)
    }
    
    private func whenTheUserPops(toViewController viewController: UIViewController) {
        navigationController.popToViewController(viewController, animated: false)
    }
    
    private func whenTheUserPopsToTheRootViewController() {
        navigationController.popToRootViewController(animated: false)
    }
}

// MARK: - Default Alpha Values

extension NavigationBarBackgroundHidingNavigationControllerTests {
    func testItHidesTheNavigationBarWhenPresentingAViewControllerWithScrollableContent() {
        givenANavigationControllerWithAScrollableRoot()
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 0)
    }
    
    func testItDoesNotHideTheNavigationBarWhenPresentingAViewControllerWithoutScrollableContent() {
        givenANavigationControllerWithoutAScrollableRoot()
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 1)
    }
}

// MARK: - Scroll Observation

extension NavigationBarBackgroundHidingNavigationControllerTests {
    func testItAdjustsTheNavigationBarAlphaWhenTheUserScrollsThePresentedContent() {
        givenANavigationControllerWithAScrollableRoot()
        when(scrollView: rootScrollViewContainingViewController.tableView, isScrolledVerticallyBy: 5)
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 0.5)
        when(scrollView: rootScrollViewContainingViewController.tableView, isScrolledVerticallyBy: 5)
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 1.0)
        when(scrollView: rootScrollViewContainingViewController.tableView, isScrolledVerticallyBy: -10)
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 0)
    }
    
    func testItAdjustsTheNavigationBarAlphaWhenTheUserScrollsAPushedViewControllersScrollView() {
        let pushedViewController = UITableViewController(style: .plain)
        
        givenANavigationControllerWithAScrollableRoot()
        whenTheUserPushes(viewController: pushedViewController)
        when(scrollView: pushedViewController.tableView, isScrolledVerticallyBy: 5)
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 0.5)
        when(scrollView: pushedViewController.tableView, isScrolledVerticallyBy: 5)
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 1.0)
        when(scrollView: pushedViewController.tableView, isScrolledVerticallyBy: -10)
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 0)
    }
    
    func testItIgnoresScrollContentOffsetChangesInNonVisibleChildViewControllers() {
        let pushedViewController = UITableViewController(style: .plain)
        
        givenANavigationControllerWithAScrollableRoot()
        whenTheUserPushes(viewController: pushedViewController)
        when(scrollView: rootScrollViewContainingViewController.tableView, isScrolledVerticallyBy: 5)
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 0)
    }
    
    func testItAdjustsTheNavigationBarAlphaWhenTheUserScrollsAViewControllersScrollViewThatHasBeenPoppedTo() {
        let firstPushedViewController = UITableViewController(style: .plain)
        let secondPushedViewController = UITableViewController(style: .plain)
        
        givenANavigationControllerWithAScrollableRoot()
        whenTheUserPushes(viewController: firstPushedViewController)
        whenTheUserPushes(viewController: secondPushedViewController)
        whenTheUserPopsAViewController()
        when(scrollView: firstPushedViewController.tableView, isScrolledVerticallyBy: 5)
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 0.5)
    }
    
    func testItAdjustsTheNavigationBarAlphaWhenTheUserScrollsAViewControllersScrollViewThatHasBeenSpecificallyPoppedTo() {
        let firstPushedViewController = UITableViewController(style: .plain)
        let secondPushedViewController = UITableViewController(style: .plain)
        
        givenANavigationControllerWithAScrollableRoot()
        whenTheUserPushes(viewController: firstPushedViewController)
        whenTheUserPushes(viewController: secondPushedViewController)
        whenTheUserPops(toViewController: firstPushedViewController)
        when(scrollView: firstPushedViewController.tableView, isScrolledVerticallyBy: 5)
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 0.5)
    }
    
    func testItAdjustsTheNavigationBarAlphaWhenTheUserPopsToTheRootViewController() {
        let firstPushedViewController = UITableViewController(style: .plain)
        let secondPushedViewController = UITableViewController(style: .plain)
        
        givenANavigationControllerWithAScrollableRoot()
        whenTheUserPushes(viewController: firstPushedViewController)
        whenTheUserPushes(viewController: secondPushedViewController)
        whenTheUserPopsToTheRootViewController()
        when(scrollView: rootScrollViewContainingViewController.tableView, isScrolledVerticallyBy: 5)
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 0.5)
    }
}

// MARK: - Nested Scroll Views

extension NavigationBarBackgroundHidingNavigationControllerTests {
    func testItObservesNestedScrollViews() {
        let nestedScrollViewViewController = NestedScrollViewViewController()
        
        givenANavigationControllerWithAScrollableRoot()
        whenTheUserPushes(viewController: nestedScrollViewViewController)
        when(scrollView: nestedScrollViewViewController.scrollView, isScrolledVerticallyBy: 5)
        XCTAssertEqual((navigationController.navigationBar as! AlphaObservingNavigationBar).backgroundAlpha, 0.5)
    }
}

private class AlphaObservingNavigationBar: UINavigationBar {
    var backgroundAlpha: CGFloat {
        return backgroundView.alpha
    }
    
    private let backgroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class NestedScrollViewViewController: UIViewController {
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
    }
}
