//
//  SwiftKeyboardAccessory.swift
//  SwiftKeyboardAccessory
//
//  Created by Narciso Cerezo Jiménez on 11/5/15.
//  Copyright (c) 2015 Narciso Cerezo. All rights reserved.
//
//  v0.1.1

import Foundation

import ObjectiveC
import UIKit

// Constants for objc-runtime properties
private var SwiftKeyboardAccessoryViewToResizeKey: UInt8 = 0
private var SwiftKeyboardAccessoryCurrentTextFieldKey: UInt8 = 0
private var SwiftKeyboardAccessoryCurrentTextFieldIndexPathKey: UInt8 = 0
private var SwiftKeyboardAccessoryNextIndexPathKey: UInt8 = 0
private var SwiftKeyboardAccessorySortedTextFieldsKey: UInt8 = 0
private var SwiftKeyboardAccessoryViewHeightKey: UInt8 = 0
private var SwiftKeyboardAccessoryPreviousButtonKey: UInt8 = 0
private var SwiftKeyboardAccessoryNextButtonKey: UInt8 = 0
private var SwiftKeyboardAccessoryReturnClosureKey: UInt8 = 0
private var SwiftKeyboardAccessorytextFieldEndEditingClosureKey: UInt8 = 0
private var SwiftKeyboardAccessoryTextFieldDelegateKey: UInt8 = 0
private var SwiftKeyboardAccessoryPrevImageNameKey: UInt8 = 0
private var SwiftKeyboardAccessoryNextImageNameKey: UInt8 = 0
private var SwiftKeyboardAccessoryKeyboardVisibleKey: UInt8 = 0
private var SwiftKeyboardAccessoryAccessoryViewKey: UInt8 = 0
private var SwiftKeyboardAccessorySortedTextFieldsIndexPathsKey: UInt8 = 0
private var SwiftKeyboardAccessoryTextFieldCellIndexPathKey: UInt8 = 0

private let kToolbarHeight: CGFloat = 50

/// Helper class to store Closures using objc-runtime
private class ReturnClosureWrapper {
  var closure: ((UITextField) -> Void)?
  
  init(closure: ((UITextField) -> Void)?) {
    self.closure = closure
  }
}

/// Adds helper properties to UITextFields in UITableViews
extension UITextField {
  
  var cellIndexPath:NSIndexPath? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessoryTextFieldCellIndexPathKey ) as? NSIndexPath
    }
    set(value) {
      objc_setAssociatedObject( self, &SwiftKeyboardAccessoryTextFieldCellIndexPathKey, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC) )
    }
  }
  
}

/// Extended properties for UIViewController
extension UIViewController {
  
