//
//  PhotoSelectionCollectionViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 14/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit
import CoreData

enum ActionSheetButton: Int {
    case camera = 1
    case photoLibrary
}

class ProgressPointsToCompare {
    let firstProgressPoint: ProgressPoint
    let secondProgressPoint: ProgressPoint

    init(firstProgressPoint: ProgressPoint, secondProgressPoint: ProgressPoint) {
        if firstProgressPoint.date.compare(secondProgressPoint.date) == ComparisonResult.orderedAscending {
            self.firstProgressPoint = firstProgressPoint
            self.secondProgressPoint = secondProgressPoint
        } else {
            self.firstProgressPoint = secondProgressPoint
            self.secondProgressPoint = firstProgressPoint
        }
    }
}

class PhotoSelectionCollectionViewController: UICollectionViewController, MenuTableViewControllerDelegate,
UITextFieldDelegate, UIActionSheetDelegate, CustomCameraViewControllerDelegate {

    let segueToCompareTabBar = "GoToCompareSegueId"
    let segueToEditCollection = "EditProgressCollectionSegue"
    let segueToCustomCamera = "ShowCustomCamera"

    @IBOutlet var imagePickerControllerHelper: ImagePickerControllerHelper!

    var progressCollection: ProgressCollection?
//    var progressPoints = [ProgressPoint]()
    var context: NSManagedObjectContext?
    var selectedProgressCollection: ProgressCollection?
    var selectedProgressPoint: ProgressPoint?
    var alertController: UIAlertController?
    var selectMode: Bool = false
    var buttonForRightBarButton: UIButton?
    var progressPointsToCompare: ProgressPointsToCompare?
    
    var progressPoints = [ProgressPoint]() {
        didSet {
            syncImages()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get first progress collection
        
        // Send progress collections points to collection view
        // fill out nav bar with info from progress collection
        
        if let context = context {
            
            ProgressCollection.GetFirstProgressCollectionIn(context) {progressCollection in
                title = progressCollection.name
                navigationController?.navigationBar.barTintColor = UIColor(rgba: progressCollection.colour)
                self.progressCollection = progressCollection
                sendProgressPointsToCollectionView()
            }
        }

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
            
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger"),
                                                style: UIBarButtonItemStyle.plain,
                                                target: self,
                                                action: #selector(PhotoSelectionCollectionViewController.openMenu))
            
        navigationItem.leftBarButtonItem = barButtonItem
            
        collectionView?.allowsMultipleSelection = true
            
        buttonForRightBarButton = UIButton(type: UIButtonType.custom)
        if let button = buttonForRightBarButton {
            var image = UIImage(named: "muscle")
            image = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            button.setImage(image, for: UIControlState())
            button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            button.addTarget(self,
                                action: #selector(PhotoSelectionCollectionViewController.rightBarButtonTapped),
                                for: UIControlEvents.touchUpInside)
            button.imageView?.tintColor = UIColor.white
                
            let rightBarButtonItem = UIBarButtonItem(customView: button)
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }

        let tapNavGesture = UITapGestureRecognizer(target: self,
                                                   action: #selector(
                                                    PhotoSelectionCollectionViewController.navBarTapped
            ))
        navigationController?.navigationBar.addGestureRecognizer(tapNavGesture)
        
        clearsSelectionOnViewWillAppear = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        _ = progressCollection
        loadProgressPointsForProgressCollection(nil)

        if let collectionView = collectionView {
            collectionView.performBatchUpdates({ () -> Void in
                collectionView.reloadData()
            }, completion: { (_) -> Void in })
        }
    }
    
    func sendProgressPointsToCollectionView () {
        if let proCol = progressCollection, let proPoints = Array(proCol.progressPoints) as? [ProgressPoint] {
            
            progressPoints = proPoints.sorted {$0.0.date < $0.1.date}
        }
    }

    func navBarTapped() {
        performSegue(withIdentifier: segueToEditCollection, sender: self)
    }

    func openMenu() {
        if slidingViewController().currentTopViewPosition == ECSlidingViewControllerTopViewPosition.centered {
            slidingViewController().anchorTopViewToRight(animated: true)
        } else {
            slidingViewController().resetTopView(animated: true)
        }

    }

    func rightBarButtonTapped() {
        if selectMode {
            selectMode = false
            navigationItem.title = progressCollection?.name
            buttonForRightBarButton?.imageView?.tintColor = UIColor.white
            //deselect all cells
            deselectAllCellsInCollectionView()
        } else {
            selectMode = true
            navigationItem.title = "Select Two Cells"
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            buttonForRightBarButton?.imageView?.tintColor = UIColor.yellow
        }

    }

    func initiateNewProgressCollection() {
        slidingViewController().resetTopView(animated: true)
        setupAlertController()
    }

    func setupAlertController() {
        alertController = UIAlertController(title: "New Collection",
                                            message: "Edit name",
                                            preferredStyle: UIAlertControllerStyle.alert)

        var nameTextField: UITextField?

        alertController!.addTextField { (textField) -> Void in
            textField.placeholder = "name"
            nameTextField = textField
            nameTextField?.delegate = self
            nameTextField?.addTarget(self,
                                     action: #selector(PhotoSelectionCollectionViewController.textFieldChanged(_:)),
                                     for: UIControlEvents.editingChanged)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (_) -> Void in
            self.slidingViewController().anchorTopViewToRight(animated: true)
        }
        let OKAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (_) -> Void in
            if let name = nameTextField?.text {
                self.createNewProgressCollectionWithName(name)
            }
        }

        OKAction.isEnabled = false
        alertController!.addAction(cancelAction)
        alertController!.addAction(OKAction)

        present(alertController!, animated: true, completion: nil)
    }

    func textFieldChanged(_ textField: UITextField) {
        if let alertController = alertController {
            let actions = alertController.actions
            if (textField.text?.characters.count)! > 0 {

                for action in actions {
                    action.isEnabled = true
                }
            } else {

                actions[1].isEnabled = false
            }
        }
    }

    // actionsheet delegate

    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case ActionSheetButton.camera.rawValue:
            print("open custom camera")

            performSegue(withIdentifier: "ShowCustomCamera", sender: self)

