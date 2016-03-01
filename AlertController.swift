

import UIKit
import Foundation

/*A set of button combinations*/
public enum AlertControllerButtons: Int {
	
	/*
	Remark:
	If two button titles are given in one case, the first one will be on the left and the second on the right
	According to Apple's human interface design guidelines, the placing should be chosen according to this:
	“When the most likely button performs a nondestructive action, it should be on the right in a two-button alert. The button that cancels this action should be on the left.
	When the most likely button performs a destructive action, it should be on the left in a two-button alert. The button that cancels this action should be on the right.”
	The style 'Cancel' means bold letters, i.e. 'safe choice'. 
	So the .Cancel style may be used for a button different from "Skip" or "Cancel", so long as it represents the safest choice for the user.
	*/
    case OK = 0
    case CancelOK = 1
    case CancelContinue = 2
	case SkipContinue = 3
	case NoYes = 4
}

/*
Make use of AlertController and its :present method to conveniently present a UIAlertController object.
The button combinations are enumerated in AlertControllerButtons.

Action handlers can be handed over through closures. 
If only one button is present on the user alert, the closure 'btn2Action' will be disregarded. 

Remark: The alert controller will work only with iOS 8.0 onwards
*/

public class AlertController {
	
	var alertController: UIAlertController?
	var title: String
	var messageText: String
	
	//Alert actions, both of which are optional
	var btn1Action: (() -> Void)? 
	var btn2Action: (() -> Void)?
	
	//Alert controller buttons
				
	//OK = Button1
	var alertActionOK1: UIAlertAction?
	 
	//OK = Button2
	var alertActionOK2: UIAlertAction?
	
	//Continue  = Button2
	var alertActionContinue: UIAlertAction?
	
	//Cancel  = Button1
	var alertActionCancel: UIAlertAction?
	
	//Skip = Button 1	
	var alertActionSkip: UIAlertAction?
	
	//Yes = Button 2
	var alertActionYes: UIAlertAction?
	
	//No = Button 1
	var alertActionNo: UIAlertAction?
		
	
	//Connects the buttons specified with their respective actions
	private func addActionsToButtons(buttons: AlertControllerButtons) {
	
		switch buttons {
						
			/*Note that all alert actions are force-unwrapped.
			As the initializer, so long as it has not failed, will have initializied these variables, they will not be nil */ 
						
			case .CancelOK:
				alertController!.addAction(alertActionOK2!)
				alertController!.addAction(alertActionCancel!)
			
			case .CancelContinue:
				alertController!.addAction(alertActionContinue!)
				alertController!.addAction(alertActionCancel!)
				
			case .SkipContinue:
				alertController!.addAction(alertActionContinue!)
				alertController!.addAction(alertActionSkip!)
				
			case .NoYes:
				alertController!.addAction(alertActionYes!)
				alertController!.addAction(alertActionNo!)
			
			case .OK: fallthrough
				
			default:
				alertController!.addAction(alertActionOK1!)
		}
	}
	
	
	init?(buttons: AlertControllerButtons, title t: String, messageText msg: String, btn1Action: (() -> Void)?, btn2Action: (() -> Void)?) {
	
		//The initialization will fail if UIAlertController isn't supported by the operating system
		if objc_getClass("UIAlertController") != nil { 
						
			title = t
			messageText = msg	
			
			alertController = UIAlertController(title: title, message: messageText, preferredStyle: UIAlertControllerStyle.Alert)
			
			self.btn1Action = btn1Action
			self.btn2Action = btn2Action
						
			//Assign actions to buttons
			
			alertActionOK1 = UIAlertAction(title: "OK", style: .Default) { (UIAlertAction) -> Void in
				if let action = btn1Action {
					action()}
			} 
			 
			alertActionOK2 = UIAlertAction(title: "OK", style: .Default) { (UIAlertAction) -> Void in
				if let action = btn2Action {
					action()}
			}  
			
			alertActionContinue = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
				if let action = btn2Action {
					action()}
			} 
			
			alertActionCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (UIAlertAction) -> Void in
				if let action = btn1Action {
					action()}
			} 
				
			alertActionSkip = UIAlertAction(title: "Skip", style: .Destructive) { (UIAlertAction) -> Void in
				if let action = btn1Action {
					action()}
			} 
			
			alertActionYes = UIAlertAction(title: "Yes", style: .Default) { (UIAlertAction) -> Void in
				if let action = btn2Action {
					action()
				}
			} 
			
			alertActionNo = UIAlertAction(title: "No", style: .Cancel) { (UIAlertAction) -> Void in
				if let action = btn1Action {
					action()
				}
			} 
		
			addActionsToButtons(buttons)
						
		} else {
            
			//UIAlertController is not available before 8.0.
            NSLog("This app supports only iOS versions 8.0 and later")
			
			title = ""
			messageText = ""
			
			return nil
        }
	}
	
	
	//Presents the alert controller modally on top of parent
    func present(parent parent: UIViewController) {

		parent.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
		parent.presentViewController(alertController!, animated: true) { () -> Void in }
    }
}