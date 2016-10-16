//
//  KSimpleSideMenu.swift
//
//  The MIT License (MIT)
//
//  Copyright © 2016 Kisuk Park <kisuk0521@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import UIKit

open class KSimpleSideMenu: UIViewController {

  override open func viewDidLoad() {
    super.viewDidLoad()
    self.addClosingTapGestureRecognizer(to: self)
    self.addClosingPanGestureRecognizer(to: self)
  }

  /*
   TODO: Fill in
   */
  struct Defaults {
    static let sideMenuAnimationDuration: TimeInterval        = 0.1
    static let sideMenuAnimationDelay: TimeInterval           = 0.0
    static let sideMenuAnimationCurve: UIViewAnimationOptions = .curveLinear
    static let sideMenuMainHeightReduction: CGFloat           = 25.0
    static let sideMenuMenuWidth: CGFloat                     = 250.0
    static let sideMenuBackground: UIColor                    = .white
    static let sideMenuTouchGestureEnable: Bool               = true
    static let sideMenuPanGestureEnable: Bool                 = true
  }

  var
  sideMenuAnimationDuration   = Defaults.sideMenuAnimationDuration,
  sideMenuAnimationDelay      = Defaults.sideMenuAnimationDelay,
  sideMenuAnimationCurve      = Defaults.sideMenuAnimationCurve,
  sideMenuMainHeightReduction = Defaults.sideMenuMainHeightReduction,
  sideMenuMenuWidth           = Defaults.sideMenuMenuWidth,
  sideMenuBackground          = Defaults.sideMenuBackground,
  sideMenuTouchGestureEnable  = Defaults.sideMenuTouchGestureEnable,
  sideMenuPanGestureEnable    = Defaults.sideMenuPanGestureEnable

  /*
   TODO: Fill in
   */
  private var isAnimating     = false {
    didSet {
      self.mainViewController?.view.isUserInteractionEnabled = !isAnimating
      self.menuViewController?.view.isUserInteractionEnabled = !isAnimating
    }
  }
  private var isOpened        = false {
    didSet {
      self.mainViewController?.view.isUserInteractionEnabled = !isOpened
    }
  }
  private var isDuringPan     = false
  private let screenWidth     = UIScreen.main.bounds.width
  private let screenHeight    = UIScreen.main.bounds.height
  private let startZoneWidth: CGFloat = 50

  // For Animation
  private var startXOnScreenView: CGFloat = 0
  private var startXOnMainView: CGFloat = 0

  var mainFrameScaleFactor: CGFloat {
    let heightOnMenuOpen = (screenHeight - 2 * self.sideMenuMainHeightReduction)
    return heightOnMenuOpen / screenHeight
  }

  var mainTransformOnMenuOpen: CGAffineTransform {
    let scale = self.mainFrameScaleFactor
    let translateX = self.sideMenuMenuWidth - screenWidth * (1 - scale) / 2

    var t = CGAffineTransform.identity
    t = t.translatedBy(x: -translateX, y: 0)
    t = t.scaledBy(x: scale, y: scale)
    return t
  }

  var menuTransformOnMenuOpen: CGAffineTransform {
    var t = CGAffineTransform.identity
    t = t.translatedBy(x: -self.sideMenuMenuWidth, y: 0)
    return t
  }

  var mainTransformOnMenuClose: CGAffineTransform {
    return CGAffineTransform.identity
  }

  var menuTransformOnMenuClose: CGAffineTransform {
    get {
      return CGAffineTransform.identity
    }
  }

  var mainFrameOnClose: CGRect {
    return UIScreen.main.bounds
  }

  var menuFrameOnClose: CGRect {
    return CGRect(x: screenWidth,
                  y: 0,
                  width: screenWidth,
                  height: screenHeight)
  }

  var mainFrameOnOpen: CGRect {
    let scale = self.mainFrameScaleFactor
    return CGRect(x: screenWidth * (1 - scale) - self.sideMenuMenuWidth,
                  y: self.sideMenuMainHeightReduction,
                  width: screenWidth * scale,
                  height: screenHeight * scale)
  }

  var menuFrameOnOpen: CGRect {
    return CGRect(x: screenWidth - self.sideMenuMenuWidth,
                  y: 0,
                  width: screenWidth,
                  height: screenHeight)
  }

  var currentMainFrame: CGRect {
    if let frame = self.mainViewController?.view.frame {
      return frame
    } else {
      return mainFrameOnClose
    }
  }

