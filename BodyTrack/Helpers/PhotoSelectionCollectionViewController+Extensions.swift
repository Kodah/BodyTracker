//
//  ProgressPointCollectionViewHelper.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 18/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

fileprivate let bodyReuseIdentifier = "BodyCollectionViewCellId"
fileprivate let addReuseIdentifier = "AddCollectionViewId"

var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = DateFormatter.Style.none
    formatter.dateStyle = DateFormatter.Style.short
    formatter.dateFormat = "dd MMM yyyy"
    return formatter
}()

extension PhotoSelectionCollectionViewController: UICollectionViewDelegateFlowLayout, SegueHandlerType {

    enum SegueIdentifier: String {
        case segueToCompareTabBar = "GoToCompareSegueId"
        case segueToProgressPoint = "ShowProgressPointDetailId"
        case segueToEditCollection = "EditProgressCollectionSegue"
        case segueToCustomCamera = "ShowCustomCamera"
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(progressPoints.count)
        return progressPoints.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row == progressPoints.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addReuseIdentifier,
                                                          for: indexPath)

                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.borderWidth = 1.0

                return cell
        } else {
            let progressPoint: ProgressPoint = progressPoints[indexPath.row]
            let progressCollection = progressPoint.progressCollection! as ProgressCollection

            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: bodyReuseIdentifier,
                                                           for: indexPath) as? ProgressPointCollectionViewCell)!

            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            cell.progressPicImageView.layer.shouldRasterize = true
            cell.progressPicImageView.layer.rasterizationScale = UIScreen.main.scale

            cell.selectedBackgroundView = UIView(frame: cell.bounds)
            cell.selectedBackgroundView?.backgroundColor = UIColor.blue
            cell.progressPicImageView.image = nil

            if let image = imageCache[progressPoint.imageName!] {

                cell.progressPicImageView.image = image
                
            } else {
                if let image = progressPoint.getImage(.low) {
                    self.imageCache[progressPoint.imageName!] = image
                    cell.progressPicImageView.image = image
                }
            }

            cell.date.text = dateFormatter.string(from: progressPoint.date as! Date)

            cell.contentView.frame = cell.bounds
            cell.contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]

            cell.layer.borderColor = UIColor(rgba: progressCollection.colour!).cgColor
            cell.layer.borderWidth = 1.0
            return cell
        }
    }

    func syncImages() {
        imageCache.removeAll(keepingCapacity: false)
        
        DispatchQueue.global(qos: .background).async {
            for point in self.progressPoints {
                print("populated cache with \(point.imageName)")
                self.imageCache[point.imageName!] = point.getImage(.high)
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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == progressPoints.count {
            showActionSheet()
        } else if selectMode {
            selectedProgressPoints.append(progressPoints[indexPath.row])

            if selectedProgressPoints.count == 2 {
                progressPointsToCompare =
                    ProgressPointsToCompare(firstProgressPoint: selectedProgressPoints.first!,
                                            secondProgressPoint: selectedProgressPoints.last!)
                performSegue(withIdentifier: SegueIdentifier.segueToCompareTabBar,
                                                                    sender: self)
                
                deselectAllCellsInCollectionView()
                selectedProgressPoints.removeAll()
                rightBarButtonTapped()
                
            }
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? ProgressPointCollectionViewCell {
                cell.isSelected = false
            }
            selectedProgressPoint = progressPoints[indexPath.row]
            deselectAllCellsInCollectionView()
            performSegue(withIdentifier: SegueIdentifier.segueToProgressPoint,
                                                                sender: self)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row != progressPoints.count {
            let progressPoint = progressPoints[indexPath.row]

            let index = selectedProgressPoints.index(of: progressPoint)

            if let index = index {
                selectedProgressPoints.remove(at: index)
            }
        }
    }
    
    func deselectAllCellsInCollectionView() {
        if let collectionView = collectionView {
            for indexPath in collectionView.indexPathsForSelectedItems! {
                collectionView.deselectItem(at: indexPath, animated: false)
            }
        }
    }
}