  /// The view to resize, can be any subclass of UIScrollView, like a UITableView
  var viewToResize:UIScrollView? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessoryViewToResizeKey ) as? UIScrollView
    }
    set(value) {
      if value != nil {
        let tapper = UITapGestureRecognizer(target: self, action: "handleTap" )
        tapper.cancelsTouchesInView = false
        value?.addGestureRecognizer( tapper )
      }
      setProperty( &SwiftKeyboardAccessoryViewToResizeKey, value: value )
    }
  }

  /// Currently editing text field
  var currentTextField:UITextField? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessoryCurrentTextFieldKey ) as? UITextField
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessoryCurrentTextFieldKey, value: value )
    }
  }

  /// The index path for the currently editing text field when in a UITableView
  var currentTextFieldIndexPath:NSIndexPath? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessoryCurrentTextFieldIndexPathKey ) as? NSIndexPath
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessoryCurrentTextFieldIndexPathKey, value: value )
    }
  }

  /// Index path for the next text field
  var nextIndexPath:NSIndexPath? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessoryNextIndexPathKey ) as? NSIndexPath
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessoryNextIndexPathKey, value: value )
    }
  }
  
  /// List of sorted text fields
  var sortedTextFields:[UITextField]? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessorySortedTextFieldsKey ) as? [UITextField]
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessorySortedTextFieldsKey, value: value )
    }
  }

  /// List of sorted index paths for text fields
  var sortedTextFieldsIndexPaths:[NSIndexPath]? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessorySortedTextFieldsIndexPathsKey ) as? [NSIndexPath]
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessorySortedTextFieldsIndexPathsKey, value: value )
    }
  }

  /// Height of view when keyboard is hidden
  var previousViewHeight:CGFloat {
    get {
      if let value = objc_getAssociatedObject( self, &SwiftKeyboardAccessoryViewHeightKey ) as? Double {
        return CGFloat(value)
      }
      else {
        return 0
      }
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessoryViewHeightKey, value: value )
    }
  }
  
  /// The UIBarButtonItem to move to the previous text field
  var previousButton:UIBarButtonItem? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessoryPreviousButtonKey ) as? UIBarButtonItem
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessoryPreviousButtonKey, value: value )
    }
  }
  
  /// The UIBarButtonItem to move to the next text field
  var nextButton:UIBarButtonItem? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessoryNextButtonKey ) as? UIBarButtonItem
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessoryNextButtonKey, value: value )
    }
  }
  
  /// A UITextFieldDelegate to be called after processing the events (textField:didBeginEditing)
  var textFieldDelegate:UITextFieldDelegate? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessoryTextFieldDelegateKey ) as? UITextFieldDelegate
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessoryTextFieldDelegateKey, value: value )
    }
  }
  
  /// A closure to invoke when the Go button is tapped in a text field
  var goClosure:((UITextField)->(Void))? {
    get {
      
      if let wrapper = objc_getAssociatedObject(self, &SwiftKeyboardAccessoryReturnClosureKey) as? ReturnClosureWrapper {
        return wrapper.closure
      }
      return nil
    }
    set(value) {
      objc_setAssociatedObject( self, &SwiftKeyboardAccessoryReturnClosureKey, ReturnClosureWrapper(closure: value), objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC) )
    }
  }

  /// A Closure to be called after processing the events (textField:didBeginEditing)
  var textFieldBeginEditingClosure:((UITextField)->(Void))? {
    get {
      
      if let wrapper = objc_getAssociatedObject(self, &SwiftKeyboardAccessorytextFieldEndEditingClosureKey) as? ReturnClosureWrapper {
        return wrapper.closure
      }
      return nil
    }
    set(value) {
      objc_setAssociatedObject( self, &SwiftKeyboardAccessorytextFieldEndEditingClosureKey, ReturnClosureWrapper(closure: value), objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC) )
    }
  }

  /// Image name for the previous button
  var prevButtonImageName:String? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessoryPrevImageNameKey ) as? String
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessoryPrevImageNameKey, value: value )
    }
  }
  
  /// Image name for the next button
  var nextButtonImageName:String? {
    get {
      return objc_getAssociatedObject( self, &SwiftKeyboardAccessoryNextImageNameKey ) as? String
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessoryNextImageNameKey, value: value )
    }
  }
  
  private var keyboardVisible:Bool {
    get {
      if let value = objc_getAssociatedObject( self, &SwiftKeyboardAccessoryKeyboardVisibleKey ) as? Bool {
        return value
      }
      else {
        return false
      }
    }
    set(value) {
      setProperty( &SwiftKeyboardAccessoryKeyboardVisibleKey, value: value )
    }
  }
  
  private var inputAccessoryToolbar:UIToolbar {
    get {
      if let toolbar = objc_getAssociatedObject( self, &SwiftKeyboardAccessoryAccessoryViewKey ) as? UIToolbar {
        return toolbar
      }
      else {
        let toolbar = createToolbar()
        setProperty( &SwiftKeyboardAccessoryAccessoryViewKey, value: toolbar )
        return toolbar
      }
    }
  }
  
  /**
    Register the keyboard accessory handler. Must call this from viewWillAppear.
  */
  func registerKeyboardAccessoryHandler() {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver( self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    notificationCenter.addObserver( self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
  }
  
  /**
    Unregister the keyboard accessory handler. Must call this from viewWillDisappear.
  */
  func unregisterKeyboardAccessoryHandler() {
    NSNotificationCenter.defaultCenter().removeObserver( self )
  }
  
  private func createToolbar() -> UIToolbar {
    var toolbar = UIToolbar(frame: CGRectMake( 0, 0, self.view.frame.size.width, kToolbarHeight ) )
    toolbar.barStyle = .Default
    var items = [UIBarButtonItem]()
    if sortedTextFields?.count > 0 || sortedTextFieldsIndexPaths?.count > 0 {
      var previousButton:UIBarButtonItem!
      if self.prevButtonImageName != nil {
        previousButton = UIBarButtonItem(image: UIImage(named: self.prevButtonImageName!), style: .Plain, target: self, action: "goToPreviousField" )
      }
      else {
        previousButton = UIBarButtonItem( title: NSLocalizedString("Prev",comment:""), style: .Plain, target: self, action: "goToPreviousField" )
      }
      //            previousButton.tintColor = theme.tintColor
      self.previousButton = previousButton
      
      var nextButton:UIBarButtonItem!
      if self.nextButtonImageName != nil {
        nextButton = UIBarButtonItem(image: UIImage(named: self.nextButtonImageName!), style: .Plain, target: self, action: "goToNextField" )
      }
      else {
        nextButton = UIBarButtonItem( title: NSLocalizedString("Next",comment:""), style: .Plain, target: self, action: "goToNextField" )
      }
      //            nextButton.tintColor = theme.tintColor;
      self.nextButton = nextButton;
      
      items.append( previousButton )
      var separator = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
      separator.width = 20.0
      items.append( separator )
      items.append( nextButton )
    }
    items.append( UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil) )
    var doneButton = UIBarButtonItem(title: NSLocalizedString("Done",comment:""), style: .Plain, target: self, action: "textFieldDone" )
    //        doneButton.tintColor = theme.tintColor
    items.append( doneButton )
    toolbar.items = items
    toolbar.sizeToFit()
    toolbar.alpha = 0.5
    updatePrevNextButtonState()
    return toolbar
  }
  
  private func setProperty( key:UnsafePointer<Void>, value:AnyObject? ) {
    objc_setAssociatedObject( self, key, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC) )
  }
  
  private func goToField( direction: Int ) {
    var target:Int = -1
    var count:Int = 0
    (target,count) = findCurrentField()
    if target != -1 {
      target += direction
      if target >= 0 && target < count {
        goToFieldAtIndex( target )
      }
    }
  }
  
  private func findCurrentField() -> (Int,Int) {
    var target:Int = -1
    var count:Int = 0
    if let sortedFields = sortedTextFields, let currentTextField = currentTextField {
      count = sortedFields.count
      var index:Int
      for index = 0; index < sortedFields.count; index++ {
        if sortedFields[index] == currentTextField {
          target = index
          break
        }
      }
    }
    else if let sortedFieldsIndexPaths = sortedTextFieldsIndexPaths, let currentTextFieldIndexPath = currentTextFieldIndexPath {
      count = sortedFieldsIndexPaths.count
      var index:Int
      for index = 0; index < sortedFieldsIndexPaths.count; index++ {
        if sortedFieldsIndexPaths[index] == currentTextFieldIndexPath {
          target = index
          break
        }
      }
    }
    return (target,count)
  }
  
  private func goToFieldAtIndex( index: Int ) {
    if let tableView = viewToResize as? UITableView {
      var indexPath:NSIndexPath?
      if let sortedTextFields = sortedTextFields {
        if sortedTextFields.count > index {
          let textField = sortedTextFields[index]
          indexPath = textField.cellIndexPath
        }
      }
      else if let sortedTextFieldsIndexPaths = sortedTextFieldsIndexPaths {
        if sortedTextFieldsIndexPaths.count > index {
          indexPath = sortedTextFieldsIndexPaths[index]
        }
      }
      if indexPath != nil {
        nextIndexPath = indexPath
        tableView.scrollToRowAtIndexPath( indexPath!, atScrollPosition: .None, animated: true )
        tableView.delegate?.tableView!( tableView, didSelectRowAtIndexPath: indexPath! )
      }
    }
    else if let sortedTextFields = sortedTextFields {
      if sortedTextFields.count > index  {
        let textField = sortedTextFields[index]
        textField.becomeFirstResponder()
      }
    }
  }
  
  private func restoreViews() {
    if previousViewHeight > 0 {
      if let view = viewToResize {
        var frame = view.frame
        frame.size.height = previousViewHeight
        view.frame = frame
      }
    }
  }
  
  private func adjustFrameHeight( size: CGSize ) -> CGFloat {
    if floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1 &&
      (UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeRight ||
        UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeLeft) {
          // iOS 7.1 or lower and landscape mode -> interchange width and height
          return size.width
    }
    else {
      return size.height
    }
  }
  
  private func updatePrevNextButtonState() {
    nextButton?.enabled = false
    previousButton?.enabled = false
    var target:Int = -1
    var count:Int = 0
    (target,count) = findCurrentField()
    if target != -1 {
      nextButton?.enabled = target < (count - 1)
      previousButton?.enabled = target > 0
    }
  }
}