  var currentMenuFrame: CGRect {
    if let frame = self.menuViewController?.view.frame {
      return frame
    } else {
      return menuFrameOnClose
    }
  }

  /*
   TODO: Fill in
   */
  var mainViewController: UIViewController?
  var menuViewController: UIViewController?

  /*
   TODO: Fill in
   */
  public func setSideMenuChildViewControllers(mainViewController: UIViewController,
                                              menuViewController: UIViewController) {
    self.changeMainViewController(mainViewController)
    self.changeMenuViewController(menuViewController)
  }

  /*
   TODO: Fill in
   */
  public func changeMainViewController(_ viewController: UIViewController,
                                       closeMenu: Bool,
                                       completed: (() -> Void)?) {
    self.changeMainViewController(viewController)

    if closeMenu {
      self.closeMenu(completed: nil)
    }

    if let callback = completed {
      callback()
    }
  }

  private func changeMainViewController(_ viewController: UIViewController) {
    var t: CGAffineTransform?
    if let currentMainViewController = self.mainViewController {
      currentMainViewController.willMove(toParentViewController: self)
      currentMainViewController.view.removeFromSuperview()
      currentMainViewController.removeFromParentViewController()
      t = currentMainViewController.view.transform
    }

    self.displayChildViewController(viewController, position: self.mainFrameOnClose)
    self.mainViewController = viewController
    if let t = t {
      self.mainViewController?.view.transform = t
    }
  }
  public func changeMenuViewController(_ viewController: UIViewController) {
    self.displayChildViewController(viewController, position: self.menuFrameOnClose)
    self.menuViewController = viewController
  }

  /*
   TODO: Fill in
   */
  public func openMenu(completed: ((Bool) -> Void)?) {
    self.isAnimating = true

    self.view.backgroundColor = self.sideMenuBackground
    UIView.animate(withDuration: self.sideMenuAnimationDuration,
                   delay: self.sideMenuAnimationDelay,
                   options: self.sideMenuAnimationCurve,
                   animations: {
                    self.mainViewController?.view.transform = self.mainTransformOnMenuOpen
                    self.menuViewController?.view.transform = self.menuTransformOnMenuOpen
    }) { (finished) in
      self.isOpened = true
      self.isAnimating = false
      if let callback = completed {
        callback(finished)
      }
    }
  }

  /*
   TODO: Fill in
   */
  public func closeMenu(completed: ((Bool) -> Void)?) {
    self.isAnimating = true

    UIView.animate(withDuration: self.sideMenuAnimationDuration,
                   delay: self.sideMenuAnimationDelay,
                   options: self.sideMenuAnimationCurve,
                   animations: {
                    self.mainViewController?.view.transform = self.mainTransformOnMenuClose
                    self.menuViewController?.view.transform = self.menuTransformOnMenuClose
    }) { (finished) in

      self.isOpened = false
      self.isAnimating = false
      if let callback = completed {
        callback(finished)
      }
    }
  }

  /*
   TODO: Fill in
   */
  private func getLayoutPercentage(from recognizer: UIPanGestureRecognizer) -> CGFloat {
    var gap: CGFloat
    var initialX: CGFloat
    var finalX: CGFloat

    if self.isOpened {
      gap = self.mainFrameOnOpen.origin.x + self.mainFrameOnOpen.size.width - startXOnScreenView
      initialX = screenWidth - gap
      finalX = startXOnScreenView
    } else {
      gap = screenWidth - startXOnMainView
      initialX = startXOnMainView
      finalX = self.mainFrameOnOpen.origin.x + self.mainFrameOnOpen.size.width - gap
    }

    let percentage = (recognizer.location(in: self.view).x - initialX) / (finalX - initialX)
    return min(max(percentage, 0), 1)
  }

  /*
   TODO: Fill in
   */
  private func drawLayoutAt(_ percentage: CGFloat) {
    let momentScaleFactor = 1 + (self.mainFrameScaleFactor - 1) * percentage
    var momentMainTransform = CGAffineTransform.identity
    momentMainTransform = momentMainTransform.translatedBy(x: self.mainTransformOnMenuClose.tx + (self.mainTransformOnMenuOpen.tx - self.mainTransformOnMenuClose.tx) * percentage,
                                                           y: self.mainTransformOnMenuClose.ty + (self.mainTransformOnMenuOpen.ty - self.mainTransformOnMenuClose.ty) * percentage)
    momentMainTransform = momentMainTransform.scaledBy(x: momentScaleFactor,
                                                       y: momentScaleFactor)
    var momentMenuTransform = CGAffineTransform.identity
    momentMenuTransform = momentMenuTransform.translatedBy(x: self.menuTransformOnMenuClose.tx + (self.menuTransformOnMenuOpen.tx - self.menuTransformOnMenuClose.tx) * percentage,
                                                           y: 0)

    self.mainViewController?.view.transform = momentMainTransform
    self.menuViewController?.view.transform = momentMenuTransform
  }

