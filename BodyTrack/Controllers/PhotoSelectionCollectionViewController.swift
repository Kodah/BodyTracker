//
//  PhotoSelectionCollectionViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 14/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit
import CoreData
import ECSlidingViewController

enum ActionSheetButton: Int {
    case camera = 1
    case photoLibrary
}

class PhotoSelectionCollectionViewController: UICollectionViewController, MenuTableViewControllerDelegate,
UITextFieldDelegate, UIActionSheetDelegate,
CustomCameraViewControllerDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var imagePickerControllerHelper: ImagePickerControllerHelper!

    var progressCollection = ProgressCollection() {

        didSet {
            updateViewForProgressCollection()
            fetchResultsController.fetchRequest.predicate = NSPredicate(format: "progressCollection == %@",
                                                                        progressCollection)
            do {
                try fetchResultsController.performFetch()
                collectionView?.reloadData()
                syncImages()
            } catch let err {
                print(err)
            }
        }
    }
    
    var selectedProgressPoint: ProgressPoint?
    var alertController: UIAlertController?
    var selectMode: Bool = false
    var buttonForRightBarButton: UIButton?
    var progressPointsToCompare: ProgressPointsToCompare?

    lazy var fetchResultsController: NSFetchedResultsController<ProgressPoint> = {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest<ProgressPoint>(entityName: "ProgressPoint")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context!,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        collectionView?.reloadData()
    }
    
    var selectedProgressPoints = [ProgressPoint]()
    var imageCache = [String: UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInitialProgressCollection()
       
        do {
            try fetchResultsController.performFetch()
            syncImages()
        } catch let err {
            print(err)
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
    
    func loadInitialProgressCollection() {
        if let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext {
            ProgressCollection.getFirstProgressCollectionIn(context) {progressCollection in
                self.progressCollection = progressCollection
            }
        }
    }
    
    func updateViewForProgressCollection() {
        title = progressCollection.name
        navigationController?.navigationBar.barTintColor = UIColor(rgba: progressCollection.colour!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        selectedProgressPoint = nil
        progressPointsToCompare = nil
        do {
            try fetchResultsController.performFetch()
            syncImages()
        } catch let err {
            print(err)
        }
    }
    
    func navBarTapped() {
        performSegue(withIdentifier: SegueIdentifier.segueToEditCollection,
                     sender: self)
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
            navigationItem.title = progressCollection.name
            buttonForRightBarButton?.imageView?.tintColor = UIColor.white
            //deselect all cells
            selectedProgressPoints.removeAll()
            deselectAllCellsInCollectionView()
        } else {
            selectMode = true
            navigationItem.title = "Select Two Cells"
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            buttonForRightBarButton?.imageView?.tintColor = UIColor.yellow
        }

    }

    // Menu Delegate
    func newProgressCollectionButtonTapped() {
        slidingViewController().resetTopView(animated: true)
        setupAlertController()
    }
    
    func setProgressCollection(progressCollection: ProgressCollection) {
        self.progressCollection = progressCollection
    }

    // Alert Delegate
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

    func createNewProgressPoint(_ image: UIImage) throws {
        let progressPointBuilder = ProgressPointBuilder { builder in
            builder.progressCollection = progressCollection
            builder.image = image
        }
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        guard ProgressPoint(builder: progressPointBuilder, context: context!) != nil else {
            throw ProgressPointError.failedToInitialise
        }
        do {
            try context?.save()
        } catch let err {
            print(err)
        }
    }
    
    func customCameraDidFinishTakingPicture(image: UIImage) {
        do {
            try createNewProgressPoint(image)
        } catch let err {
            print(err)
        }
        
    }

    //menu delegate
    func showActionSheet() {
        let actionSheet = UIActionSheet(title: "New photo",
                                        delegate: self,
                                        cancelButtonTitle: "Cancel",
                                        destructiveButtonTitle: nil,
                                        otherButtonTitles: "Use Camera", "Photo library")

        actionSheet.show(in: view)
    }

    func createNewProgressCollectionWithName(_ name: String) {
        if let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext {
            if let newProgressCollection: ProgressCollection =
                NSEntityDescription.insertNewObject(forEntityName: "ProgressCollection", into: context)
                    as? ProgressCollection {
                newProgressCollection.name = name
                newProgressCollection.colour = UIColor.hexValuesFromUIColor(UIColor.randomColor())
                newProgressCollection.identifier = UUID().uuidString

                do {
                    try context.save()
                } catch {}
                progressCollection = newProgressCollection
            }

        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifierForSegue(segue: segue) {
        case .segueToProgressPoint:

            if let viewController = segue.destination as? ProgressPointDetailTableViewController {
                viewController.progressPoint = selectedProgressPoint

                if let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext {
                    viewController.context = context
                }
            }

        case .segueToEditCollection :
            if let viewController = segue.destination.childViewControllers.first
                as? EditProgressCollectionViewController,
                let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext {
                viewController.context = context
                viewController.progressCollection = progressCollection
            }
        case .segueToCompareTabBar:

            if let tabBar = segue.destination as? CompareTabViewController {
                tabBar.progressPointsToCompare = progressPointsToCompare
            }

        case .segueToCustomCamera:
            if let customCameraViewController = segue.destination as? CustomCameraViewController {
                customCameraViewController.overlayImage = progressCollection.latestProgressPoint()?.getImage()
                customCameraViewController.delegate = self
            }
        }
    }
}
