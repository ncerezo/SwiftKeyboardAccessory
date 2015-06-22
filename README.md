# SwiftKeyboardAccessory
Swift extension for iOS that automatically resize view when keyboard appears, scrolls the view so the focused control is visible and provides an accessory view with text field navigation and keyboard dismissal button.

It also provides an easy way to move from one text field to another, with Next and Previous buttons on the toolbar. And of course, ends text editing when you tap outside a text field.

The basic use is illustrated in this example, using a UITableViewController:

```swift
import UIKit

class MyCellView : UITableViewCell {
  
  // Create a suitable cell view in IB and bind this text field
  @IBOutlet weak var textField: UITextField!

}

class ViewController: UITableViewController {

  private var texts = [Int:String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // this will make the table view to get properly resized and positioned when keyboard appears
    viewToResize = tableView
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    // You just need to call this one before the view appears
    registerKeyboardAccessoryHandler()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    // And this one before it disappears
    unregisterKeyboardAccessoryHandler()
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MyCellView
    // If you bind the textField.delegate using IB you can even remove this line
    cell.textField.delegate = self
    cell.textField.cellIndexPath = indexPath
    cell.textField.placeholder = String(indexPath.row)
    if let text = texts[indexPath.row] {
      cell.textField.text = text
    }
    else {
      cell.textField.text = ""
    }
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MyCellView {
      cell.textField.becomeFirstResponder()
    }
  }

}

extension ViewController : UITextFieldDelegate {
  
  func textFieldDidEndEditing(textField: UITextField) {
    if let path = textField.cellIndexPath {
      self.texts[path.row] = textField.text
    }
  }

}
```

This a full, very simple, working example. But the minimum code you need to get this working is:

In viewDidLoad:
```swift
    viewToResize = tableView
```

In viewWillAppear
```swift
    registerKeyboardAccessoryHandler()
```

In viewWillDisappear
```swift
    unregisterKeyboardAccessoryHandler()
```

In cellForRowAtIndexPath:
```swift
    cell.textField.cellIndexPath = indexPath
```

In didSelectRowAtIndexPath:
```swift
    if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MyCellView {
      cell.textField.becomeFirstResponder()
    }
```

If you want to show also Prev and Next buttons just add this to viewDidLoad:

```swift
    sortedTextFieldsIndexPaths = [NSIndexPath]()
    for index in 0...19 {
      sortedTextFieldsIndexPaths!.append(NSIndexPath(forRow: index, inSection: 0))
    }
```
