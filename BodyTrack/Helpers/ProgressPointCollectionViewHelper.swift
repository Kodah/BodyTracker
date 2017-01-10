//
//  ProgressPointCollectionViewHelper.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 18/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class ProgressPointCollectionViewHelper: NSObject, UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    let segueToCompareTabBar: String = "GoToCompareSegueId"
    let reuseIdentifier = "Cell"
    let progressPointSegueId = "showProgressPointId"
    let bodyReuseIdentifier = "BodyCollectionViewCellId"
    let addReuseIdentifier = "AddCollectionViewId"
    var progressPoints = [ProgressPoint]() {
        didSet {
            syncImages()
        }
    }
    var selectMode: Bool = false
    var selectedProgressPoints = [ProgressPoint]()
    var imageCache = [String: UIImage]()
    let dateformatter = DateFormatter()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoSelectionCollectionViewController: PhotoSelectionCollectionViewController!

    private override init () {
        dateformatter.timeStyle = DateFormatter.Style.none
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.dateFormat = "dd MMM yyyy"
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(progressPoints.count)
        return progressPoints.count + 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row == progressPoints.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addReuseIdentifier,
                                                          for: indexPath)

                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.borderWidth = 1.0

                return cell
        } else {
            let progressPoint: ProgressPoint = progressPoints[indexPath.row]
            let progressCollection = progressPoint.progressCollection as ProgressCollection

            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: bodyReuseIdentifier,
                                                           for: indexPath) as? ProgressPointCollectionViewCell)!

            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            cell.progressPicImageView.layer.shouldRasterize = true
            cell.progressPicImageView.layer.rasterizationScale = UIScreen.main.scale

            cell.selectedBackgroundView = UIView(frame: cell.bounds)
            cell.selectedBackgroundView?.backgroundColor = UIColor.blue
            cell.progressPicImageView.image = nil

            if let image = imageCache[progressPoint.imageName] {

                cell.progressPicImageView.image = image
                
            } else {
                if let image = progressPoint.getImage(.low) {
                    self.imageCache[progressPoint.imageName] = image
                    cell.progressPicImageView.image = image
                }
            }

            cell.date.text = dateformatter.string(from: progressPoint.date)

            cell.contentView.frame = cell.bounds
            cell.contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]

            cell.layer.borderColor = UIColor(rgba: progressCollection.colour).cgColor
            cell.layer.borderWidth = 1.0
            return cell
        }
    }

    func syncImages() {
        imageCache.removeAll(keepingCapacity: false)
        for point in progressPoints {
            
            DispatchQueue.global(qos: .background).async {
                print("populated cache with \(point.imageName)")
                self.imageCache[point.imageName] = point.getImage(.high)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 8, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8 * 3
        let side: CGFloat = collectionView.frame.width / 2
        let sideMinusPadding: CGFloat = side - padding
        return CGSize(width: sideMinusPadding, height: sideMinusPadding + 44)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == progressPoints.count {
            photoSelectionCollectionViewController.showActionSheet()
        } else if selectMode {
            selectedProgressPoints.append(progressPoints[indexPath.row])
            if let cell = collectionView.cellForItem(at: indexPath) as? ProgressPointCollectionViewCell {

                cell.layer.borderWidth = 6
            }

            if selectedProgressPoints.count == 2 {
                photoSelectionCollectionViewController.progressPointsToCompare =
                    ProgressPointsToCompare(firstProgressPoint: selectedProgressPoints.first!,
                                            secondProgressPoint: selectedProgressPoints.last!)
                deselectAllCellsInCollectionView()
                photoSelectionCollectionViewController.performSegue(withIdentifier: segueToCompareTabBar,
                                                                    sender: photoSelectionCollectionViewController)
            }
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? ProgressPointCollectionViewCell {
                cell.isSelected = false
            }
            photoSelectionCollectionViewController.selectedProgressPoint = progressPoints[indexPath.row]
            photoSelectionCollectionViewController.performSegue(withIdentifier: "ShowProgressPointDetailId",
                                                                sender: photoSelectionCollectionViewController)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row != progressPoints.count {
            let progressPoint = progressPoints[indexPath.row]

            let index = selectedProgressPoints.index(of: progressPoint)

            if let index = index {
                selectedProgressPoints.remove(at: index)
            }

            if let cell = collectionView.cellForItem(at: indexPath) as? ProgressPointCollectionViewCell {

                cell.layer.borderWidth = 1
            }

        }
    }

    func deselectAllCellsInCollectionView() {
        for indexPath in collectionView.indexPathsForSelectedItems! {
            collectionView(collectionView, didDeselectItemAt: indexPath)
        }
    }
}
