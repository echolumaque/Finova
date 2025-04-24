//
//  UICollectionViewLayoutHelper.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import UIKit

struct UICollectionViewLayoutHelper {
    static func createListFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: width, height: 250)
        
        return flowLayout
    }
    
    static func listLayout(
        interGroupSpacing: CGFloat,
        showsSeparators: Bool = false,
        leadingAction: ((IndexPath) -> UISwipeActionsConfiguration)? = nil,
        trailingAction: ((IndexPath) -> UISwipeActionsConfiguration)? = nil
    ) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
            listConfig.showsSeparators = showsSeparators
            listConfig.leadingSwipeActionsConfigurationProvider = leadingAction
            listConfig.trailingSwipeActionsConfigurationProvider = trailingAction
            
            let section = NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
            section.interGroupSpacing = interGroupSpacing
            return section
        }
        
        return layout
    }
    
    static func createVerticalCompositionalLayout(
        itemSize: NSCollectionLayoutSize,
        groupSize: NSCollectionLayoutSize,
        interGroupSpacing: CGFloat,
        hasHeader: Bool = false
    ) -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpacing
        
        if hasHeader {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
//            header.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [header]
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    static func createHorizontalCompositionalLayout(
        size: NSCollectionLayoutSize,
        interGroupSpacing: CGFloat,
        visibleItemsInvalidationHandler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler? = nil
    ) -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        
        // Create the section with the group and enable horizontal scrolling
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = interGroupSpacing
        section.visibleItemsInvalidationHandler = visibleItemsInvalidationHandler
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    static func createHorizontalCompositionalLayout(
        itemSize: NSCollectionLayoutSize,
        groupSize: NSCollectionLayoutSize,
        interGroupSpacing: CGFloat,
        visibleItemsInvalidationHandler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler? = nil
    ) -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Create the section with the group and enable horizontal scrolling
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = interGroupSpacing
        section.visibleItemsInvalidationHandler = visibleItemsInvalidationHandler
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