/// Event handlers.
extension UIViewController {
  
  @objc func handleTap() {
    restoreViews()
    self.view.endEditing( true )
  }
  
  @objc func textFieldDone() {
    restoreViews()
    currentTextField?.resignFirstResponder()
  }
  
  @objc func keyboardDidShow( notification:NSNotification ) {
    if keyboardVisible {
      return
    }
    if let userInfo = notification.userInfo, let value: NSValue = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
      let keyboardSize = value.CGRectValue().size
      if let targetView:UIScrollView = viewToResize {
        previousViewHeight = targetView.frame.size.height
        var frame = targetView.frame
        frame.size.height = frame.size.height - adjustFrameHeight( keyboardSize )
        targetView.frame = frame
        if !(targetView is UITableView) {
          var maxY:CGFloat = 0
          var contentWidth:CGFloat = 0
          var i:Int
          for subview in targetView.subviews {
            if let subView = subview as? UIView {
              if !subView.hidden {
                contentWidth = max( contentWidth, subview.frame.size.width )
                maxY = max( maxY, subView.frame.origin.y + subView.frame.size.height )
              }
            }
          }
          targetView.contentSize = CGSizeMake( contentWidth, maxY )
          if let currentField = currentTextField {
            targetView.scrollRectToVisible(currentField.frame, animated: true)
          }
        }
      }
    }
    keyboardVisible = true
  }
  
  @objc func keyboardDidHide( notification:NSNotification ) {
    if !keyboardVisible {
      return
    }
    restoreViews()
    keyboardVisible = false
  }
  
  @objc func goToPreviousField() {
    goToField( -1 )
  }
  
  @objc func goToNextField() {
    goToField( 1 )
  }
  
}

