//
//  ViewController.swift
//  PersistenceCoreData
//
//  Created by Dmitry Tolmachev on 21.01.2019.
//  Copyright © 2019 Dmitry Tolmachev. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    private static let lineEntityName = "User"
    private static let lineNumberKey = "lineNumber"
    private static let lineTextKey = "lineText"
    
    @IBOutlet weak var mainTableView: UITableView!
    
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAnyThing()
        // Дополнительная настройка после загрузки представления, обычно из файла nib
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ViewController.lineEntityName)
        do {
            let objects = try context.fetch(request)
            for object in objects {
                let lineNum: Int = (object as AnyObject).value(forKey: ViewController.lineNumberKey)! as! Int
                let lineText = (object as AnyObject).value(forKey: ViewController.lineTextKey) as? String ?? ""
                let textField = lineFields[lineNum]
                textField.text = lineText
            }
            let app = UIApplication.shared
            NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name.NSExtensionHostWillResignActive, object: app)
        } catch {
            print("There was an error in executeFetchRequest(): \(error)")
        }
        title = "Аптеки"
        mainTableView.register(UITableViewCell.self,forCellReuseIdentifier: "Cell")
    }
    
    func applicationWillTerminate(application: UIApplication) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.save()
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        for i in 0..<lineFields.count {
            let textField = lineFields[i]
            
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ViewController.lineEntityName)
            let pred = NSPredicate(format: "%K = %d", ViewController.lineNumberKey, i)
            request.predicate = pred
            do {
                let objects = try context.fetch(request)
                var theLine: NSManagedObject! = objects.first as? NSManagedObject
                if theLine == nil {
                    // нет данных для этой строки - вставляем в нее новый управляемый объект
                    theLine = NSEntityDescription.insertNewObject(forEntityName: ViewController.lineEntityName, into: context) as NSManagedObject
                    }
                theLine.setValue(i, forKey: ViewController.lineNumberKey)
                theLine.setValue(textField.text, forKey: ViewController.lineTextKey)
            } catch {
                print("There was an error in executeFetchRequest(): \(error)")
            }
        }
        appDelegate.save()
    }
    
    func createAnyThing() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let users = User(context: context)
        users.lineNumber = 0
        users.lineText = "Привет"
        
        users.lineNumber = 1
        users.lineText = "Привет3"
        appDelegate.save()
        
    }

    

}