//            let imagePickerController = imagePickerControllerHelper.getCameraFromHelper()
//            
//            present(imagePickerController, animated: true, completion: nil)

            break
        case ActionSheetButton.photoLibrary.rawValue:
            print("Open photos to select photo")

            let imagePickerController = imagePickerControllerHelper.getImagePickerFromHelper()

            present(imagePickerController, animated: true, completion: nil)

            break
        default:
            break
        }
    }

    func createNewProgressPoint(_ image: UIImage) {
        let rotatedImage = image.imageRotatedBy90Degrees(flip: false)

        let date: Date = Date()

        let fileManager = FileManager.default

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let uuid = UUID().uuidString

        let fileName = "\(uuid).png"

        let filePathToWrite = "\(paths)/\(fileName)"

        let imageData: Data = UIImagePNGRepresentation(rotatedImage)!

        fileManager.createFile(atPath: filePathToWrite, contents: imageData, attributes: nil)

        if let newProgressPoint: ProgressPoint = NSEntityDescription.insertNewObject(forEntityName: "ProgressPoint",
                                                                                     into: context!) as? ProgressPoint {
            newProgressPoint.progressCollection = progressCollection
            newProgressPoint.imageName = fileName
            newProgressPoint.date = date

            NotificationFactory().scheduleNotificationForProgressCollection(newProgressPoint.progressCollection)

            do {
                try context?.save()
            } catch let error {
                print("error \(error.localizedDescription)")
            }

            if let proCol = progressCollection {
                let copyProgressCollection: ProgressCollection = proCol
                loadProgressPointsForProgressCollection(copyProgressCollection)
            }
        }
    }

    func customCameraDidFinishTakingPicture(image: UIImage) {
        createNewProgressPoint(image)
    }

    //menu delegate

    func loadProgressPointsForProgressCollection(_ progressCollection: ProgressCollection?) {

        if let progressCollection = progressCollection {
            self.progressCollection = progressCollection
        }

        if let safeProgressCollection = progressCollection {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgressPoint")
            let predicate = NSPredicate(format: "progressCollection == %@", safeProgressCollection)
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]

            fetchRequest.predicate = predicate

            sendProgressPointsToCollectionView()

            title = safeProgressCollection.name
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = UIColor(rgba: safeProgressCollection.colour)

            collectionView?.reloadData()
        }
    }

    func showActionSheet() {
        let actionSheet = UIActionSheet(title: "New photo",
                                        delegate: self,
                                        cancelButtonTitle: "Cancel",
                                        destructiveButtonTitle: nil,
                                        otherButtonTitles: "Use Camera", "Photo library")

        actionSheet.show(in: view)
    }

    func createNewProgressCollectionWithName(_ name: String?) {
        if let context = context {
            if let newProgressCollection: ProgressCollection =
                NSEntityDescription.insertNewObject(forEntityName: "ProgressCollection", into: context)
                    as? ProgressCollection {
                newProgressCollection.name = name
                newProgressCollection.colour = UIColor.hexValuesFromUIColor(UIColor.randomColor())
                newProgressCollection.identifier = UUID().uuidString

                do { try context.save() } catch {}
                loadProgressPointsForProgressCollection(newProgressCollection)
            }

        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "ShowProgressPointDetailId":

            if let viewController = segue.destination as? ProgressPointDetailTableViewController {
                viewController.progressPoint = selectedProgressPoint

                if let context = context {
                    viewController.context = context
                }
            }

        case segueToEditCollection:
            if let viewController = segue.destination.childViewControllers.first
                as? EditProgressCollectionViewController,
                let context = context,
                let progressCollection = progressCollection {
                viewController.context = context
                viewController.progressCollection = progressCollection
            }
        case segueToCompareTabBar:

            if let tabBar = segue.destination as? CompareTabViewController {
                tabBar.progressPointsToCompare = progressPointsToCompare
            }

        case segueToCustomCamera:
            if let customCameraViewController = segue.destination as? CustomCameraViewController {
                customCameraViewController.delegate = self
                customCameraViewController.overlayImage = progressCollection?.latestProgressPoint()?.getImage()
            }
        default:
            break
        }
    }
}