/// MARK: UITextFieldDelegate
extension UIViewController : UITextFieldDelegate {
  
  public func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField.returnKeyType == .Go && self.goClosure != nil {
      self.goClosure!( textField )
      return true
    }
    
    if textField.returnKeyType == .Next  && self.sortedTextFields != nil {
      goToNextField()
    }
    else {
      restoreViews()
      textField.resignFirstResponder()
    }
    return true
  }
  
  public func textFieldDidBeginEditing(textField: UITextField) {
    if textField.enabled {
      self.currentTextField = textField
      if let tableView = viewToResize as? UITableView {
        self.currentTextFieldIndexPath = textField.cellIndexPath
        if self.currentTextFieldIndexPath == nil {
          var cell:UITableViewCell?
          var superView = textField.superview
          while superView != nil && cell == nil {
            if let cellValue = superView as? UITableViewCell {
              cell = cellValue
            }
            else {
              superView = superView?.superview
            }
          }
          if cell != nil {
            if let path = tableView.indexPathForCell( cell! ) {
              textField.cellIndexPath = path
              self.currentTextFieldIndexPath = path
            }
          }
        }
      }
      if textField.inputAccessoryView == nil {
        textField.inputAccessoryView = self.inputAccessoryToolbar
      }
      updatePrevNextButtonState()
    }
    if self.textFieldBeginEditingClosure != nil {
      self.textFieldBeginEditingClosure!( textField )
    }
    else if self.textFieldDelegate != nil {
      if self.textFieldDelegate!.respondsToSelector("textFieldDidBeginEditing") {
        self.textFieldDelegate!.textFieldDidBeginEditing!( textField )
      }
    }
  }
}