  /*
   TODO: Fill in
   */
  func tapGestureAction(recognizer: UITapGestureRecognizer? = nil) {
    if !self.isOpened {
      return
    }

    if (recognizer?.location(in: self.view).x)! < screenWidth - self.sideMenuMenuWidth {
      self.closeMenu(completed: nil)
    }
  }

  /*
   TODO: Fill in
   */
  func panGestureAction(recognizer: UIPanGestureRecognizer? = nil) {
    let locationOnScreenView = recognizer?.location(in: self.view)
    let locationOnMainView = recognizer?.location(in: self.mainViewController?.view)
    let percentage = getLayoutPercentage(from: recognizer!)

    if self.shouldEndPan(recognizer!) {
      // TODO: Fill in
      self.isDuringPan = false
      self.isAnimating = false

      if shouldOpenMenuOnPanEnd(recognizer!) {
        self.openMenu(completed: nil)
      } else if shouldCloseMenuOnPanEnd(recognizer!) {
        self.closeMenu(completed: nil)
      }
    } else if self.isDuringPan {
      // TODO: Fill in
      self.drawLayoutAt(percentage)
    } else if self.shouldStartPan(recognizer!) {
      // TODO: Fill in
      startXOnScreenView = (locationOnScreenView?.x)!
      startXOnMainView = (locationOnMainView?.x)!

      self.isDuringPan = true
      self.isAnimating = true
    }
  }

  /*
   TODO: Fill in
   */
  private func displayChildViewController(_ viewController: UIViewController, position frame: CGRect) {
    self.addChildViewController(viewController)
    viewController.view.frame = frame
    self.view.addSubview(viewController.view)
    viewController.didMove(toParentViewController: self)
  }

  /*
   TODO: Fill in
   */
  private func addClosingTapGestureRecognizer(to viewController: UIViewController) {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
    tapGesture.numberOfTapsRequired = 1
    tapGesture.numberOfTouchesRequired = 1
    tapGesture.cancelsTouchesInView = false
    viewController.view.addGestureRecognizer(tapGesture)
  }

  private func addClosingPanGestureRecognizer(to viewController: UIViewController) {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
    panGesture.minimumNumberOfTouches = 1
    panGesture.maximumNumberOfTouches = 1
    panGesture.cancelsTouchesInView = true
    viewController.view.addGestureRecognizer(panGesture)
  }

  /*
   TODO: Fill in
   */
  private func shouldStartPan(_ recognizer: UIPanGestureRecognizer) -> Bool {
    let maxX = screenWidth
    let minX = maxX - startZoneWidth
    let location = recognizer.location(in: self.mainViewController?.view)

    let didEnter = location.x >= minX && location.x <= maxX
    let isEnterState = recognizer.state == .began || recognizer.state == .changed
    return !self.isDuringPan && isEnterState && didEnter
  }

  private func shouldEndPan(_ recognizer: UIPanGestureRecognizer) -> Bool {
    return self.isDuringPan && recognizer.state == .ended
  }

  /*
   TODO: Fill in
   */
  private func shouldOpenMenuOnPanEnd(_ recognizer: UIPanGestureRecognizer) -> Bool {
    let velocity = recognizer.velocity(in: self.view)
    let percentage = getLayoutPercentage(from: recognizer)
    return (percentage < 1 && velocity.x < CGFloat(0)) || (velocity.x == CGFloat(0) && percentage >= 0.5) || percentage == 1
  }

  private func shouldCloseMenuOnPanEnd(_ recognizer: UIPanGestureRecognizer) -> Bool {
    let velocity = recognizer.velocity(in: self.view)
    let percentage = getLayoutPercentage(from: recognizer)
    return (percentage > 0 && velocity.x > CGFloat(0)) || (velocity.x == CGFloat(0) && percentage < 0.5) || percentage == 0
  }
}
